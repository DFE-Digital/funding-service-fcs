namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public static class DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule
    {
        public static string ErrorMessage => ErrorMessages.CannotHaveMultipleRecordsForTheSameUkprnForNewOrNewAmendmentIntentContracts;

        public static string SheetName => ContractBulkUpload.ContractsSheetFieldName;

        public static List<errorInfo> GetFailuresForItem(dataLoadResults itemToVailidate)
        {
            IReadOnlyCollection<string> intentsWhereMultipleContractsAreNotAllowedWithTheSameUkprn = new List<string> { "New", "New Amendment" };
            List<errorInfo> localErrors = new List<errorInfo>();

            ContractBulkUpload bulkUploadFile = new ContractBulkUpload(itemToVailidate);
            var contractSheet = bulkUploadFile.ContractSheet;

            var simpleContracts =
                contractSheet.row.Select(
                    r =>
                        new SimpleContract(r.cell.First(c => c.columnName == ContractBulkUpload.Ukprn).Value,
                            r.cell.Single(c => c.columnName == ContractBulkUpload.CrmIntent).Value)).ToList();

            List<IGrouping<string, SimpleContract>> contractGroupsWithAnIntentThatDoesNotAllowMultipleForTheSameUkprn =
                simpleContracts.GroupBy(c => c.Ukprn)
                    .Where(g => g.Count() > 1)
                    .Where(g => g.Select(c => c.Intent)
                        .Any(intent => intentsWhereMultipleContractsAreNotAllowedWithTheSameUkprn.Contains(intent)))
                    .ToList();

            foreach (var contractGroup in contractGroupsWithAnIntentThatDoesNotAllowMultipleForTheSameUkprn)
            {
                var matchingRows =
                    contractSheet.row.Where(
                        c => c.cell.First(cv => cv.columnName == ContractBulkUpload.Ukprn).Value == contractGroup.Key).ToList();

                for (int i = 0; i < matchingRows.Count; i++)
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

        private class SimpleContract
        {
            public SimpleContract(string ukprn, string intent)
            {
                Ukprn = ukprn;
                Intent = intent;
            }

            public string Ukprn { get; }

            public string Intent { get; }
        }
    }
}
