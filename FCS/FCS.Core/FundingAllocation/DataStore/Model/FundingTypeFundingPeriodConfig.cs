namespace FundingAllocation.DataStore.Model
{
    using System;
    public class FundingTypeFundingPeriodConfig
    {
        private FundingTypeFundingPeriodConfig()
        {
        }

        public FundingTypeFundingPeriodConfig(string fundingTypeCode,
            string fundingPeriod,
            string ftpGroupCode,
            string precedingFtpFundingType,
            string precedingFtpFundingPeriod,
            bool includeAllContractsOnSummaryOfFunding,
            bool allowNewAmendment,
            bool? allAmendmentsRequireSigning)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriod = fundingPeriod;
            FtpGroupCode = ftpGroupCode;
            PrecedingFtpFundingType = precedingFtpFundingType;
            PrecedingFtpFundingPeriod = precedingFtpFundingPeriod;
            IncludeAllContractsOnSummaryOfFunding = includeAllContractsOnSummaryOfFunding;
            AllowNewAmendment = allowNewAmendment;
            AllAmendmentsRequireSigning = allAmendmentsRequireSigning;
        }

        public string FundingTypeCode { get; private set; }

        public string FundingPeriod { get; private set; }

        public string FtpGroupCode { get; private set; }

        public string PrecedingFtpFundingType { get; private set; }

        public string PrecedingFtpFundingPeriod { get; private set; }

        public bool IncludeAllContractsOnSummaryOfFunding { get; private set; }

        public bool AllowNewAmendment { get; private set; }

        public bool? AllAmendmentsRequireSigning { get; private set; }

        public DateTime? ContractExpiryDate { get; private set; }
    }
}