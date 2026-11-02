namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    /// <summary>
    ///  DBR-008
    /// </summary>
    public class DeliverablePeriodCrmIntentMustMatch : AbstractFileRule
    {
        public string ErrorMessage => ErrorMessages.DeliverablePeriodCrmIntentsDoNotMatch;

        public string SheetName => ContractBulkUpload.ContractDeliverableSheetFieldName;

        public override List<errorInfo> GetFailuresForItem(dataLoadResults itemToVailidate)
        {
            List<errorInfo> localErrors = new List<errorInfo>();

            ContractBulkUpload file = new ContractBulkUpload(itemToVailidate);

            List<DeliverableContainer> deliverables = new List<DeliverableContainer>();
            foreach (var row in file.ContractDeliverableSheet.row)
            {
                var ukprn = row.cell.First(c => c.columnName == ContractBulkUpload.Ukprn).Value;
                var fsc = row.cell.First(c => c.columnName == ContractBulkUpload.FundingStreamCode).Value;
                var deliverableCode = row.cell.First(c => c.columnName == ContractBulkUpload.DeliverableCode).Value;
                var deliveryOrganisation = row.cell.FirstOrDefault(c => c.columnName == ContractBulkUpload.DeliveryOrganisation)?.Value;

                var deliverable =
                    deliverables.SingleOrDefault(
                        d => d.Ukprn == ukprn && d.FSC == fsc && d.DeliverableCode == deliverableCode && d.DeliverableOrganisation == deliveryOrganisation);

                if (deliverable == null)
                {
                    deliverable = new DeliverableContainer { Ukprn = ukprn, FSC = fsc, DeliverableCode = deliverableCode, DeliverableOrganisation = deliveryOrganisation, Rows = new List<rowType>() };
                    deliverables.Add(deliverable);
                }

                deliverable.Rows.Add(row);
            }

            foreach (var deliverable in deliverables)
            {
                if (deliverable.Rows.GroupBy(r => r.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value).Count() > 1)
                {
                    localErrors.AddRange(deliverable.Rows.Select(r => new errorInfo
                    {
                        Value = ErrorMessage,
                        correlationId = r.id,
                        row = r.rowNumber,
                        sheet = SheetName
                    }));
                }
            }

            return localErrors;
        }

        private class DeliverableContainer
        {
            public string Ukprn { get; set; }

            public string FSC { get; set; }

            public string DeliverableCode { get; set; }

            public string DeliverableOrganisation { get; set; }

            public List<rowType> Rows { get; set; }
        }
    }
}
