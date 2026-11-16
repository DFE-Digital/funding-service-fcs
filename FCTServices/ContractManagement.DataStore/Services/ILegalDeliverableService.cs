namespace ContractManagement.DataStore.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ILegalDeliverableService
    {
        void RemoveNonLegalDeliverablesFromContract(Contract masterContract);

        void RemoveNonLegalDeliverablesFromContract(ConnectionInfo connectionInfo, Contract masterContract);

        void RemoveNonLegalDeliverablesFromContractType(ConnectionInfo connectionInfo,
            SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType masterContract);
    }
}