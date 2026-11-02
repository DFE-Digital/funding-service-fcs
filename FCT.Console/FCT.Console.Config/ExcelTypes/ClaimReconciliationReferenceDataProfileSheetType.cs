namespace FCT.Console.Config.ExcelTypes
{
    public class ClaimReconciliationReferenceDataProfileSheetType : SheetTypeBase
    {
        public string ClaimReconciliationDeliverableGroupCode { get; set; }

        public int Ukprn { get; set; }

        public decimal PlannedValue { get; set; }
    }
}