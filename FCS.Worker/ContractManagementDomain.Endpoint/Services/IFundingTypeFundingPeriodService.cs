namespace ContractManagementDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodService
    {
        bool IsProcessDateAfterFundingTypeContractingActivityCloseDate(string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo);

        ContractApprovalType GetApprovalType(string fundingTypeCode, string fundingPeriodName);

        bool IsLEVYAllocationSynced(string contractNo, int contractversionNo, int contractsubversionNo, int allocationCount);
    }
}
