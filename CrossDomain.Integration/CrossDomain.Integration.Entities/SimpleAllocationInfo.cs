namespace SFA.FCT.CrossDomain.Integration.Entities
{
    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class SimpleAllocationInfo
    {
        public SimpleAllocationInfo(string fundingStreamPeriodCode)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        public string FundingStreamPeriodCode { get;  }
    }
}