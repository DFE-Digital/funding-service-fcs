namespace FundingAllocation.DataStore.Model
{
    using System;
    using System.Collections.Generic;

    public class FeedRead
    {
        public FeedRead()
        {
        }

        public int ReadId { get; private set; }
        public DateTime? CfsReadCompletedDate { get; set; }
        public DateTime? JobCompletedDate { get; set; }
        public List<FundingAllocationPageControl> FundingAllocationPageControls { get; private set; }
    }
}
