namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    /// <summary>
    /// (CABR-013) All of the Tender Awards Reference's within all the allocations within all the contracts in the bulk upload file must be unique
    /// </summary>
    public class TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations
    {
        private static readonly IReadOnlyCollection<intent> IntentsThatAllowEmptyTenderAwardReference = new List<intent>
        {
            intent.Amendment, intent.UpdateDraft, intent.UpdateDraftAmendment
        };
        public string RuleNumber => "CABR-013";

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        /// <summary>
        /// Validates the Rule
        /// </summary>
        /// <param name="itemToValidate">The import file.</param>
        /// <returns>ExcelUpload errorInfo indicating a fail.</returns>
        public List<errorInfo> GetFailureForItem(dataLoadResults itemToValidate)
        {
            var import = new ContractBulkUpload(itemToValidate);
            var allocationSheet = import.ContractAllocationSheet;

            // if there is no Tender Award Reference column, we have nothing to validate
            // (and we let the 2nd level missing mandatory field validator fire)

            if (allocationSheet.row.FirstOrDefault()
                ?.cell.FirstOrDefault(c => c.columnName == ContractBulkUpload.TenderAwardReference) == null)
            {
                return new List<errorInfo>();
            }

            return (allocationSheet.row.Where(
                r => ESFFundingStreams.FundingStreams.Contains(
                        r.cell.Single(c => c.columnName == ContractBulkUpload.FundingStreamCode).Value))
                .Where(IsRowToBeIncluded) 
                .GroupBy(r => r.cell.Single(c => c.columnName == ContractBulkUpload.TenderAwardReference).Value)
                .Where(grp => grp.Count() > 1)).SelectMany(r => r).Select(r => new errorInfo
                {
                    Value = $"Sheet: {allocationSheet.name}, Row: {r.rowNumber + 1} - {ErrorMessages.TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations}",

                    row = r.rowNumber,
                    sheet = allocationSheet.name
                    //correlationId = 

                }).ToList();
        }

        private static bool IsRowToBeIncluded(rowType row)
        {
            string crmIntent = row.cell
                .SingleOrDefault(c => c.columnName == ContractBulkUpload.CrmIntent)?.Value;

            Enum.TryParse(value: crmIntent.Replace(" ", string.Empty), ignoreCase: true, result: out intent rowIntent);

            if (IntentsThatAllowEmptyTenderAwardReference.Contains(rowIntent))
            {
                return !string.IsNullOrEmpty(row.cell
                    .Single(c => c.columnName == ContractBulkUpload.TenderAwardReference).Value);
            }

            return true;
        }
    }
}
