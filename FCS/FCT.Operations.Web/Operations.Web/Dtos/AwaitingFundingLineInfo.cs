namespace Operations.Web.Dtos
{
    public class AwaitingFundingLineInfo
    {

        public AwaitingFundingLineInfo()
        { 
        }
        public AwaitingFundingLineInfo(string cfsFundingStream, string cfsFundingPeriod, int countOfFAs)
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