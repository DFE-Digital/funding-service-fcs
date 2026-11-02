namespace FCT.Operations.FundingAllocationExtract.DTOs
{
    using System;

    public class ExtractRow
    {
        public ExtractRow(DateTime lastParked, DateTime lastDiscarded, string fundingId, string ukprn, string providerType, string providerSubType, string allocationFundingStream, string period, string fundingVersion, decimal value, string tradingName, string fundingPeriodCode, string fundingTypeCode, string fspGroupCode, string providerCategoryException, string providerCategoryDefault, string status, string subStatus, string providerCategory, string contractTypeUsingProviderCategory, string contractTypeUsingDefault)
        {
            LastParked = lastParked;
            LastDiscarded = lastDiscarded;
            FundingId = fundingId;
            ProviderType = providerType;
            ProviderSubType = providerSubType;
            AllocationFundingStream = allocationFundingStream;
            Period = period;
            FundingVersion = fundingVersion;
            Value = value;
            TradingName = tradingName;
            FundingPeriodCode = fundingPeriodCode;
            FundingTypeCode = fundingTypeCode;
            FSPGroupCode = fspGroupCode;
            ProviderCategoryException = providerCategoryException;
            ProviderCategoryDefault = providerCategoryDefault;
            ProviderCategory = providerCategory;
            ContractTypeUsingProviderCategory = contractTypeUsingProviderCategory;
            ContractTypeUsingDefault = contractTypeUsingDefault;
            Status = status;
            SubStatus = subStatus;
            Ukprn = ukprn;
        }

        public DateTime LastParked { get; }
        public DateTime LastDiscarded { get; }
        public string FundingId { get; }
        public string Ukprn { get; }
        public string ProviderType { get; }
        public string ProviderSubType { get; }
        public string AllocationFundingStream { get; }
        public string Period { get; }
        public string FundingVersion { get; }
        public decimal Value { get; }
        public string TradingName { get; }
        public string FundingPeriodCode { get; }
        public string FundingTypeCode { get; }
        public string FSPGroupCode { get; }
        public string ProviderCategoryException { get; }
        public string ProviderCategoryDefault { get; }
        public string ContractTypeUsingProviderCategory { get; }
        public string ContractTypeUsingDefault { get; }
        public string ProviderCategory { get; }
        public string Status { get; }
        public string SubStatus { get; }
    }
}
