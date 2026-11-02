namespace PerformanceManagementDomain.PullFundingClaim.Extensions
{
    using Services;

    public static class IFundingClaimsApiAdapterExtensions
    {
        public static int GetNumberOfPagesRequired(this IFundingClaimsApiAdapter adapter, int totalRows)
        {
            var numPages = (decimal) totalRows / adapter.PageSize;
            var remainder = numPages - (int) numPages;

            return (int)numPages + (remainder > 0 ? 1: 0);
        }
    }
}
