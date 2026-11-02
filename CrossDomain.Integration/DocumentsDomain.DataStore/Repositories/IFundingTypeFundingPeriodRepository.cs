namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using Models;

    public interface IFundingTypeFundingPeriodRepository
    {
        FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriodCode);
    }
}