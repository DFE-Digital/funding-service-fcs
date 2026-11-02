namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using System.Collections.Generic;
    using System.Linq;

    // RSR-008
    public class DeliveryOrgPresentThenAllMustBeSpecifiedRule : AbstractFileRule
    {
        public override bool RunIfErrorsHaveAlreadyOccured => false;

        private readonly string[] _crmIntentsApplicableForRule = {
            DataItems.CRMIntentTypeNew,
            DataItems.CRMIntentTypeUpdateDraft,
            DataItems.CRMIntentTypeAmendment,
            DataItems.CRMIntentTypeUpdateDraftAmendment,
            DataItems.CRMIntentTypeRevisedNew};

        public override List<errorInfo> GetFailuresForItem(dataLoadResults itemToVailidate)
        {
            List<errorInfo> localErrors = new List<errorInfo>();

            ContractBulkUpload file = new ContractBulkUpload(itemToVailidate);

            var contractIntent = file.ContractSheet.row.First().cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value;

            if (_crmIntentsApplicableForRule.Contains(contractIntent) && (file.ContractAllocationSheet.row.Any(HasRowGotDeliveryOrganisationColumn)
                || file.ContractDeliverableSheet.row.Any(HasRowGotDeliveryOrganisationColumn)))
            {
                var distinctUkprnInAllocationSheetGroups = file.ContractAllocationSheet.row.GroupBy(x => x.cell.First(cell=>cell.columnName == ContractBulkUpload.Ukprn).Value)
                    .Select(rows=> new DistinctUkprnsAndTheirRows(rows.Key, rows));

                var distinctUkprnInDeliverablePeriodsSheetGroups = file.ContractDeliverableSheet.row.GroupBy(x => x.cell.First(cell => cell.columnName == ContractBulkUpload.Ukprn).Value)
                    .Select(rows => new DistinctUkprnsAndTheirRows(rows.Key, rows));

                // First check from Contract Allocations Sheet to Deliverable Periods Sheet
                localErrors.AddRange(GetErrorsFromAllocationSheetToDeliverablePeriodSheetCheck( 
                    distinctUkPrnsInSourceSheet: distinctUkprnInAllocationSheetGroups,
                    destinationSheet: file.ContractDeliverableSheet,
                    sourceSheetName: file.ContractAllocationSheet.name));

                // Now check from Deliverable Periods Sheet to Contract Allocations Sheet
                localErrors.AddRange(GetErrorsFromAllocationSheetToDeliverablePeriodSheetCheck(
                    distinctUkPrnsInSourceSheet: distinctUkprnInDeliverablePeriodsSheetGroups,
                    destinationSheet: file.ContractAllocationSheet,
                    sourceSheetName: file.ContractDeliverableSheet.name));
            }

            return localErrors;
        }

        private IEnumerable<errorInfo> GetErrorsFromAllocationSheetToDeliverablePeriodSheetCheck(
            IEnumerable<DistinctUkprnsAndTheirRows> distinctUkPrnsInSourceSheet, 
            sheetType destinationSheet,
            string sourceSheetName)
        {
            List<errorInfo> localErrors = new List<errorInfo>();

            foreach (var ukprnGroup in distinctUkPrnsInSourceSheet)
            {
                bool deliveryOrganisationPresentOnAnySourceRow = ukprnGroup.Rows.Any(HasRowGotDeliveryOrganisationValue);
                bool deliveryOrganisationPresentOnAllSourceRows = ukprnGroup.Rows.All(HasRowGotDeliveryOrganisationValue);

                var destinationRowsForGivenUkprn = destinationSheet.row.Where(row => row.cell.First(cell => cell.columnName == ContractBulkUpload.Ukprn).Value == ukprnGroup.Ukprn);
                bool deliveryOrganisationPresentOnAllDestinationRows = destinationRowsForGivenUkprn.All(HasRowGotDeliveryOrganisationValue);

                if ((deliveryOrganisationPresentOnAnySourceRow && !deliveryOrganisationPresentOnAllSourceRows) ||
                    (deliveryOrganisationPresentOnAnySourceRow && !deliveryOrganisationPresentOnAllDestinationRows))
                {
                    localErrors.Add(new errorInfo
                    {
                        Value = ErrorMessages.DeliveryOrgPresentThenAllMustBeSpecified,
                        correlationId = ukprnGroup.Rows.First().id,
                        row = ukprnGroup.Rows.First().rowNumber,
                        sheet = sourceSheetName
                    });
                }
            }
            return localErrors;
        }

        private bool HasRowGotDeliveryOrganisationValue(rowType row)
        {
            return !string.IsNullOrWhiteSpace(row.cell.FirstOrDefault(cell=>cell.columnName == ContractBulkUpload.DeliveryOrganisation)?.Value);
        }

        private bool HasRowGotDeliveryOrganisationColumn(rowType row)
        {
            return row.cell.Any(cell => cell.columnName == ContractBulkUpload.DeliveryOrganisation);
        }

        private class DistinctUkprnsAndTheirRows
        {
            public string Ukprn { get; }
            public IEnumerable<rowType> Rows { get; }

            public DistinctUkprnsAndTheirRows(string ukprn, IEnumerable<rowType> rows)
            {
                Ukprn = ukprn;
                Rows = rows;
            }
        }
    }
}
