namespace ContractManagement.DataStore.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ILegalDeliverableService
    {
        void RemoveNonLegalDeliverablesFromContract(contract masterContract);

        void RemoveNonLegalDeliverablesFromContract(ConnectionInfo connectionInfo, contract masterContract);

        void RemoveNonLegalDeliverablesFromContractType(ConnectionInfo connectionInfo,
            SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType masterContract);
    }
}