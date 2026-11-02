namespace FCT.Console.Config.ExcelTypes
{
    public class ClaimReconciliationDelGroupsSheetType : SheetTypeBase
    {
        public string ClaimReconciliationDeliverableGroupCode { get; set; }

        public string ClaimReconciliationDeliverableGroupName { get; set; }

        public bool CapClaimToProfile { get; set; }

        public bool ObtainProfileFromReferenceData { get; set; }
    }
}
