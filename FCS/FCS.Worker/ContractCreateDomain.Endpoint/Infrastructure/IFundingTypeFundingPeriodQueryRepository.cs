namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodQueryRepository
    {
        FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);
    }
}