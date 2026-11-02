namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public static class DataLoadResultsHelper
    {
        public static string GetFundingType(dataLoadResults dataLoadResults)
        {
            sheetType controlSheet = dataLoadResults.workbook.First(w => w.name == ContractBulkUpload.ControlSheetFieldName);

            rowType firstRowOfControlSheet = controlSheet.row.First();

            cellType fundingTypeCell =  firstRowOfControlSheet.cell.First(c => c.columnName == ContractBulkUpload.ControlSheetFundingTypeCode);

            return fundingTypeCell.Value;
        }

        public static string GetFundingPeriod(dataLoadResults dataLoadResults)
        {
            sheetType controlSheet = dataLoadResults.workbook.First(w => w.name == ContractBulkUpload.ControlSheetFieldName);

            rowType firstRowOfControlSheet = controlSheet.row.First();

            cellType periodCell = firstRowOfControlSheet.cell.First(c => c.columnName == ContractBulkUpload.ControlSheetPeriod);
            cellType periodTypeCell = firstRowOfControlSheet.cell.First(c => c.columnName == ContractBulkUpload.ControlSheetPeriodTypeCode);

            return periodTypeCell.Value + periodCell.Value;
        }
    }
}
