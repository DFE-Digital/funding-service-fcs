namespace ContractManagementDomain.Endpoint.Services
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class XrmManager : IXrmManager
    {
        public XrmManager(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        private readonly IOrganizationService _organizationService;

        public void UpdateContractForManualApproval(contractType contractToUpdate)
        {
            UpdateContractServiceResponse(contractToUpdate.contractNumber,
                contractToUpdate.contractVersionNumber,
                contractToUpdate.contractSubVersionNumber,
                sfa_serviceresponse.MarkAsManuallyApproved);
        }

        public void UpdateContractForElectronicApproval(contractType contractToUpdate)
        {
            UpdateContractServiceResponse(contractToUpdate.contractNumber,
                contractToUpdate.contractVersionNumber,
                contractToUpdate.contractSubVersionNumber,
                sfa_serviceresponse.MarkAsElectronicApproved);
        }

        public void UpdateContractForNotificationApproval(contractType contractToUpdate)
        {
            UpdateContractServiceResponse(contractToUpdate.contractNumber,
                contractToUpdate.contractVersionNumber,
                contractToUpdate.contractSubVersionNumber,
                sfa_serviceresponse.MarkAsAutomaticallyApproved);
        }

        public void UpdateContractForWithdrawalSuccessful(contractType contractToUpdate)
        {
            UpdateContractWithdrawn(contractToUpdate, sfa_serviceresponse.WithdrawalSuccessful);
        }

        public void UpdateContractForWithdrawalByProviderSuccessful(contractType contractToUpdate)
        {
            UpdateContractWithdrawn(contractToUpdate, sfa_serviceresponse.WithdrawalOnBehalfOfProviderSuccessful);
        }

        public void UpdateContractForAutoWithdrawalSuccessful(contractType contractToUpdate)
        {
            UpdateContractWithdrawn(contractToUpdate, sfa_serviceresponse.AutoWithdrawalSuccessful);
        }

        public void UpdateContractForBulkWithdrawalByAgencySuccessful(contractType contractToUpdate)
        {
            UpdateContractWithdrawn(contractToUpdate, sfa_serviceresponse.BulkWithdrawalByAgency);
        }

        public void UpdateContractForManualFailure(contractType contractToUpdate, string reasonForFailure)
        {
            var updateContractObject = new sfa_contract
            {
                Id = GetContractIdByVersion(
                                           contractToUpdate.contractNumber,
                                           contractToUpdate.contractVersionNumber,
                                           contractToUpdate.contractSubVersionNumber),
                sfa_ServiceResponse = new OptionSetValue((int)sfa_serviceresponse.ManualApprovalFailed),
                sfa_ReasonForRejection = reasonForFailure,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(updateContractObject);
        }

        public void UpdateContractPublishedToProviderFailed(string contractNumber, int versionNumber, int subVersionNumber, string reasonForFailure)
        {
            var updateContractObject = new sfa_contract
            {
                Id = GetContractIdByVersion(contractNumber,
                                           versionNumber,
                                           subVersionNumber),
                sfa_ServiceResponse = new OptionSetValue((int)sfa_serviceresponse.DocumentPublishFailed),
                sfa_ReasonForRejection = reasonForFailure,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(updateContractObject);
        }

        private void UpdateContractServiceResponse(string contractNumber, int versionNumber, int subVersionNumber, sfa_serviceresponse serviceResponse)
        {
            var contract = new sfa_contract
            {
                Id = GetContractIdByVersion(contractNumber, versionNumber, subVersionNumber),
                sfa_ServiceResponse = new OptionSetValue((int)serviceResponse)
            };

            _organizationService.Update(contract);
        }

        private void UpdateContractWithdrawn(contractType contractToUpdate, sfa_serviceresponse response)
        {
            var updateContractObject = new sfa_contract
            {
                Id = GetContractIdByVersion(
                                            contractToUpdate.contractNumber,
                                            contractToUpdate.contractVersionNumber,
                                            contractToUpdate.contractSubVersionNumber),
                sfa_ServiceResponse = new OptionSetValue((int)response),
                sfa_DateWithdrawn = contractToUpdate.StatusLastUpdatedDate,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(updateContractObject);
        }

        private Guid GetContractIdByVersion(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                return (from contract in context.sfa_contractSet

                        where contract.sfa_number == contractNumber &&
                                contract.sfa_Version == versionNumber &&
                                contract.sfa_SubVersion == subVersionNumber
                        select contract.Id).Single();
            }
        }
    }
}
