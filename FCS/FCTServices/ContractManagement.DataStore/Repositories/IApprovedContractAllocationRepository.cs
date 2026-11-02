namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractAllocationRepository
    {
        void SetOutstandingPaymentsIndicator(string allocationNumber, bool hasOutstandingPayments, ConnectionInfo connectionInfo);

        IReadOnlyCollection<string> GetAllocationNumbersForApprovedContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, ConnectionInfo connectionInfo);
    }
}
