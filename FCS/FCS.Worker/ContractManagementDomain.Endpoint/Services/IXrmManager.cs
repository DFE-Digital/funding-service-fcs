namespace ContractManagementDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IXrmManager
    {
        void UpdateContractForManualApproval(contractType contractToUpdate);

        void UpdateContractForElectronicApproval(contractType contractToUpdate);

        void UpdateContractForNotificationApproval(contractType contractToUpdate);

        void UpdateContractForWithdrawalSuccessful(contractType contractToUpdate);

        void UpdateContractForWithdrawalByProviderSuccessful(contractType contractToUpdate);

        void UpdateContractForAutoWithdrawalSuccessful(contractType contractToUpdate);

        void UpdateContractForBulkWithdrawalByAgencySuccessful(contractType contractToUpdate);

        void UpdateContractForManualFailure(contractType contractToUpdate, string reasonForFailure);

        void UpdateContractPublishedToProviderFailed(string contractNumber, int versionNumber, int subVersionNumber, string reasonForFailure);
    }
}
