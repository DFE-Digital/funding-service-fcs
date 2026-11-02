namespace Datafix.Tests.Automation.Releases.R99e
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Datafix.Tests.Repositories;
    using Microsoft.Xrm.Sdk;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class ChangeFspInCrmAndPaaS : IApplyDataFix
    {
        private const string AllocationNumber = "AEBA-1856";
        public string Release => "R99e";
        public int StoryNumber => 32788;
        public string Name => "Change Fsp on Allocation in Crm and PaaS and re-publish approval";
        public int Order => 2;

        public void ApplyDataFix()
        {
            UpdateAllocationInCrm();

            UpdateAllocationInPaaS();

            AtomFeedService.AddItemToFeed(new ContractIdentifier(contractNumber: "AEBP-2735", versionNumber: 2, subVersionNumber: 0), AtomItemType.ApprovedContract);
        }

        private static void UpdateAllocationInPaaS()
        {
            // this is a list of places in PaaS
            // [ContractManagement].[ApprovedContractAllocation] - change
            // [MonitoringDeliverables].[AllocationDeliverablePeriod] - change
            // [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit] - this table has the old (good) fsp in
            // [PaymentGeneration].[SubnominalAggregation] - spoke to Dave, we just leave them
            // [PaymentSchedule].[Allocation] - change

            var sqlStatements = new List<string>
            {
                $@"update [ContractManagement].[ApprovedContractAllocation] set [FundingStreamPeriodCode] = 'AEB-AS2021'
                where ContractAllocationNumber = '{AllocationNumber}'
                and [FundingStreamPeriodCode] = 'AEB-19TRN2021'",

                $@"update [MonitoringDeliverables].[AllocationDeliverablePeriod] set [FundingStreamPeriodCode] = 'AEB-AS2021'
                where ContractAllocationNumber = '{AllocationNumber}'
                and [FundingStreamPeriodCode] = 'AEB-19TRN2021'",

                $@"update [PaymentSchedule].[Allocation] set FundingStreamPeriodCode = 'AEB-AS2021'
	            where AllocationNumber = '{AllocationNumber}'
	            and FundingStreamPeriodCode = 'AEB-19TRN2021'"
            };

            string sql = string.Join(";", sqlStatements);

            SqlCommandRepository.ExecuteSql(sql);
        }

        private static void UpdateAllocationInCrm()
        {
            Dictionary<int, string> deliverableNames = new Dictionary<int, string>
            {
                {1, "Adult Skills Total Funding"},
                {2, "Adult Skills Programme Funding"},
                {3, "Adult Skills Learning Support"}
            };

            var fspId = CrmFundingStreamPeriodRepository.GetFspId("AEB-AS2021");
            var fsId = CrmFundingStreamRepository.GetFsId("AEB-AS");
            var allocationInfo = CrmContractInformationRepository.GetAllocationInfo(contractNumber: "AEBP-2735", version: 2, subVersion: 0, allocationNumber: AllocationNumber);
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                Id = allocationInfo.Id,
                sfa_FundingStreamPeriodId = new EntityReference(sfa_fundingstreamperiod.EntityLogicalName, fspId),
                sfa_FundingStreamId = new EntityReference(sfa_fundingstream.EntityLogicalName, fsId),
                sfa_sfa_contractallocation_sfa_contractdelive = allocationInfo.Deliverables.Select(d => new sfa_contractdeliverable
                {
                    Id = d.Id,
                    sfa_DeliverableDescription = deliverableNames[d.DeliverableCode],
                    sfa_deliverablename = deliverableNames[d.DeliverableCode]
                }).ToList()
            };

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            organizationService.Update(allocation);
        }
    }
}
