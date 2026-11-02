namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation.UDC
{
    using System.Text.RegularExpressions;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using Common;

    public class DeliverableMustHaveRelatedContractBRule
    {
        public string RuleNumber
        {
            get { return "UDC-018b"; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }

        /// <summary>
        /// Validates the Allocations
        /// </summary>
        /// <param name="itemToValidate">The import file.</param>
        /// <returns>ExcelUpload errorInfo indicating a fail.</returns>
        public List<errorInfo> GetFailureForItem(dataLoadResults itemToValidate)
        {
            var import = new ContractBulkUpload(itemToValidate);
            var allocationSheet = import.ContractAllocationSheet;
            var deliverableSheet = import.ContractDeliverableSheet;
            var errors = new List<errorInfo>();

            string updateDraftAmendmentString = intent.UpdateDraftAmendment.ToString();

            var anyUpdateDraftAmendmentRows =
                deliverableSheet.row.Any(r => r.cell.Any(c => c.columnName == ContractBulkUpload.CrmIntent && Regex.Replace(c.Value, @"\s+", string.Empty) == updateDraftAmendmentString));

            if (anyUpdateDraftAmendmentRows)
            {
                var allocationsOnAllocationsSheet =
                    allocationSheet.row.Select(r => r.cell.Single(c => c.columnName == ContractBulkUpload.AllocationNumber).Value).Distinct().ToArray();

                errors.AddRange(
                    from r in deliverableSheet.row
                    let crmIntent = r.cell.Single(c => c.columnName == ContractBulkUpload.CrmIntent).Value
                    where !string.IsNullOrWhiteSpace(crmIntent) && Regex.Replace(crmIntent, @"\s+", string.Empty) == updateDraftAmendmentString
                    let allocationNumber = r.cell.Single(c => c.columnName == ContractBulkUpload.AllocationNumber).Value
                    where !string.IsNullOrEmpty(allocationNumber)
                    where !allocationsOnAllocationsSheet.Contains(allocationNumber)
                    select new errorInfo
                    {
                        Value = string.Format("Sheet: {0}, Row: {1} - " + ErrorMessages.DeliverableMustHaveRelatedContractBRule, deliverableSheet.name, r.rowNumber + 1)
                    });
            }

            return errors;
        }
    }
}