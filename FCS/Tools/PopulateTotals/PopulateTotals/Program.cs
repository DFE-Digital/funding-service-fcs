using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using Mono.Options;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

namespace PopulateTotals
{
    internal class ParentAndChildPolicyDeliverable
    {
        public PolicyDeliverable parentPolicyDeliverable { get; set; }
        public string parentPolicyDeliverableCode { get; set; }
        public List<string> childDeliverableCodes { get; set; } 
    }

    internal class DeliverableInfo
    {
        // if we needed to support more than 3 levels of deliveries in the allocation's delivery hierarchy, would need a list of lists,
        // but we don't so we keep it simple and have a root, and mid level

        public ParentAndChildPolicyDeliverable rootLevelParentChildren { get; set; }
        public List<ParentAndChildPolicyDeliverable> midLevelsParentChildren { get; set; }
    }

    internal class Deliverable
    {
        public Guid id { get; set; }
        public string code { get; set; }
        public decimal? actualValue { get; set; }
        public Guid allocationId { get; set; }
        public string allocationRef { get; set; }
    }

    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //TODO: this looks wrong: 4e02be4d-6453-e511-80d8-000d3a20739e, 16AP-3479, 6, 511009.2900000000
                //TODO: would it be better to reference packages from the same location as the datastore, otherwise could be out of sync?
                //TODO: phase 1 could use parallel for to speed it up
                //note: if started this afresh, would probably switch to early bound

                bool forReal = false;
                bool debugOutput = false;
                bool showHelp = false;

                var p = new OptionSet {
                    { "r|forreal", "Update actual values for real, rather than just document the actions that would be taken",
                       v => forReal = true },
                    { "d|debug", "increase debug message verbosity",
                       v => debugOutput = true },
                    { "h|?|help",  "show this message and exit",
                       v => showHelp = true }
                };

                List<string> extra;
                try
                {
                    extra = p.Parse(args);
                }
                catch (OptionException e)
                {
                    Console.Write("PopulateTotals: ");
                    Console.WriteLine(e.Message);
                    Console.WriteLine("Try `PopulateTotals /?' for more information.");
                    return;
                }

                if (showHelp) {
                    ShowHelp(p);
                    return;
                }

                if (!Environment.Is64BitOperatingSystem || !Environment.Is64BitProcess)
                {
                    Console.Error.WriteLine("Aborting. Needs to run as a 64-bit executable on a 64-bit OS!");
                    Console.Error.WriteLine($"Is64BitOperatingSystem:{Environment.Is64BitOperatingSystem}, Is64BitProcess:{Environment.Is64BitProcess}");
                }

                var connection = new CrmConnection("Crm");

                using (var service = new OrganizationService(connection))
                {
                    using (var context = new CrmOrganizationServiceContext(service))
                    {
                        // Phase 1
                        // Update all Deliverables that have some Periods with populated Actual Value's

                        SetActualValueForAllDeliverablesWithPeriods(service, context, debugOutput, forReal);

                        // Phase 2
                        // Update all parent deliverables by summing all their immediate children

                        SetActualValueForAllNonPayableParentDeliverables(service, context, debugOutput, forReal);
                    }
                }
                Console.WriteLine($"Finished @ {DateTime.Now.ToString("s")}");
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Exception!");
                Console.Error.WriteLine(ex.ToString());
                throw;
            }
        }

        private static void SetActualValueForAllDeliverablesWithPeriods(OrganizationService service, CrmOrganizationServiceContext context, bool debugOutput, bool forReal)
        {
            // set all the 'leaf node' deliverables

            Console.WriteLine("Phase 1: Update all (PoA) Deliverables that have some Periods with populated Actual Value's");
            Console.WriteLine($"Started @ {DateTime.Now.ToString("s")}");
            Console.WriteLine("");
            Console.WriteLine("Deliverable Id, Allocation Id, Allocation Number, Deliverable Code, New Actual Value");
            Console.WriteLine("------------------------------------------------------------------------------------");

            List<string> fundingStreamPeriods;
            using (var policyContext = new PaymentManagementPolicyContext())
            {
                // not all deliverables have a root, so we have to update deliverables for all fsp's
                fundingStreamPeriods = (from fsp in policyContext.PolicyFundingStreamPeriods select fsp.FundingStreamPeriod).ToList();
            }

            //TODO: optimise this
            // filter by deliverables with actuals?? safer (more targeted), quicker, less chance of message too big. but waste of time for 1 off process??

            // add ispayable deliverable codes to poaFspToDeliverableInfo?

            foreach (var fspCode in fundingStreamPeriods)
            {
                // we could filter out deliverables with an actual value here, but then we'd lose the check
                var allDeliverables = from deliverable in context.CreateQuery("sfa_contractdeliverable")
                                      join allocation in context.CreateQuery("sfa_contractallocation")
                                      on deliverable["sfa_contractallocationid"] equals allocation["sfa_contractallocationid"]
                                      join fsp in context.CreateQuery("sfa_fundingstreamperiod")
                                      on allocation["sfa_fundingstreamperiodid"] equals fsp["sfa_fundingstreamperiodid"]
                                      where (string)fsp["sfa_fundingstreamperiodcode"] == fspCode
                                      select new Deliverable
                                      {
                                          id = (Guid)deliverable["sfa_contractdeliverableid"],
                                          code = (string)deliverable["sfa_deliverablecode"],
                                          actualValue = (decimal?)(deliverable.Contains("sfa_actualvalue") ? deliverable["sfa_actualvalue"] : null),
                                          allocationId = (Guid)allocation["sfa_contractallocationid"],
                                          allocationRef = (string)allocation["sfa_contractallocationnumber"]
                                      };

                // we can only do this if we use ToList, and eschew paging
                //if (debugOutput)
                //    Console.WriteLine($"Found {allDeliverables.ToList().Count()} deliverables");

                var totalEntitiesProcessed = ForEachEntityPaged(allDeliverables, deliverable =>
                {
                    // dynamics doesn't support null checks in linq/FetchXm engine!
                    // https://community.dynamics.com/crm/f/117/t/190906
                    var deliverablePeriod = context.CreateQuery("sfa_contractdeliverableperiod")
                        .Where(dp => (Guid)dp["sfa_contractdeliverableid"] == deliverable.id
                        ).ToList()
                        .Where(dp => dp.Attributes.Contains("sfa_actualvalue")).ToList();

                    //var deliverablePeriod = context.CreateQuery("sfa_contractdeliverableperiod")
                    //    .Where(dp => (Guid)dp["sfa_contractdeliverableid"] == deliverable.id && dp.Contains("sfa_actualvalue")).ToList();

                    // only set actual value total if there are any non-null actual values within this deliverable's periods
                    if (!deliverablePeriod.Any())
                    {
                        if (debugOutput)
                            Console.WriteLine($"{deliverable.id}, {deliverable.allocationId}, {deliverable.allocationRef}, {deliverable.code}, No dp's with actual values");
                    }
                    else
                    {
                        var totalActualValue = deliverablePeriod.Sum(dp => (decimal?) dp["sfa_actualvalue"] ?? 0m);

                        UpdateDeliverablesActualValue(service, deliverable, totalActualValue, forReal);
                    }
                });

                if (debugOutput)
                    Console.WriteLine($"Total deliverables processed for {fspCode} = {totalEntitiesProcessed}");

                ForceGarbageCollection();
            }
        }

        private static void SetActualValueForAllNonPayableParentDeliverables(OrganizationService service, CrmOrganizationServiceContext context, bool debugOutput, bool forReal)
        {
            Console.WriteLine("Phase 2: Update all parent PoA deliverables by summing all their immediate children");
            Console.WriteLine($"Started @ {DateTime.Now.ToString("s")}");
            Console.WriteLine("");
            Console.WriteLine("Allocation Id, Allocation Number, Deliverable Code, New Actual Value");
            Console.WriteLine("--------------------------------------------------------------------");

            var poaFspToDeliverableInfo = RetrieveDeliverableInfo();

            // if !forreal, all parent deliverables are not going to register because all their children are still gonna have null actual values
            if (!forReal)
                Console.WriteLine("As no child deliverable's Actual Values were actually set, we don't expect any parent deliverables to be set");

            foreach (var fspCode in poaFspToDeliverableInfo.Keys)
            {
                // note: some allocations don't have an associated fundingstreamperiodid, so they will be missed
                //       but hopefully there shouldn't be any of them in live

                //TODO: link to contract and approved only? might need multiple where's for joins according to docs

                var fspAllocations = (from allocation in context.CreateQuery("sfa_contractallocation")
                                      join fsp in context.CreateQuery("sfa_fundingstreamperiod")
                                          on allocation["sfa_fundingstreamperiodid"] equals fsp["sfa_fundingstreamperiodid"]
                                      where (string)fsp["sfa_fundingstreamperiodcode"] == fspCode
                                      select allocation);

                // we can only do this if we use ToList, and eschew paging
                //if (debugOutput)
                //    Console.WriteLine($"Found {fspAllocations.Count()} {fspCode} allocations");

                ForEachEntityPaged(fspAllocations, allocation =>
                {
                    if (debugOutput)
                        Console.WriteLine($"Found allocation:{allocation["sfa_contractallocationnumber"]}, fsp:{fspCode}");

                    // this code assumes that there are only a max of 2 layers of parent PoA deliverables (which is currently true!)

                    var allocationsDeliverables =
                        from del in context.CreateQuery("sfa_contractdeliverable")
                        join alloc in context.CreateQuery("sfa_contractallocation")
                            on del["sfa_contractallocationid"] equals alloc["sfa_contractallocationid"]
                        where del["sfa_contractallocationid"] == allocation["sfa_contractallocationid"]
                        select new Deliverable
                        {
                            id = (Guid)del["sfa_contractdeliverableid"],
                            code = (string)del["sfa_deliverablecode"],
                            actualValue = (decimal?)(del.Contains("sfa_actualvalue") ? del["sfa_actualvalue"] : null),
                            allocationId = (Guid)alloc["sfa_contractallocationid"],
                            allocationRef = (string)alloc["sfa_contractallocationnumber"]
                        };

                    DeliverableInfo fspDeliverableInfo = poaFspToDeliverableInfo[fspCode];

                    // we have to sum the mid level deliverables first

                    decimal? midLevelsSum = null;

                    foreach (var midLevelParentChild in fspDeliverableInfo.midLevelsParentChildren)
                    {
                        var midLevelSum = SumAndSetParentsActualValue(service, allocationsDeliverables, midLevelParentChild, forReal);

                        if (midLevelSum.HasValue)
                            if (midLevelsSum.HasValue)
                                midLevelsSum += midLevelSum;
                            else
                                midLevelsSum = midLevelSum;
                    }

                    // when we have mid-level deliverables, we can sum them to calculate the root value
                    // which 1) allows us to report the correct value when !forReal (except we can't because all the child 'actual value's won't have been updated!)
                    //       2) is an optimisation over refetching the root's child deliverables which we just updated
                    if (fspDeliverableInfo.midLevelsParentChildren.Any())
                    {
                        // this will only work for allocations with mid-level deliverables
                        if (midLevelsSum.HasValue)
                        {
                            SetActualValue(service, allocationsDeliverables,
                                fspDeliverableInfo.rootLevelParentChildren.parentPolicyDeliverableCode,
                                midLevelsSum.Value, forReal);
                        }
                    }
                    else
                    {
                        // allocation only has a root level parent (no mid-level parents), so we have to read in the roots childen to sum
                        SumAndSetParentsActualValue(service, allocationsDeliverables, fspDeliverableInfo.rootLevelParentChildren, forReal);
                    }
                });

                ForceGarbageCollection();
            }
        }

        private static void UpdateDeliverablesActualValue(OrganizationService service, Deliverable deliverable, decimal totalActualValue, bool forReal)
        {
            Console.WriteLine($"{deliverable.id}, {deliverable.allocationId}, {deliverable.allocationRef}, {deliverable.code}, {totalActualValue}");

            if (deliverable.actualValue.HasValue)
            {
                if (deliverable.actualValue == totalActualValue)
                    return;

                Console.Error.WriteLine($"Difference of opinion for deliverable id {deliverable.id}. Existing {deliverable.actualValue}. Calculating {totalActualValue}.");

                // which do we go with? let's go with the newly calculated value!
            }

            if (!forReal)
                return;

            var updateDeliverable = new Entity("sfa_contractdeliverable")
            {
                Id = deliverable.id,
                ["sfa_actualvalue"] = totalActualValue
            };
            service.Update(updateDeliverable);
        }

        private static Dictionary<string, DeliverableInfo> RetrieveDeliverableInfo()
        {
            var poaFspToDeliverableInfo = new Dictionary<string, DeliverableInfo>();

            using (var policyContext = new PaymentManagementPolicyContext())
            {
                //var rootlevelDeliverables = (from deliverable in policyContext.PolicyDeliverables
                //                             join childDeliverable in policyContext.PolicyDeliverables
                //                             on deliverable.DeliverableCode equals childDeliverable.ParentDeliverableCode
                //                             where deliverable.DeliverableCode == 1
                //                             select deliverable).ToList();

                var candidateRootlevelDeliverables = (from deliverable in policyContext.PolicyDeliverables
                                             where deliverable.DeliverableCode == 1
                                             select deliverable).ToList();

                var rootLevelDeliverables = candidateRootlevelDeliverables.Where(c =>
                        policyContext.PolicyDeliverables.Any(d => 
                            d.FundingStreamPeriod == c.FundingStreamPeriod && d.ParentDeliverableCode == c.DeliverableCode)).ToList();

                foreach (var rootLevelDeliverable in rootLevelDeliverables)
                {
                    var deliverableInfo = new DeliverableInfo
                    {
                        rootLevelParentChildren = new ParentAndChildPolicyDeliverable
                        {
                            parentPolicyDeliverable = rootLevelDeliverable,
                            parentPolicyDeliverableCode = rootLevelDeliverable.DeliverableCode.ToString(),
                            childDeliverableCodes = (from deliverable in policyContext.PolicyDeliverables
                                                        where deliverable.FundingStreamPeriod == rootLevelDeliverable.FundingStreamPeriod
                                                            && deliverable.ParentDeliverableCode == rootLevelDeliverable.DeliverableCode
                                                        select deliverable.DeliverableCode.ToString()).ToList()
                        },
                        midLevelsParentChildren = new List<ParentAndChildPolicyDeliverable>()
                    };

                    // we could use the root level's childDeliverableCodes (which would make this 'level>3' compatible if we iterated)

                    var candidateMidLevelDeliverables = 
                        (from deliverable in policyContext.PolicyDeliverables
                         where deliverable.FundingStreamPeriod == deliverableInfo.rootLevelParentChildren.parentPolicyDeliverable.FundingStreamPeriod
                            //&& deliverableInfo.rootLevelParentChildren.childDeliverableCodes.Contains(deliverable.DeliverableCode.ToString())
                            && deliverable.ParentDeliverableCode == 1
                         select deliverable).ToList();

                    var midLevelParentDeliverables = candidateMidLevelDeliverables.Where(c =>
                        policyContext.PolicyDeliverables.Any(d =>
                            d.FundingStreamPeriod == c.FundingStreamPeriod
                            && d.ParentDeliverableCode == c.DeliverableCode)).ToList();

                    foreach (var midLevelParentDeliverable in midLevelParentDeliverables)
                        {
                            //todo linq this
                            deliverableInfo.midLevelsParentChildren.Add(new ParentAndChildPolicyDeliverable
                            {
                                parentPolicyDeliverable = midLevelParentDeliverable,
                                parentPolicyDeliverableCode = midLevelParentDeliverable.DeliverableCode.ToString(),
                                childDeliverableCodes = (from deliverable in policyContext.PolicyDeliverables
                                                            where deliverable.FundingStreamPeriod == midLevelParentDeliverable.FundingStreamPeriod
                                                                && deliverable.ParentDeliverableCode == midLevelParentDeliverable.DeliverableCode
                                                            select deliverable.DeliverableCode.ToString()).ToList()
                            });
                        }
                        poaFspToDeliverableInfo.Add(rootLevelDeliverable.FundingStreamPeriod, deliverableInfo);
                    }
            }
            return poaFspToDeliverableInfo;
        }

        private static decimal? SumAndSetParentsActualValue(OrganizationService service, IEnumerable<Deliverable> allocationsDeliverables, ParentAndChildPolicyDeliverable parentChildDeliverables, bool forReal)
        {
            var allocationsChildDeliverables = allocationsDeliverables.Where(d => parentChildDeliverables.childDeliverableCodes.Contains(d.code)).ToList();

            var childDeliverablesWithActualValues = allocationsChildDeliverables.Where(d => d.actualValue.HasValue).ToList();

            if (!childDeliverablesWithActualValues.Any())
                return null;

            // we've already filtered out null actualValue's, so the ?? isn't strictly necessary
            var parentsSumActualValue = childDeliverablesWithActualValues.Sum(d => d.actualValue ?? 0m);

            SetActualValue(service, allocationsDeliverables, parentChildDeliverables.parentPolicyDeliverableCode, parentsSumActualValue, forReal);

            return parentsSumActualValue;
        }

        private static void SetActualValue(OrganizationService service, IEnumerable<Deliverable> allocationsDeliverables,
            string deliverableCode, decimal actualValue, bool forReal)
        {
            var parentDeliverable = allocationsDeliverables.First(d => d.code == deliverableCode);    // TODO: think we have this kicking about anyway, so no need to re find

            UpdateDeliverablesActualValue(service, parentDeliverable, actualValue, forReal);
        }

        private static int ForEachEntityPaged<T>(IQueryable<T> query, Action<T> action, int pageSize = 400)
        {
            // without explicit paging, paging happens behind the scenes (5000 at a time), and you get the whole lot in one go

            int pageStart = 0, actualEntitiesInThisPage = pageSize, totalEntitiesActioned = 0;

            while (actualEntitiesInThisPage == pageSize)
            {
                var page = query.Skip(pageStart).Take(pageSize);

                // Any() & Count() aren't supported, so we manually count the entities returned

                actualEntitiesInThisPage = 0;

                foreach (var entity in page)
                {
                    action(entity);
                    ++actualEntitiesInThisPage;
                    ++totalEntitiesActioned;
                }

                pageStart += pageSize;
            }

            return totalEntitiesActioned;
        }

        private static void ForceGarbageCollection()
        {
            GC.Collect();
            GC.WaitForPendingFinalizers();
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }

        private static void ShowHelp(OptionSet p)
        {
            Console.WriteLine("Usage: PopulateTotals");
            Console.WriteLine("Update Actual Totals for deliverables.");
            Console.WriteLine("Supply /forreal option to actually update the totals.");
            Console.WriteLine();
            Console.WriteLine("Options:");
            p.WriteOptionDescriptions(Console.Out);
        }
    }
}
