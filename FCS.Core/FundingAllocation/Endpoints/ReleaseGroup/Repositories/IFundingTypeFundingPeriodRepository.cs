namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using Dto;
    using System.Threading.Tasks;

    public interface IFundingTypeFundingPeriodRepository
    {
        Task<IntentFundingTypeFundingPeriod> GetAmendmentInfo(string fundingTypeCode, string fundingPeriod);

        Task<bool> DoAllAmendmentsRequireSigning(string fundingTypeCode, string fundingPeriod);
        Task<bool> DoAmendmentTypeToNotificationOnExpiredContract(string fundingTypeCode, string fundingPeriod);        
    }
}