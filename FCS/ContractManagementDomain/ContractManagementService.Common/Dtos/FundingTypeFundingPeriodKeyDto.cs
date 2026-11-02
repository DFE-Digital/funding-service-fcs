namespace SFA.FCT.ContractManagementService.Common.Dtos
{
    public class FundingTypeFundingPeriodKeyDto
    {
        public FundingTypeFundingPeriodKeyDto(string fundingTypeCode, string fundingPeriodName)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
        }

        public string FundingTypeCode { get; }

        public string FundingPeriodName { get;  }
    }
}
