namespace DocumentsDomain.Endpoint.Xrm.Services
{
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType;
    using SFA.FCT.CrossDomain.Integration.Entities.Documents;

    public interface IXrmDocumentManager
    {
        bool UpdateContractWithDocumentMergeStatus(contractType contractToUpdate, MergeStatus mergeStatus);

        void UpdateContractPublishedToProviderManualApproval(contractType contractToUpdate);

        void UpdateContractPublishedToProviderForElectronicApproval(contractType contractToUpdate);

        void UpdateContractPublishedToProviderFailed(contractType contractToUpdate, string reasonForFailure);
        
        void UpdateContractPublishedToProviderForAutoApproval(contractType contractToUpdate);
    }
}
