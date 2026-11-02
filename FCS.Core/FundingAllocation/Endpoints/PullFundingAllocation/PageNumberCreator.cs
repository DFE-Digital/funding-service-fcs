namespace FundingAllocation.Endpoints.PullFundingAllocation
{
    using System.Linq;

    public static class PageNumberCreator
    {
        public static int[] GetPageNumbers(int currentPageNumber, int latestPageNumber)
        {
            if (currentPageNumber > latestPageNumber)
                return Enumerable.Range(latestPageNumber, latestPageNumber).ToArray();
            return Enumerable.Range(currentPageNumber, (latestPageNumber + 1) - currentPageNumber).ToArray();
        }
    }
}
