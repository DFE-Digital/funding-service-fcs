namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public class ContractBulkUpload
    {
        // Sheet Names
        public const string ControlSheetFieldName = "Control Sheet";
        public const string ContractsSheetFieldName = "Contract";
        public const string ContractAllocationSheetFieldName = "Contract Allocation";
        public const string ContractDeliverableSheetFieldName = "Deliverable";

        // Control Sheet Fields
        public const string ControlSheetPeriod = "Period";
        public const string ControlSheetPeriodTypeCode = "PeriodTypeCode";
        public const string ControlSheetFundingTypeCode = "FundingTypeCode";

        // Contract Fields
        public const string ContractStartDate = "ContractStartDate";
        public const string ContractEndDate = "ContractEndDate";
        public const string CrmIntent = "CRMIntent";
        public const string AmendmentType = "AmendmentType";
        public const string Ukprn = "UKPRN";
        public const string ContractNumber = "ContractNumber";
        public const string ContractType = "ContractType";
        public const string ContractDescription = "ContractDescription";

        // Allocation Fields
        public const string AllocationsStartDate = "StartDate";
        public const string AllocationsEndDate = "EndDate";
        public const string AllocationNumber = "ContractAllocationNumber";
        public const string AllocationLepName = "LEPName";
        public const string FundingStreamCode = "FundingStreamCode";
        public const string TenderAwardReference = "TenderAwardReference";

        // Deliverable Fields
        public const string DeliverableName = "DeliverableName";
        public const string Period = "Period";
        public const string Year = "Year";
        public const string DeliverableCode = "DeliverableCode";
        public const string Value = "Value";
        public const string DeliverableDescription = "DeliverableDescription";
        public const string Volume = "Volume";

        public const string DeliveryOrganisation = "DeliveryOrganisation";

        public ContractBulkUpload(dataLoadResults baseDataLoadResults)
        {
            BaseClass = baseDataLoadResults;
        }

        public dataLoadResults BaseClass { get; set; }

        public sheetType ControlSheet
        {
            get { return BaseClass.GetSheet(ControlSheetFieldName); }
        }

        public sheetType ContractSheet
        {
            get { return BaseClass.GetSheet(ContractsSheetFieldName); }
        }

        public sheetType ContractAllocationSheet
        {
            get { return BaseClass.GetSheet(ContractAllocationSheetFieldName); }
        }

        public sheetType ContractDeliverableSheet
        {
            get { return BaseClass.GetSheet(ContractDeliverableSheetFieldName); }
        }

        public string GetCellValue(sheetType sheet, string columnName, int rowNumber)
        {
            string errorMessage;
            if (sheet.row.Count() > rowNumber)
            {
                var cell = sheet.row[rowNumber].GetCellValue(columnName);
                if (cell != null)
                {
                    return cell;
                }

                errorMessage = "Cell value not found.";
            }
            else
            {
                errorMessage = "Row not found.";
            }

            throw new Exception(errorMessage);
        }
    }
}