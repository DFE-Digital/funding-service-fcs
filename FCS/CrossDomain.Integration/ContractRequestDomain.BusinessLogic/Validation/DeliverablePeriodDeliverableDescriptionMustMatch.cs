namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    /// <summary>
    ///  DBR-009
    /// </summary>
    public class DeliverablePeriodDeliverableDescriptionMustMatch : AbstractFileRule
    {
        private string ErrorMessage => ErrorMessages.DeliverablePeriodDeliverableDescriptionsDoNotMatch;

        private string SheetName => ContractBulkUpload.ContractDeliverableSheetFieldName;

        public override List<errorInfo> GetFailuresForItem(dataLoadResults itemToValidate)
        {
            var file = new ContractBulkUpload(itemToValidate);

            var errors =
                file.ContractDeliverableSheet.row.Select(MapToDeliverableData)
                    .GroupBy(dd => new
                    {
                        Ukprn = dd.Ukprn,
                        FundingStreamCode = dd.FundingStreamCode,
                        AllocationRef = dd.AllocationRef,
                        DeliverableCode = dd.DeliverableCode,
                    })
                    .Where(g => g.Select(d => d.DeliverableDescription).Distinct().Count() > 1)
                    .SelectMany(g => g.Select(r => new errorInfo
                    {
                        correlationId = r.CorrelationId,
                        row = r.RowNumber,
                        sheet = SheetName,
                        Value = ErrorMessage
                    }))
                    .ToList();

            return errors;
        }

        private DeliverableData MapToDeliverableData(rowType deliverableRow)
        {
            string ukprn = deliverableRow.cell.Single(c => c.columnName == ContractBulkUpload.Ukprn).Value;
            string fundingStreamCode = deliverableRow.cell.Single(c => c.columnName == ContractBulkUpload.FundingStreamCode).Value;
            string allocation = deliverableRow.cell.Single(c => c.columnName == ContractBulkUpload.AllocationNumber).Value;
            string deliverableCode = deliverableRow.cell.Single(c => c.columnName == ContractBulkUpload.DeliverableCode).Value;
            string deliverableDescription = deliverableRow.cell.Single(c => c.columnName == ContractBulkUpload.DeliverableDescription).Value;
            string correlationId = deliverableRow.id;
            int rowNumber = deliverableRow.rowNumber;

            return new DeliverableData(ukprn, fundingStreamCode, allocation, deliverableCode, deliverableDescription, correlationId, rowNumber);
        }

        private class DeliverableData
        {
            public DeliverableData(string ukprn, string fundingStreamCode, string allocationRef, string deliverableCode, string deliverableDescription, string correlationId, int rowNumber)
            {
                Ukprn = ukprn;
                FundingStreamCode = fundingStreamCode;
                AllocationRef = allocationRef;
                DeliverableCode = deliverableCode;
                DeliverableDescription = deliverableDescription;
                CorrelationId = correlationId;
                RowNumber = rowNumber;
            }

            public string Ukprn { get; }

            public string FundingStreamCode { get; }

            public string AllocationRef { get; }

            public string DeliverableCode { get; }

            public string DeliverableDescription { get; }

            public string CorrelationId { get; }

            public int RowNumber { get; }
        }
    }
}
