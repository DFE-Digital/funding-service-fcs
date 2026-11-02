namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    // RSR-007
    public class DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule : AbstractFileRule
    {
        private readonly bool _isAllowedToHaveDeliveryOrganisation;
        
        private readonly string _errorMessage;
            
        public DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(bool isAllowedToHaveDeliveryOrganisation, string fundingPeriod, string fundingTypeCode)
        {
            _isAllowedToHaveDeliveryOrganisation = isAllowedToHaveDeliveryOrganisation;
            _errorMessage = $"Delivery Organisations cannot be specified for Funding Type: {fundingTypeCode} Funding Period: {fundingPeriod} contracts";
        }

        public override List<errorInfo> GetFailuresForItem(dataLoadResults itemToValidate)
        {
            List<errorInfo> failures = new List<errorInfo>();

            if (!_isAllowedToHaveDeliveryOrganisation)
            {
                ContractBulkUpload file = new ContractBulkUpload(itemToValidate);

                // first check the contract allocation
                List<rowType> rowsWithDeliveryOrgColumnAndValue = file.ContractAllocationSheet.row.Where(HasRowDeliveryOrganisationColumnWithValue).ToList();       
                failures.AddRange(GetErrorInfosFromRows(rowsWithDeliveryOrgColumnAndValue, ContractBulkUpload.ContractAllocationSheetFieldName));

                // now check the deliverables
                rowsWithDeliveryOrgColumnAndValue = file.ContractDeliverableSheet.row.Where(HasRowDeliveryOrganisationColumnWithValue).ToList();

                failures.AddRange(GetErrorInfosFromRows(rowsWithDeliveryOrgColumnAndValue, ContractBulkUpload.ContractDeliverableSheetFieldName));
            }

            return failures;
        }

        private IEnumerable<errorInfo> GetErrorInfosFromRows(List<rowType> rows, string sheetName)
        {
            return rows.Select(row => new errorInfo
            {
                row = row.rowNumber,
                correlationId = row.id,
                sheet = sheetName,
                Value = _errorMessage
            }).ToList();
        }

        private static bool HasRowDeliveryOrganisationColumnWithValue(rowType row)
        {
            return row.cell.Any(cell => cell.columnName == ContractBulkUpload.DeliveryOrganisation && !string.IsNullOrEmpty(cell.Value));
        } 
    }
}
