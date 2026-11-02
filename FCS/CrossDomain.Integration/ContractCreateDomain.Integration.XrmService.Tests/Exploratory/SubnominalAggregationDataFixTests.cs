namespace ContractCreateDomain.Integration.XrmService.Tests.Exploratory
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using MoreLinq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using UnitTests.Common;

    [TestClass]
    public class SubnominalAggregationDataFixTests
    {
        private static IOrganizationService OrganizationService
            =>
                new OrganizationService(
                    CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString));

        private static object _lockObject = new object();

        private IReadOnlyCollection<string> _payableFspsWithDeliverableCodes = null;
        private IReadOnlyCollection<PolicyDeliverableToSubnominals> _allDeliverableToSubnominals;

        [TestMethod, TestCategory("TechnicalExploration")]
        public void SubnominalAggregationToContractDeliverablePeriodDataFix()
        {
            System.Diagnostics.Trace.WriteLine("Started...");

            // relate unrelated CDPs
            ParallelProcessor.ProcessCommand(
                getAllItems: () => GetAllocationInfos().ToList(),
                command: RelateContractDeliverablePeriodInfosForAllocationsWhereRelationshipMissing
                );

            System.Diagnostics.Trace.WriteLine("Finished.");
        }

        [TestMethod, TestCategory("DataFix_R16a")]
        public void SubnominalAggregationToAllocationDataFix()
        {
            ParallelProcessor.ProcessCommand(() => GetAllocationInfos().ToList(), UpdateAllocation);
        }

        [TestMethod, TestCategory("DataFix_R16a")]
        public void SubnominalAggregationToContractDeliverablePeriodDataFix_WithSpreadSheet()
        {
            var saLines = GetLinesFromCsv(@"ContractCreateDomain.Integration.XrmService.Tests",
                "Exploratory.Resources.orphanedSubnominalAggregations.csv")
                .ToList();

            saLines.ForEach(GetSubnominalInfosForSubnominalAggregationSetAndRelate);
        }

        private IEnumerable<string> GetLinesFromCsv(string resourcePath, string resourceName)
        {
            using (var resource = new TestResource(resourcePath, resourceName))
            {
                StreamReader reader = new StreamReader(resource.Stream);
                reader.ReadLine();
                IList<string> lines = new List<string>();
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    lines.Add(line);
                }

                return lines;
            }
        }

        private void GetSubnominalInfosForSubnominalAggregationSetAndRelate(string saLine)
        {
            var seperatedLine = saLine.Split(',');
            var subInfo = new SubnominalInfo(Guid.Parse(seperatedLine[0]), seperatedLine[1], (sfa_paymenttype)int.Parse(seperatedLine[2]));
            ActionRetrier.RetryWhenExceptionThrown(
                action:() => RelateContractDeliverablePeriodInfosForAllocationsWhereRelationshipMissing(subInfo),
                numRetries: 10,
                numSecondsToWaitBetweenRetries: 5);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void SubnominalAggregationTestUpdateofContractDeliverablePeriodForIndividual()
        {
            var subInfo = new SubnominalInfo(Guid.Parse("52248673-DED0-E511-80C6-000D3A2041D6"), "2306871_ASTO-2769_Aug-15", (sfa_paymenttype)229660001);
            ActionRetrier.RetryWhenExceptionThrown(
                action: () => RelateContractDeliverablePeriodInfosForAllocationsWhereRelationshipMissing(subInfo),
                numRetries: 10,
                numSecondsToWaitBetweenRetries: 5);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void SubnominalAggregationTestUpdateofContractDeliverablePeriod()
        {
            sfa_subnominalaggregation subnominalaggregation = null;
            sfa_contractdeliverableperiod contractdeliverableperiod = null;
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                subnominalaggregation = xrmContext.sfa_subnominalaggregationSet.First();

                contractdeliverableperiod = xrmContext.sfa_contractdeliverableperiodSet.Take(9).ToList().Last();
            }

            RelatedCdpToSubnominalAggregation(
                new SubnominalInfo(subnominalaggregation.Id, subnominalaggregation.sfa_PaymentTypeEnum.Value),
                contractdeliverableperiod.Id, contractdeliverableperiod.sfa_ContractDeliverableId);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ShouldUpdateAllocation()
        {
            IList<AllocationInfo> allocationInfos = new List<AllocationInfo>
            {
                new AllocationInfo("EMPAGE-2488", "AGE-2488", 3, "AGE1516")
            };

            UpdateAllocation(allocationInfos);
        }

        private void UpdateAllocation(IEnumerable<AllocationInfo> allocationInfos)
        {
            Guid instanceGuid = Guid.NewGuid();
            System.Diagnostics.Trace.WriteLine($"Started group {instanceGuid}");

            allocationInfos.ForEach(
                ai =>
                {
                    EntityCollection subnominalAggregatsionsRelatedInLinkTable = GetRelatedRecords(ai.AllocationNumber);
                    IReadOnlyCollection<Guid> subnominalAggregatsionIdsRelatedInLinkTable =
                        subnominalAggregatsionsRelatedInLinkTable.Entities.Select(
                            e => (Guid)e.GetAttributeValue("sfa_subnominalaggregationid")).ToList();

                    IReadOnlyCollection<Guid> subnominalAggregationGuids =
                        GetSubnominalIdsForAllocation(ai.AllocationNumber);

                    var unrelatedSubnominalAggregationIds =
                        subnominalAggregationGuids.Where(sa => !subnominalAggregatsionIdsRelatedInLinkTable.Contains(sa))
                            .ToList();

                    if (unrelatedSubnominalAggregationIds.Any())
                    {
                        Guid allocationGuid =
                            GetAllocationIdByAllocationNumberAndContractNumberAndVersionNumber(
                                ai.AllocationNumber,
                                ai.ContractNumber,
                                ai.VersionNumber);

                        unrelatedSubnominalAggregationIds.ForEach(
                            sg => AssociateToContractAllocation(allocationGuid, sg));
                    }

                });

            System.Diagnostics.Trace.WriteLine($"Finished group {instanceGuid}");
        }

        private void RelatedCdpToSubnominalAggregations(ContractDeliverablePeriodInfo contractDeliverablePeriodInfo)
        {
            IEnumerable<PolicyDeliverableToSubnominals> subnominals =
                GetSubnominalCodesForFspAndPeriod(contractDeliverablePeriodInfo.FspCode,
                    contractDeliverablePeriodInfo.DeliverableCode);
            List<SubnominalInfo> subnominalsThatCouldBeRelated = new List<SubnominalInfo>();

            foreach (var subnominal in subnominals)
            {
                string aggregateCode =
                    $"{subnominal.SubnominalCode}_{contractDeliverablePeriodInfo.AllocationNumber}_{contractDeliverablePeriodInfo.PeriodName}";
                IEnumerable<SubnominalInfo> relatedCrmSubnominalAggregations =
                    GetCrmSubnominalAggregations(aggregateCode);

                subnominalsThatCouldBeRelated.AddRange(relatedCrmSubnominalAggregations);
            }

            IEnumerable<SubnominalInfo> subnominalsWithDifferentPaymentTypes =
                subnominalsThatCouldBeRelated.GroupBy(s => s.PaymentType).Select(g => g.First());

            // remove payment types that are already linked
            subnominalsWithDifferentPaymentTypes = subnominalsWithDifferentPaymentTypes.Where(s => !contractDeliverablePeriodInfo.HasPaymentType(s.PaymentType));
            subnominalsWithDifferentPaymentTypes.ForEach(
                sa =>
                    RelatedCdpToSubnominalAggregation(sa, contractDeliverablePeriodInfo.ContractDeliverablePeriodId,
                        contractDeliverablePeriodInfo.ContractDeliverableId));
        }

        private void RelatedCdpToSubnominalAggregation(ContractDeliverablePeriodInfo contractDeliverablePeriodInfo, SubnominalInfo subnominalInfo)
        {
            if (!contractDeliverablePeriodInfo.HasPaymentType(subnominalInfo.PaymentType))
            {
                RelatedCdpToSubnominalAggregation(subnominalInfo, contractDeliverablePeriodInfo.ContractDeliverablePeriodId,
                    contractDeliverablePeriodInfo.ContractDeliverableId);
            }
        }

        private void RelatedCdpToSubnominalAggregation(SubnominalInfo subnominalaggregationInfo,
            Guid contractDeliverablePeriodId, EntityReference contractDeliverable)
        {
            sfa_contractdeliverableperiod contractdeliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = contractDeliverable,
                sfa_contractdeliverableperiodId = contractDeliverablePeriodId,
                Id = contractDeliverablePeriodId
            };

            if (subnominalaggregationInfo.PaymentType == sfa_paymenttype.Profile)
            {
                contractdeliverableperiod.sfa_profilesubnominal =
                    new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalaggregationInfo.Id);
            }

            if (subnominalaggregationInfo.PaymentType == sfa_paymenttype.Capping)
            {
                contractdeliverableperiod.sfa_CappingSubnominal =
                    new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalaggregationInfo.Id);
            }

            if (subnominalaggregationInfo.PaymentType == sfa_paymenttype.Reconciliation)
            {
                contractdeliverableperiod.sfa_reconciliationsubnominal =
                    new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalaggregationInfo.Id);
            }

            contractdeliverableperiod.EntityState = EntityState.Changed;

            lock (_lockObject)
            {
                OrganizationService organizationService = new OrganizationService(
                   CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString));

                organizationService.Update(contractdeliverableperiod);
            }
        }

        private IEnumerable<SubnominalInfo> GetCrmSubnominalAggregations(string aggregateCode)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var subnominals =
                    xrmContext.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalAggregateKey == aggregateCode)
                        .ToList();
                return subnominals.Select(s => new SubnominalInfo(s.Id, s.sfa_PaymentTypeEnum.Value));
            }
        }

        private IReadOnlyCollection<Guid> GetSubnominalIdsForAllocation(string allocNum)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                return
                    xrmContext.sfa_subnominalaggregationSet.Where(
                        sa => sa.sfa_SubnominalAggregateKey.Contains(allocNum))
                        .Select(sa => sa.Id)
                        .Distinct()
                        .ToList();
            }
        }

        private void RelateContractDeliverablePeriodInfosForAllocationsWhereRelationshipMissing(
            IEnumerable<AllocationInfo> allocationInfos)
        {
            Guid instanceGuid = Guid.NewGuid();
            System.Diagnostics.Trace.WriteLine($"Started group {instanceGuid}");
            IReadOnlyCollection<string> payableFspsWithDeliverableCodes = GetPayableFspsWithDeliverableCodes();

            allocationInfos.ForEach(ai =>
            {
                IEnumerable<ContractDeliverablePeriodInfo> contractDeliverablePeriodInfos = GetContractDeliverablePeriodInfosFromCrm
                    (
                        ai.ContractNumber,
                        ai.AllocationNumber);

                contractDeliverablePeriodInfos.ForEach(cdp => cdp.FspCode = ai.FundingStreamPeriodCode);

                var unrelatedCdps =
                    contractDeliverablePeriodInfos.Where(cdp => GetNumOfSubnominalsForFundingStreamPeriodAndDeliverableCode(cdp.FspCode, cdp.DeliverableCode) > cdp.NumSubnominalAggregationRelationship())
                    .ToList();

                // remove unpayable ones
                unrelatedCdps =
                    unrelatedCdps.Where(
                        cdp => payableFspsWithDeliverableCodes.Contains(cdp.FspCode + cdp.DeliverableCode)).ToList();

                unrelatedCdps.ForEach(RelatedCdpToSubnominalAggregations);

            });
            System.Diagnostics.Trace.WriteLine($"Finished group {instanceGuid}");
        }

        private void RelateContractDeliverablePeriodInfosForAllocationsWhereRelationshipMissing(SubnominalInfo subnominalInfo)
        {
            string[] aggregateKeyParts = subnominalInfo.AggregateKey.Split('_');
            var allocRef = aggregateKeyParts[1];
            var periodName = aggregateKeyParts[2];
            
            IEnumerable<ContractDeliverablePeriodInfo> contractDeliverablePeriodInfos = GetContractDeliverablePeriodInfosFromCrm(allocRef, subnominalInfo.PaymentType, periodName);

            contractDeliverablePeriodInfos.ForEach(cdp => RelatedCdpToSubnominalAggregation(cdp, subnominalInfo));
        }


        private IReadOnlyCollection<ContractDeliverablePeriodInfo> GetContractDeliverablePeriodInfosFromCrm(
            string contractNumber, string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var contractDeliverablePeriodIds = (from c in xrmContext.sfa_contractSet
                                                    join a in xrmContext.sfa_contractallocationSet on
                                                        c.sfa_contractId equals a.sfa_ContractId.Id
                                                    join d in xrmContext.sfa_contractdeliverableSet on
                                                        a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                                                    join dp in xrmContext.sfa_contractdeliverableperiodSet on
                                                        d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                                                    where (c.sfa_ContractStatus.Value.Equals(sfa_contractstatus.Approved)
                                                           || c.sfa_ContractStatus.Value.Equals(sfa_contractstatus.Replaced))
                                                          && c.sfa_number == contractNumber
                                                          && a.sfa_contractallocationnumber == allocationNumber
                                                          && (dp.sfa_ReconciliationPaymentAmount != null
                                                              || dp.sfa_ProfilePaymentAmount != null
                                                              || dp.sfa_CappedPaymentAmount != null)
                                                    select
                                                        new ContractDeliverablePeriodInfo(
                                                            dp.sfa_contractdeliverableperiodId.Value,
                                                            a.sfa_contractallocationnumber,
                                                            dp.sfa_profilesubnominal,
                                                            dp.sfa_CappingSubnominal,
                                                            dp.sfa_reconciliationsubnominal,
                                                            dp.sfa_PeriodName,
                                                            int.Parse(d.sfa_DeliverableCode),
                                                            dp.sfa_ContractDeliverableId)
                                                        { Entity = dp })
                    .ToList();

                return contractDeliverablePeriodIds;
            }
        }

        private IReadOnlyCollection<ContractDeliverablePeriodInfo> GetContractDeliverablePeriodInfosFromCrm(string allocationNumber, sfa_paymenttype payType, string periodName)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                IQueryable<ContractDeliverablePeriodInfo> contractDeliverablePeriodIds = (from c in xrmContext.sfa_contractSet
                                                    join a in xrmContext.sfa_contractallocationSet on
                                                        c.sfa_contractId equals a.sfa_ContractId.Id
                                                    join d in xrmContext.sfa_contractdeliverableSet on
                                                        a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                                                    join dp in xrmContext.sfa_contractdeliverableperiodSet on
                                                        d.sfa_contractdeliverableId equals
                                                        dp.sfa_ContractDeliverableId.Id
                                                    where
                                                        (c.sfa_ContractStatus.Value.Equals(sfa_contractstatus.Approved)
                                                         ||
                                                         c.sfa_ContractStatus.Value.Equals(sfa_contractstatus.Replaced))
                                                        && a.sfa_contractallocationnumber == allocationNumber
                                                    && (dp.sfa_ReconciliationPaymentAmount != null
                                                        || dp.sfa_ProfilePaymentAmount != null
                                                        || dp.sfa_CappedPaymentAmount != null)
                                                        && dp.sfa_PeriodName == periodName
                                                       
                                                    select
                                                        new ContractDeliverablePeriodInfo(
                                                            dp.sfa_contractdeliverableperiodId.Value,
                                                            a.sfa_contractallocationnumber,
                                                            dp.sfa_profilesubnominal,
                                                            dp.sfa_CappingSubnominal,
                                                            dp.sfa_reconciliationsubnominal,
                                                            dp.sfa_PeriodName,
                                                            int.Parse(d.sfa_DeliverableCode),
                                                            dp.sfa_ContractDeliverableId)
                                                        {Entity = dp});
                return contractDeliverablePeriodIds.ToList().Where(cdp => IsValidCdp(cdp.Entity, payType)).ToList();
            }
        }

        private bool IsValidCdp(sfa_contractdeliverableperiod cdp, sfa_paymenttype paymentType)
        {
            bool isValid = false;
            switch (paymentType)
            {
                case sfa_paymenttype.Profile:
                    isValid = cdp.sfa_profilesubnominal == null;
                    break;
                case sfa_paymenttype.Capping:
                    isValid =  cdp.sfa_CappingSubnominal == null;
                    break;
                case sfa_paymenttype.Reconciliation:
                    isValid = cdp.sfa_reconciliationsubnominal == null;
                    break;
            }

            return isValid;
        }

        private IQueryable<sfa_contractdeliverableperiod> GetCdpFilterForPaymentType(XrmServiceContext xrmContext, sfa_paymenttype paymentType)
        {
            IQueryable<sfa_contractdeliverableperiod> queryable = null;
            switch (paymentType)
            {
                case sfa_paymenttype.Profile:
                    queryable = xrmContext.sfa_contractdeliverableperiodSet.Where(cdp => cdp.sfa_profilesubnominal == null);
                    break;
                case sfa_paymenttype.Capping:
                    queryable = xrmContext.sfa_contractdeliverableperiodSet.Where(cdp => cdp.sfa_CappingSubnominal == null);
                    break;
                case sfa_paymenttype.Reconciliation:
                    queryable = xrmContext.sfa_contractdeliverableperiodSet.Where(cdp => cdp.sfa_reconciliationsubnominal == null);
                    break;
            }

            return queryable;
        }


        private Guid GetAllocationIdByAllocationNumberAndContractNumberAndVersionNumber(string allocationNumber,
            string contractNumber, int versionNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var allocGuid = (from a in xrmContext.sfa_contractallocationSet
                                 join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                 where
                                     a.sfa_contractallocationnumber == allocationNumber && c.sfa_Version == versionNumber
                                     && c.sfa_number == contractNumber
                                 select a.sfa_contractallocationId.Value).ToList();

                return allocGuid.Any() ? allocGuid.First() : Guid.Empty;
            }
        }

        private EntityCollection GetRelatedRecords(string allocationNumber)
        {
            string contractallocationidColumn = "sfa_contractallocationid";
            string entity1PF = "sfa_subnominalaggregationid";
            const string RelationshipEntityName = "sfa_sfa_subnominalaggregation_sfa_contracta";

            QueryExpression query = new QueryExpression(sfa_subnominalaggregation.EntityLogicalName)
            {
                ColumnSet = new ColumnSet(true)
            };
            LinkEntity linkEntity1 = new LinkEntity(sfa_subnominalaggregation.EntityLogicalName, RelationshipEntityName,
                entity1PF, entity1PF, JoinOperator.Inner);
            LinkEntity linkEntity2 = new LinkEntity(RelationshipEntityName, sfa_contractallocation.EntityLogicalName,
                contractallocationidColumn, contractallocationidColumn, JoinOperator.Inner);
            linkEntity1.LinkEntities.Add(linkEntity2);
            query.LinkEntities.Add(linkEntity1);

            linkEntity2.LinkCriteria = new FilterExpression();
            linkEntity2.LinkCriteria.AddCondition(new ConditionExpression("sfa_contractallocationnumber",
                ConditionOperator.Equal, allocationNumber));

            EntityCollection recordcollection = OrganizationService.RetrieveMultiple(query);
            return recordcollection;
        }

        private void AssociateToContractAllocation(Guid allocationId, Guid subnominalAggregationId)
        {
            EntityReferenceCollection relatedEntities = new EntityReferenceCollection
            {
                new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            };

            Relationship relationship = new Relationship("sfa_sfa_subnominalaggregation_sfa_contractall");

            try
            {
                OrganizationService.Associate(sfa_subnominalaggregation.EntityLogicalName, subnominalAggregationId,
                    relationship, relatedEntities);
            }
            catch (Exception e)
            {
                System.Diagnostics.Trace.WriteLine("AssociateToContractAllocation failed. - " + e.Message);
            }
        }

        private IEnumerable<PolicyDeliverableToSubnominals> GetSubnominalCodesForFspAndPeriod(
            string fundingStreamPeriod, int deliverableCode)
        {
            return GetAllPolicyDeliverableToSubnominals().Where(d => d.FundingStreamPeriod == fundingStreamPeriod &&
                                                                        d.DeliverableCode == deliverableCode)
                .ToList();
        }

        private IReadOnlyCollection<AllocationInfo> GetAllocationInfos()
        {
            IReadOnlyCollection<AllocationInfo> allocationInfos = null;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                allocationInfos =
                    context.AllocationDeliverablePeriods
                        .Select(
                            adp => new
                            {
                                adp.ContractNumber,
                                adp.ContractAllocationNumber,
                                adp.ContractVersionNumber,
                                adp.FundingStreamPeriodCode
                            })
                        .Distinct()
                        .ToList()
                        .Select(
                            a =>
                                new AllocationInfo(a.ContractNumber, a.ContractAllocationNumber, a.ContractVersionNumber,
                                    a.FundingStreamPeriodCode))
                        .ToList();
            }

            return allocationInfos;
        }

        private IReadOnlyCollection<AllocationInfo> GetAllocationInfosBySaAggregateKey(string aggregateKey)
        {
            var allocRef = aggregateKey.Split('_')[1];
            IReadOnlyCollection<AllocationInfo> allocationInfos;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                allocationInfos =
                    context.AllocationDeliverablePeriods
                        .Where(adp => adp.ContractAllocationNumber == allocRef)
                        .Select(
                            adp => new
                            {
                                adp.ContractNumber,
                                adp.ContractAllocationNumber,
                                adp.ContractVersionNumber,
                                adp.FundingStreamPeriodCode
                            })
                        .Distinct()
                        .ToList()
                        .Select(
                            a =>
                                new AllocationInfo(a.ContractNumber, a.ContractAllocationNumber, a.ContractVersionNumber,
                                    a.FundingStreamPeriodCode))
                        .ToList();
            }

            return allocationInfos;
        }

        private IReadOnlyCollection<string> GetPayableFspsWithDeliverableCodes()
        {
            if (_payableFspsWithDeliverableCodes == null)
            {
                _payableFspsWithDeliverableCodes =
                    GetPayableDeliverables().Select(d => d.FundingStreamPeriod + d.DeliverableCode).ToList();
            }

            return _payableFspsWithDeliverableCodes;
        }

        private IReadOnlyCollection<PolicyDeliverable> GetPayableDeliverables()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                return context.PolicyDeliverables.Where(d => d.IsPayable)
                    .ToList();
            }
        }

        private int GetNumOfSubnominalsForFundingStreamPeriodAndDeliverableCode(string fundingStreamPeriod, int deliverableCode)
        {
            return
                GetAllPolicyDeliverableToSubnominals().Count(
                    ds => ds.DeliverableCode == deliverableCode && ds.FundingStreamPeriod == fundingStreamPeriod);
        }

        private IReadOnlyCollection<PolicyDeliverableToSubnominals> GetAllPolicyDeliverableToSubnominals()
        {
            if (_allDeliverableToSubnominals == null)
            {
                using (var context = new PaymentManagementPolicyContext())
                {
                    _allDeliverableToSubnominals = context.PolicyDeliverableToSubnominals.ToList();
                }
            }

            return _allDeliverableToSubnominals;
        }

        private class ContractDeliverablePeriodInfo
        {
            public ContractDeliverablePeriodInfo(Guid contractDeliverablePeriodId, string allocationNumber, EntityReference profile, EntityReference capping, EntityReference recon, string periodName, int deliverableCode, EntityReference contractDeliverableId)
            {
                ContractDeliverablePeriodId = contractDeliverablePeriodId;
                AllocationNumber = allocationNumber;
                Profile = profile;
                Capping = capping;
                Recon = recon;
                PeriodName = periodName;
                DeliverableCode = deliverableCode;
                ContractDeliverableId = contractDeliverableId;
            }

            public Guid ContractDeliverablePeriodId { get; }

            public EntityReference ContractDeliverableId { get; }

            public string AllocationNumber { get; }

            public string Period
            {
                get
                {
                    DateTime date = DateTime.ParseExact(PeriodName, "MMM-yy", CultureInfo.InvariantCulture);
                    return date.Year + date.Month.ToString().PadLeft(2, '0');
                }
            }

            public sfa_contractdeliverableperiod Entity { get; set; }

            public int DeliverableCode { get; }

            public string FspCode { get; set; }

            private EntityReference Profile { get; }

            private EntityReference Capping { get; }

            private EntityReference Recon { get; }

            public string PeriodName { get; }

            public Guid GetSubnominalAggregationGuid()
            {
                EntityReference subnomialAggregationRef = Profile ?? Capping ?? Recon;

                return subnomialAggregationRef?.Id ?? Guid.Empty;
            }

            public int NumSubnominalAggregationRelationship()
            {
                return NumRelationships(Profile) + NumRelationships(Capping) + NumRelationships(Recon);
            }

            public bool HasPaymentType(sfa_paymenttype paymenttype)
            {
                if (paymenttype == sfa_paymenttype.Capping)
                {
                    return Capping != null;
                }
                else if (paymenttype == sfa_paymenttype.Profile)
                {
                    return Profile != null;
                }
                else if (paymenttype == sfa_paymenttype.Reconciliation)
                {
                    return Recon != null;
                }
                else
                {
                    throw new ArgumentException("The payment type is not supported");
                }
            }

            private int NumRelationships(EntityReference er)
            {
                if (er == null)
                {
                    return 0;
                }

                return 1;
            }
        }

        private class AllocationInfo
        {
            public AllocationInfo(string contractNumber, string allocationNumber, int versionNumber, string fundingStreamPeriodCode)
            {
                ContractNumber = contractNumber;
                AllocationNumber = allocationNumber;
                VersionNumber = versionNumber;
                FundingStreamPeriodCode = fundingStreamPeriodCode;
            }

            public string ContractNumber { get; }

            public string AllocationNumber { get; }

            public int VersionNumber { get; }

            public string FundingStreamPeriodCode { get; }
        }

        private class IdComparer : IEqualityComparer<sfa_subnominalaggregation>
        {
            public bool Equals(sfa_subnominalaggregation x, sfa_subnominalaggregation y)
            {
                return x.Id.Equals(y.Id)
                    && x.sfa_subnominalaggregationId.Equals(y.sfa_subnominalaggregationId);
            }

            public int GetHashCode(sfa_subnominalaggregation obj)
            {
                return obj.GetHashCode();
            }
        }

        private class SubnominalInfo
        {
            public SubnominalInfo(Guid id, sfa_paymenttype paymentType)
            {
                Id = id;
                PaymentType = paymentType;
            }

            public SubnominalInfo(Guid id, string aggregateKey, sfa_paymenttype paymentType)
            {
                Id = id;
                PaymentType = paymentType;
                AggregateKey = aggregateKey;
            }

            public Guid Id { get; }

            public string AggregateKey { get; }

            public sfa_paymenttype PaymentType { get; }
        }

        public static class ParallelProcessor
        {
            public static BlockingCollection<TResult> Process<TSource, TResult>(Func<List<TSource>> getAllItems, Func<IEnumerable<TSource>, IEnumerable<TResult>> processSlice)
            {
                var sourceItems = getAllItems();
                int numItemsToRunInParallel = sourceItems.Count / 1;
                Console.WriteLine("{0} sourceItems items retrieved.", sourceItems.Count);
                BlockingCollection<TResult> resultItems = new BlockingCollection<TResult>();
                int beginningIndex = 0;
                IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
                do
                {
                    Console.WriteLine("Parallel processing for sourceItems {0} to {1}.",
                        beginningIndex, beginningIndex + numItemsToRunInParallel);
                    var sliceOfData = sourceItems.GetRange(beginningIndex, Math.Min(numItemsToRunInParallel, sourceItems.Count - beginningIndex));
                    taskList.Add(System.Threading.Tasks.Task.Run(() =>
                    {
                        processSlice(sliceOfData).ForEach(resultItems.Add);
                    }));
                    Console.WriteLine("Completed processing items {0} to {1}.", beginningIndex, beginningIndex + numItemsToRunInParallel);

                    beginningIndex += sliceOfData.Count;
                } while (beginningIndex < sourceItems.Count);

                System.Threading.Tasks.Task.WaitAll(taskList.ToArray());

                return resultItems;
            }

            public static void ProcessCommand<TSource>(
                Func<List<TSource>> getAllItems,
                Action<IEnumerable<TSource>> command)
            {
                var sourceItems = getAllItems();
                int numItemsToRunInParallel = sourceItems.Count / 3;
                Console.WriteLine("{0} sourceItems items retrieved.", sourceItems.Count);
                int beginningIndex = 0;
                IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
                do
                {
                    Console.WriteLine("Parallel processing for sourceItems {0} to {1}.",
                        beginningIndex, beginningIndex + numItemsToRunInParallel);
                    var sliceOfData = sourceItems.GetRange(beginningIndex, Math.Min(numItemsToRunInParallel, sourceItems.Count - beginningIndex));
                    taskList.Add(System.Threading.Tasks.Task.Run(() =>
                    {
                        command(sliceOfData);
                    }));
                    Console.WriteLine("Completed processing items {0} to {1}.", beginningIndex, beginningIndex + numItemsToRunInParallel);

                    beginningIndex += sliceOfData.Count;
                } while (beginningIndex < sourceItems.Count);

                System.Threading.Tasks.Task.WaitAll(taskList.ToArray());
            }
        }
    }
}