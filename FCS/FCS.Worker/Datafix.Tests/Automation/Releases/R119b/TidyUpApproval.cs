namespace Datafix.Tests.Automation.Releases.R119b
{
    using System;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Microsoft.Xrm.Sdk;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Events;
    using NServiceBus;

    public class TidyUpApproval : IApplyDataFix
    {
        public string Release => "R119b";
        public int StoryNumber => 36926;
        public string Name => "Tidy up approval where Allocations got the wrong monitoring deliverables";
        public int Order => 1;

        public void ApplyDataFix()
        {
            const string contractNumber = "EDSK-3559";
            const string masterContractNumber = "ESFA-20450";
            const int versionNumber = 9;

            var allocationNumbers = AllocationRepository.GetLatestAllocationNumbersForContract(contractNumber);

            allocationNumbers.ForEach(allocationNumber =>
            {
                DeliverablePaymentRepository.RemoveRowsForAllocationVersion(allocationNumber, versionNumber);
                AllocationDeliverablePeriodRepository.RemoveRowsForAllocation(allocationNumber);
            });

            DateTime createdDate = CreatedContractRepository.GetLatestCreatedDate(contractNumber);
            createdDate = createdDate.AddMinutes(10);

            var monitoringDeliverableIds = CrmContractDeliverableRepository.GetContractDeliverableIdsForLatestContractCreatedAfterDate(contractNumber,
                createdDate);

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            monitoringDeliverableIds.ToList().ForEach(id => organizationService.Delete(sfa_contractdeliverable.EntityLogicalName, id));

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
