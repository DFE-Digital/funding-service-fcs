namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System.Threading.Tasks;
    using PaymentGenerationDomain.Integration.DataStore.Model;

    public interface IFundingStreamPeriodQueryRepository
    {
        Task<FundingStreamPeriod> GetFundingStreamPeriodWithFundingStream(string fundingStreamPeriodCode);
    }
}