namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;

    /// <summary>
    /// RSR-006 (originally FSR-011). Cannot delete a Contract Allocation/ Deliverable if there is already an existing Approved Contract.
    /// </summary>
    public class AmendmentMustNotDeleteAllocationOrDeliverable : AbstractFileRule
    {
        public string ErrorMessage
        {
            get { return ErrorMessages.NoDeleteOnApprovedContract; }
        }

        public override bool RunIfErrorsHaveAlreadyOccured => false;

        public override List<errorInfo> GetFailuresForItem(dataLoadResults itemToVailidate)
        {
            List<errorInfo> localErrors = new List<errorInfo>();

            ContractBulkUpload file = new ContractBulkUpload(itemToVailidate);

            foreach (var contractRow in file.ContractSheet.row)
            {
                var contractIntent = contractRow.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value;

                if (contractIntent == DataItems.CRMIntentTypeAmendment)
                {
                    var contractNumber = contractRow.cell.First(c => c.columnName == ContractBulkUpload.ContractNumber).Value;

                    foreach (var allocationRow in file.ContractAllocationSheet.row)
                    {
                        if (allocationRow.cell.First(c => c.columnName == ContractBulkUpload.ContractNumber).Value == contractNumber)
                        {
                            var allocationIntent = allocationRow.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value;

                            if (allocationIntent == DataItems.CRMIntentTypeDeleteDraft)
                            {
                                localErrors.Add(new errorInfo
                                {
                                    Value = ErrorMessage,
                                    correlationId = allocationRow.id,
                                    row = allocationRow.rowNumber,
                                    sheet = ContractBulkUpload.ContractAllocationSheetFieldName
                                });
                            }
                            else
                            {
                                var allocationNumber = allocationRow.cell.First(c => c.columnName == ContractBulkUpload.AllocationNumber).Value;
                                
                                foreach (var deliverableRow in file.ContractDeliverableSheet.row)
                                {
                                    if (deliverableRow.cell.First(c => c.columnName == ContractBulkUpload.AllocationNumber).Value == allocationNumber)
                                    {
                                        var deliverableIntent = deliverableRow.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value;

                                        if (deliverableIntent == DataItems.CRMIntentTypeDeleteDraft)
                                        {
                                            localErrors.Add(new errorInfo
                                            {
                                                Value =  ErrorMessage,
                                                correlationId = deliverableRow.id,
                                                row = deliverableRow.rowNumber,
                                                sheet = ContractBulkUpload.ContractDeliverableSheetFieldName
                                            });
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return localErrors;
        }
    }
}
