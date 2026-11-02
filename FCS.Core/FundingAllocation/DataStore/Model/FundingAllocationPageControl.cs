namespace FundingAllocation.DataStore.Model
{
    using System.Collections.Generic;

    public class FundingAllocationPageControl
    {
        private FundingAllocationPageControl()
        {
        }

        public FundingAllocationPageControl(int readId, int pageNumber)
        {
            ReadId = readId;
            PageNumber = pageNumber;
        }

        public int ReadId { get; private set; }

        public int PageNumber { get; private set; }

        public string LatestBookmarkOnPage { get; set; }

        public FeedRead FeedRead { get; set; }

        public List<FundingAllocation> FundingAllocations { get; private set; }
    }
}