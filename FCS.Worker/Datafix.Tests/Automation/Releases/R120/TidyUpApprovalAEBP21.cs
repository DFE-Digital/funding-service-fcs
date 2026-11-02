namespace Datafix.Tests.Automation.Releases.R120
{
    using Datafix.Tests.Repositories;
    using Microsoft.Xrm.Sdk;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Events;
    using NServiceBus;

    public class TidyUpApprovalAEBP21 : IApplyDataFix
    {
        public string Release => "R120";
        public int StoryNumber => 37046;
        public string Name => "Tidy up approval where Allocations got the wrong monitoring deliverables";
        public int Order => 2;

        public void ApplyDataFix()
        {
            const string contractNumber = "AEBP21-1095";
            const string masterContractNumber = "ESFA-21294";
            const int versionNumber = 4;

            var allocationNumbers = AllocationRepository.GetLatestAllocationNumbersForContract(contractNumber);

            allocationNumbers.ForEach(allocationNumber =>
            {
                DeliverablePaymentRepository.RemoveRowsForAllocationVersion(allocationNumber, versionNumber);
                AllocationDeliverablePeriodRepository.RemoveRowsForAllocation(allocationNumber);
            });

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            ContractsManager contractsManager = new ContractsManager()
            {
                OrganizationService = organizationService
            };

            var corporateContract = contractsManager.GetCorporateContract(contractNumber, masterContractNumber);

            var endpoint = EndpointBuilder.CreatePublishingEndpoint<ContractApprovedEvent>("ContractManagementDomain.ContractApproved");
            endpoint.Publish(new ContractApprovedEvent
            {
                CorporateContract = corporateContract
            }).Wait();
        }
    }
}