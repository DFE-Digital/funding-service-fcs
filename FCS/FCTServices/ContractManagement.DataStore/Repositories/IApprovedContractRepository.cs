namespace ContractManagement.DataStore.Repositories
{
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractRepository
    {
        bool HasOutstandingPayments(string contractNumber, int contractVersionNumber, int contractSubVersionNumber,
            ConnectionInfo connectionInfo);

        FundingTypeFundingPeriod GetFundingTypeFundingPeriodForContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, ConnectionInfo connectionInfo);

        ApprovedContract GetContractForAllocationNumber(string allocationNumber, ConnectionInfo connectionInfo);
    }
}