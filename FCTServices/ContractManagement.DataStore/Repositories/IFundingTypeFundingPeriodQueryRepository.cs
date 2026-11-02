namespace ContractManagement.DataStore.Repositories
{
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodQueryRepository
    {
        FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriodName);

        FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo);

        bool IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(string fundingTypeCode, string fundingPeriodName);

        bool IsLEVYAllocationSynced(string contractNo, int contractversionNo, int contractsubversionNo, int allocationCount);
    }
}
