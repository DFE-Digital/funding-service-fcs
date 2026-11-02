namespace FCT.Console.Config.ExcelTypes
{
    using System;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Migrations;

    public class ProviderCategoryException : SheetTypeBase
    {
        public string FundingTypeCode { get; set; }

        public string FundingPeriodCode { get; set; }

        public string UKPRN { get; set; }

        public string Category { get; set; }

        public override bool Equals(Object obj)
        {
            return obj != null &&
                   obj is ProviderCategoryException other && 
                   (FundingTypeCode == other.FundingTypeCode &&
                    FundingPeriodCode == other.FundingPeriodCode &&
                    UKPRN == other.UKPRN);
        }

        public override int GetHashCode()
        {
            return FundingTypeCode.GetHashCode() ^ FundingPeriodCode.GetHashCode() ^ UKPRN.GetHashCode();
        }
    }
}
