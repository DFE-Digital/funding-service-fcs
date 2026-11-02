namespace SFA.FCT.CrossDomain.Integration.Entities
{
    public class SimpleAllocationInfo
    {
        public SimpleAllocationInfo(string fundingStreamPeriodCode)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        public string FundingStreamPeriodCode { get;  }
    }
}