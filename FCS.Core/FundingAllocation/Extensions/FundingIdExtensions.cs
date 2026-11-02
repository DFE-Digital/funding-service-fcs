namespace FundingAllocation.Extensions
{
    using System;
    using Dto;

    public static class FundingIdExtensions
    {
        private static readonly Range RangeOfFundingName = Range.EndAt(new Index(1, fromEnd:true));
        public static decimal ToDecimal(this string version)
        {
            var numberParts = version.Split('_');
            var majorVersion = decimal.Parse(numberParts[0]);
            var minorVersion = decimal.Parse(numberParts[1])/100; // we do this to allow for up to 100 minor version

            return majorVersion + minorVersion;
        }

        public static FundingIdInfo ToFundingIdInfo(this string fundingId)
        {
            var items = fundingId.Split('-');
            var fundingIdName = string.Join("-", items[RangeOfFundingName]);
            var versionString = items[^1];
            return new FundingIdInfo(fundingId, fundingIdName, versionString.ToDecimal());
        }

        public static string RemoveVersionFromId(this string fundingId)
        {
            var items = fundingId.Split('-');

            return string.Join("-", items[RangeOfFundingName]);
        }
    }
}