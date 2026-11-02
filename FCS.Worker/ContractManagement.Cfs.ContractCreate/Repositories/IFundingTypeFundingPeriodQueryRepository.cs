namespace ContractManagement.Cfs.Repositories
{
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodQueryRepository
    {
        FundingTypeFundingPeriod Get(ConnectionInfo connectionInfo, string fundingTypeCode,
            string fundingPeriodName);
    }
}