namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public static class DuplicateContractsForASingleUkprnRule
    {
        public static string ErrorMessage => ErrorMessages.CannotHaveMultipleRecordsForTheSameUkprn;

        public static string SheetName => ContractBulkUpload.ContractsSheetFieldName;

        public static List<errorInfo> GetFailuresForItem(dataLoadResults itemToVailidate)
        {
            List<errorInfo> localErrors = new List<errorInfo>();

            ContractBulkUpload bulkUploadFile = new ContractBulkUpload(itemToVailidate);
            var contracts = bulkUploadFile.ContractSheet;

            List<string> ukprnList = new List<string>();
            foreach (var row in contracts.row)
            {
                ukprnList.Add(row.cell.First(c => c.columnName == ContractBulkUpload.Ukprn).Value);
            }

            ukprnList = ukprnList.GroupBy(n => n).Where(c => c.Count() > 1).Select(group => group.Key).ToList();

            foreach (var ukprn in ukprnList)
            {
                var matchingRows =
                    contracts.row.Where(
                        c => c.cell.First(cv => cv.columnName == ContractBulkUpload.Ukprn).Value == ukprn).ToList();

                for (int i = 0; i < matchingRows.Count(); i++)
                {
                    localErrors.Add(new errorInfo
                    {
                        row = matchingRows[i].rowNumber,
                        correlationId = matchingRows[i].id,
                        sheet = SheetName,
                        Value = ErrorMessage
                    });
                }
            }

            return localErrors;
        }
    }
}