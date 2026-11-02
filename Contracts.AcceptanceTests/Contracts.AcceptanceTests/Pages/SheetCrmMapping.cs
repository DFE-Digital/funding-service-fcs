namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;

    public static class SheetCrmMapping
    {
        public const string ContractSheetName = "Contract";
        public const string ControlSheetName = "Control Sheet";
        public const string DeliverableSheetName = "Deliverable";
        public const string ContractAllocationSheetName = "Contract Allocation";
        public const string UkPrnAttributeKeyName = "sfa_ukprn";
        public const string FundingStreamCodeColumn = "sfa_fundingstream";
        public const string DeliverablePlannedValueColumn = "sfa_maximumcontractvalue";
        public const string ContractValueColumn = "sfa_contractvalue";
        public const string FundingStreamCodeKeyName = "sfa_fundingstreamcode";
        public const string DeliverableCodeColumn = "sfa_deliverablecode";
        public const string ValueColumn = "sfa_maximumcontractvalue";
        public const string VolumeColumn = "sfa_vol";
        public const string UnitCostColumn = "sfa_unitCost";
        public const string DeliverablePlannedValue = "sfa_plannedvalue";
        public const string DeliverableName = "sfa_deliverablename";
        public const string PeriodName = "sfa_periodname";
        public const string AmendmentReason = "sfa_amendmentreason";
        public const string ParentDeliverable = "sfa_parentdeliverableid";
        
        private static readonly IDictionary<string, IDictionary<string, string>> SheetsMappings = new Dictionary<string, IDictionary<string, string>>();
        
        static SheetCrmMapping()
        {
            IDictionary<string, string> sheetMapping = new Dictionary<string, string>();
            sheetMapping.Add(UkPrnAttributeKeyName, "A");
            sheetMapping.Add("sfa_startdate", "C");
            sheetMapping.Add("sfa_enddate", "D");
            sheetMapping.Add("sfa_name", "I"); // this is the contract type
            SheetsMappings.Add(ContractSheetName, sheetMapping);

            sheetMapping = new Dictionary<string, string>();
            sheetMapping.Add("sfa_fundingtypecode", "A");
            sheetMapping.Add("sfa_periodtypecode", "B");
            sheetMapping.Add("sfa_period", "C");
            SheetsMappings.Add(ControlSheetName, sheetMapping);

            sheetMapping = new Dictionary<string, string>();
            sheetMapping.Add(UkPrnAttributeKeyName, "A");
            sheetMapping.Add(FundingStreamCodeColumn, "C");
            sheetMapping.Add(DeliverablePlannedValueColumn, "G");
            sheetMapping.Add(DeliverableCodeColumn, "H");
            sheetMapping.Add(VolumeColumn, "J");
            sheetMapping.Add(UnitCostColumn, "K");
            SheetsMappings.Add(DeliverableSheetName, sheetMapping);

            sheetMapping = new Dictionary<string, string>();
            sheetMapping.Add(UkPrnAttributeKeyName, "A");
            sheetMapping.Add(AmendmentReason, "R");
            sheetMapping.Add(FundingStreamCodeColumn, "G");
            SheetsMappings.Add(ContractAllocationSheetName, sheetMapping);
        }

        public static string GetCellAddress(string sheetName, string crmAttributeName, int row)
        {
            string cellAddress = null;
            if (SheetsMappings.ContainsKey(sheetName) && SheetsMappings[sheetName].ContainsKey(crmAttributeName))
            {
                cellAddress = SheetsMappings[sheetName][crmAttributeName] + row.ToString();
            }
            else
            {
                throw new Exception(string.Format("Sheet mapping {0} does not have the attribute {1}", sheetName, crmAttributeName));
            }

            return cellAddress;
        }
    }
}
