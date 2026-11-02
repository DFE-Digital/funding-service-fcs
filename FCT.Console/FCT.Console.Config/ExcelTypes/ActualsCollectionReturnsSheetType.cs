namespace FCT.Console.Config.ExcelTypes
{
    public class ActualsCollectionReturnsSheetType : SheetTypeBase
    {
        public int MultipleCollectionGroupId { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string CollectionType { get; set; }

        public string CollectionReturnCode { get; set; }
    }
}