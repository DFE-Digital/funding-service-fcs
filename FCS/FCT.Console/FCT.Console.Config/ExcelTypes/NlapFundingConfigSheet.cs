namespace FCT.Console.Config.ExcelTypes
{
    public class NlapFundingConfigSheet : SheetTypeBase
    {
        public int Ukprn { get; set; }

        public decimal NewStarts2021Funding1618 { get; set; }

        public decimal NewStarts2021FundingAdult { get; set; }

        public decimal NewStartsEstimatedFutureFunding1618 { get; set; }

        public decimal NewStartsEstimatedFutureFundingAdult { get; set; }
    }
}
