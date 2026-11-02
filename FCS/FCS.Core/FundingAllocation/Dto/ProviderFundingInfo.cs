namespace FundingAllocation.Dto
{
    using System;

    public class ProviderFundingInfo
    {
        public ProviderFundingInfo(string providerType, string providerSubType, string fundingStreamCode, string fundingPeriodId, string fundingLineCode, string contractingUkprn)
        {
            ProviderType = providerType;
            ProviderSubType = providerSubType;
            FundingStreamCode = fundingStreamCode;
            FundingPeriodId = fundingPeriodId;
            FundingLineCode = fundingLineCode;
            ContractingUkprn = contractingUkprn;
        }

        public string ProviderType { get; }

        public string ProviderSubType { get; }

        public string FundingStreamCode { get; }

        public string FundingPeriodId { get; }

        public string FundingLineCode { get; }
        public string ContractingUkprn { get; }

        public override string ToString()
        {
            return $"ProviderType: {ProviderType}, ProviderSubType: {ProviderSubType}, FundingStreamCode: {FundingStreamCode}," +
                   $" FundingPeriodId: {FundingPeriodId}, FundingLineCode: {FundingLineCode}, ContractingUkprn: {ContractingUkprn}";
        }

        public override bool Equals(object obj)
        {
            if (obj is ProviderFundingInfo other)
            {
                return ProviderType == other.ProviderType &&
                       ProviderSubType == other.ProviderSubType &&
                       FundingStreamCode == other.FundingStreamCode &&
                       FundingPeriodId == other.FundingPeriodId &&
                       FundingLineCode == other.FundingLineCode &&
                       ContractingUkprn == other.ContractingUkprn;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(ProviderType.GetHashCode(),
                ProviderSubType.GetHashCode(),
                FundingStreamCode.GetHashCode(),
                FundingPeriodId.GetHashCode(),
                FundingLineCode.GetHashCode(),
                ContractingUkprn.GetHashCode());
        }
    }
}