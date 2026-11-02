namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Extensions;

    public static class EfaAllocationAggregator
    {
        public static IReadOnlyCollection<contractAllocationsContractAllocation> AggregateDeliverablePeriodValueWithTheSameFsp(
            IReadOnlyCollection<contractAllocationsContractAllocation> allocations)
        {
            List<IGrouping<string, contractAllocationsContractAllocation>> allocationsWithTheSameFspGroups = allocations.GroupBy(a => a.fundingStreamPeriodCode).ToList();
            List<contractAllocationsContractAllocation> aggregatedAllocations = new List<contractAllocationsContractAllocation>();
            foreach (IGrouping<string, contractAllocationsContractAllocation> allocationsWithTheSameFspGroup in allocationsWithTheSameFspGroups)
            {
                // we use the first one to hold the aggregated values
                contractAllocationsContractAllocation allocation = allocationsWithTheSameFspGroup.First().Clone();
                aggregatedAllocations.Add(allocation);

                // we need to add deliverables to this allocation that exist on the other allocations but not this one
                IReadOnlyCollection<int> distinctDeliverableCodesOnFirstAllocation =
                    allocation.contractDeliverables.Select(d => d.deliverable.deliverableCode).ToList();

                IEnumerable<deliverableType> missingDeliverableTypes = GetMissingDeliverablesTypes(allocationsWithTheSameFspGroup.ToList(),
                    distinctDeliverableCodesOnFirstAllocation);

                // fill in the missing deliverables with a empty set of period values
                allocation.contractDeliverables.AddRange(missingDeliverableTypes.Select(md => new contractDeliverablesTypeContractDeliverable
                {
                    deliverable = md,
                    contractDeliverablePeriods = CreateEmptyContractDeliverablePeriods(basedOnTheseContractDeliverablePeriods: allocation.contractDeliverables.First().contractDeliverablePeriods)
                }));

                foreach (var contractDeliverable in allocation.contractDeliverables)
                {
                    // get all the deliverables with this deliverableCode
                    IEnumerable<contractDeliverablesTypeContractDeliverable> deliverablesWithTheSameDeliverableCode =
                        allocationsWithTheSameFspGroup.SelectMany(
                            a =>
                                a.contractDeliverables.Where(
                                    cd =>
                                        cd.deliverable.deliverableCode ==
                                        contractDeliverable.deliverable.deliverableCode)).ToList();

                    contractDeliverable.contractDeliverablePeriods.ForEach(cdp => cdp.plannedValue = AggregatePlannedValues(cdp.periodName, deliverablesWithTheSameDeliverableCode));
                }
            }

            return aggregatedAllocations;
        }

        private static decimal AggregatePlannedValues(string periodName, IEnumerable<contractDeliverablesTypeContractDeliverable> deliverablesWithTheSameDeliverableCode)
        {
            return deliverablesWithTheSameDeliverableCode.Sum(d => d.contractDeliverablePeriods
                               .Where(cdp => cdp.periodName == periodName)
                               .Select(cdp => cdp.plannedValue).Sum());
        }

        private static List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateEmptyContractDeliverablePeriods(List<contractDeliverablePeriodsTypeContractDeliverablePeriod> basedOnTheseContractDeliverablePeriods)
        {
            return basedOnTheseContractDeliverablePeriods.Select(cdp => new contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                displayOrder = cdp.displayOrder,
                aggregate = cdp.aggregate,
                period = cdp.period,
                periodName = cdp.periodName,
                periodType = cdp.periodType,
                year = cdp.year
            }).ToList();
        }

        private static IEnumerable<deliverableType> GetMissingDeliverablesTypes(IReadOnlyCollection<contractAllocationsContractAllocation> allocationsWithTheSameFspGroup,
            IReadOnlyCollection<int> deliverableCodesToExclude)
        {
            return allocationsWithTheSameFspGroup.SelectMany(a => a.contractDeliverables)
                    .Where(cd => !deliverableCodesToExclude.Contains(cd.deliverable.deliverableCode))
                    .Select(cd => cd.deliverable)
                    .Distinct()
                    .ToList();
        }
    }
}
