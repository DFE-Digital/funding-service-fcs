namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Text.RegularExpressions;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class ContractAllocationMustHaveRelatedContractRule
    {
        public string RuleNumber
        {
            get { return "UDC-017"; }
        }
        
        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Allocation; }
        }

        /// <summary>
        /// Validates the Allocations
        /// </summary>
        /// <param name="itemToValidate">The import file.</param>
        /// <returns>ExcelUpload errorInfo indicating a fail.</returns>
        public List<errorInfo> GetFailureForItem(dataLoadResults itemToValidate)
        {
            var import = new ContractBulkUpload(itemToValidate);
            var contractSheet = import.ContractSheet;
            var allocationSheet = import.ContractAllocationSheet;
            var errors = new List<errorInfo>();

            string updateDraftString = intent.UpdateDraft.ToString();

            var anyUpdateDraftRows =
                allocationSheet.row.Any(r => r.cell.Any(c => c.columnName == ContractBulkUpload.CrmIntent && Regex.Replace(c.Value, @"\s+", string.Empty) == updateDraftString));

            if (anyUpdateDraftRows)
            {
                var contractsOnContractSheet =
                    contractSheet.row.Select(r => r.cell.Single(c => c.columnName == ContractBulkUpload.ContractNumber).Value).Distinct().ToArray();

                errors.AddRange(
                    from r in allocationSheet.row
                    let crmIntent = r.cell.Single(c => c.columnName == ContractBulkUpload.CrmIntent).Value
                    where !string.IsNullOrWhiteSpace(crmIntent) && Regex.Replace(crmIntent, @"\s+", string.Empty) == updateDraftString
                    let contractNumber = r.cell.Single(c => c.columnName == ContractBulkUpload.ContractNumber).Value
                    where !string.IsNullOrEmpty(contractNumber)
                    where !contractsOnContractSheet.Contains(contractNumber)
                    select new errorInfo
                    {
                        Value = string.Format("Sheet: {0}, Row: {1} - " + ErrorMessages.ContractAllocationMustHaveRelatedContractRule, allocationSheet.name, r.rowNumber + 1)
                    });
            }

            return errors;
        }
    }
}
