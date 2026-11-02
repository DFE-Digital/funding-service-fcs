namespace Operations.Web.Dtos
{
    public class AwaitingFundingAllocationInfo
    {
        public AwaitingFundingAllocationInfo()
        {
        }
        public AwaitingFundingAllocationInfo(string cfsFundingStream, string cfsFundingPeriod, int countOfFAs)
        {
            CfsFundingStream = cfsFundingStream;
            CfsFundingPeriod = cfsFundingPeriod;
            CountOfFAs = countOfFAs;
        }

        public string CfsFundingStream { get; set; }
        public string CfsFundingPeriod { get; set; }
        public int CountOfFAs { get; set; }
    }
}