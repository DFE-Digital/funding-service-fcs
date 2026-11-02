namespace FCT.Console.Config.ExcelTypes
{
    public class SubnominalsSheetType : SheetTypeBase
    {
        public string SubnominalCode { get; set; }

        public string Code => SubnominalCode;

        public string ShortDescription { get; set; }

        public string PaymentSubnominalDesc => ShortDescription;

        public string PaymentType { get; set; }
    }

}