namespace SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs
{
    public class FundingTypeFundingPeriodContractTypeDto
    {
        public FundingTypeFundingPeriodContractTypeDto(string fundingType, string fundingPeriod, string contractType)
        {
            FundingTypeCode = fundingType.Trim();
            FundingPeriodCode = fundingPeriod.Trim();
            ContractType = contractType.Trim();
        }

        private FundingTypeFundingPeriodContractTypeDto()
        {
        }

        public string FundingTypeCode { get; set; }

        public string FundingPeriodCode { get; set; }

        public string ContractType { get; set; }

        public override bool Equals(object obj)
        {
            return obj is FundingTypeFundingPeriodContractTypeDto other && other.FundingPeriodCode == FundingPeriodCode && other.FundingTypeCode == FundingTypeCode && other.ContractType == ContractType;
        }

        public override int GetHashCode()
        {
            return FundingTypeCode.GetHashCode() ^ FundingPeriodCode.GetHashCode() ^ ContractType.GetHashCode();
        }
    }
}
