namespace Operations.Web.Dtos
{
    public class ParkedFundingAllocationsSubStatusInfo
    {
        public ParkedFundingAllocationsSubStatusInfo()
        {
        }

        public ParkedFundingAllocationsSubStatusInfo(string subStatus, int count)
        {
            SubStatus = subStatus;
            Count = count;
        }

        public string SubStatus { get; set; }
        public int Count { get; set; }
    }
}