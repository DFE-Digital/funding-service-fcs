namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Text.RegularExpressions;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    /// <summary>
    /// (UDC-008) Checks that, for a Deliverable with a CRM Intent of Delete Draft: Contract Allocation Number, Funding Stream Code, and Deliverable code are
    /// populated for each Deliverable Period. 
    /// </summary>
    public class MustSpecifyDeliverableDetailsDeleteRule
    {
        public string RuleNumber
        {
            get { return "UDC-008"; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }

        /// <summary>
        /// Validates the Deliverables
        /// </summary>
        /// <param name="itemToValidate">The import file.</param>
        /// <returns>ExcelUpload errorInfo indicating a fail.</returns>
        public List<errorInfo> GetFailureForItem(dataLoadResults itemToValidate)
        {
            var import = new ContractBulkUpload(itemToValidate);
            var sheet = import.ContractDeliverableSheet;
            var errors = new List<errorInfo>();

            errors.AddRange((from r in sheet.row
                             let crmIntent = r.cell.SingleOrDefault(c => c.columnName == ContractBulkUpload.CrmIntent)
                             let allocationNumber = r.cell.SingleOrDefault(c => c.columnName == ContractBulkUpload.AllocationNumber)
                             let fundingStreamCode = r.cell.SingleOrDefault(c => c.columnName == ContractBulkUpload.FundingStreamCode)
                             let deliverableCode = r.cell.SingleOrDefault(c => c.columnName == ContractBulkUpload.DeliverableCode)
                             where (crmIntent != null && Regex.Replace(crmIntent.Value, @"\s+", string.Empty) == intent.DeleteDraft.ToString()) &&
                                   ((allocationNumber == null || string.IsNullOrWhiteSpace(allocationNumber.Value))
                                   || (fundingStreamCode == null || string.IsNullOrWhiteSpace(fundingStreamCode.Value))
                                   || (deliverableCode == null || string.IsNullOrWhiteSpace(deliverableCode.Value)))
                             select new errorInfo
                             {
                                 Value = string.Format("Sheet: {0}, Row: {1} - " + ErrorMessages.MustSpecifyDeliverableDetailsDeleteRule, sheet.name, r.rowNumber + 1)
                             }).ToList());

            return errors;
        }
    }
}