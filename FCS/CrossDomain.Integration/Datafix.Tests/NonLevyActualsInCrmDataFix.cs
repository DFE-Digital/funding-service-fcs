namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class NonLevyActualsInCrmDataFix
    {
        [TestMethod, TestCategory("DataFix_R35b")]
        public void ChangeActualsValueOfIncorrectAllocationDeliverablePeriodsToZeroInCrm()
        {
            const int contractVersion = 6;
            const string delCode = "3";
            const string period = "May-17";

            IReadOnlyCollection<ContractAllocationDeliverablePeriodKey> cdpKeysToChange = new List<ContractAllocationDeliverablePeriodKey>
            {
                new ContractAllocationDeliverablePeriodKey("ANL-1156", delCode, period, contractVersion),
                new ContractAllocationDeliverablePeriodKey("16NL-1158", delCode, period, contractVersion)
            };
            
            cdpKeysToChange
                .Select(GetContractDeliverablePeriodEntityId)
                .ForEach(entityId =>
                {
                    sfa_contractdeliverableperiod cdpUpdate = new sfa_contractdeliverableperiod
                    {
                        sfa_contractdeliverableperiodId = entityId,
                        sfa_ActualValue = 0m
                    };
                    new OrganizationService(GetCrmConnection()).Update(cdpUpdate);
                });
        }

        private static Guid? GetContractDeliverablePeriodEntityId(ContractAllocationDeliverablePeriodKey key)
        {
            using (XrmServiceContext context = new XrmServiceContext(new OrganizationService(GetCrmConnection())))
            {
                return (from del in context.sfa_contractdeliverableSet
                    join dp in context.sfa_contractdeliverableperiodSet
                        on del.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                    join alloc in context.sfa_contractallocationSet
                        on del.sfa_ContractAllocationId.Id equals alloc.sfa_contractallocationId
                    join ctr in context.sfa_contractSet
                        on alloc.sfa_ContractId.Id equals ctr.sfa_contractId
                    where alloc.sfa_contractallocationnumber == key.AllocationNumber
                            && del.sfa_DeliverableCode == key.DeliverableCode
                            && dp.sfa_PeriodName == key.Period
                            && ctr.sfa_Version == key.ContractVersion
                    select dp.sfa_contractdeliverableperiodId).Single();
            }
        }

        private static CrmConnection GetCrmConnection()
        {
            return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
        }

        private class ContractAllocationDeliverablePeriodKey
        {
            public ContractAllocationDeliverablePeriodKey(string allocationNumber, string deliverableCode, string period, int contractVersion)
            {
                AllocationNumber = allocationNumber;
                DeliverableCode = deliverableCode;
                Period = period;
                ContractVersion = contractVersion;
            }

            public string AllocationNumber { get; }
            public string DeliverableCode { get; }
            public string Period { get; }
            public int ContractVersion { get; }
        }
    }
}