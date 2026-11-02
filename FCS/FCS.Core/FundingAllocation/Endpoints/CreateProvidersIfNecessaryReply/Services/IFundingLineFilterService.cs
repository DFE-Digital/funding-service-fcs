namespace FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services
{
    using System.Threading.Tasks;
    using DataStore.Model;

    public interface IFundingLineFilterService
    {
        Task FilterOutZeroValuedOfNoInterestLines(FundingAllocation fundingAllocation);
    }
}