namespace FCT.Console.Config.Synchronizers.Readers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingStreamPeriodReader
    {
        public IReadOnlyCollection<FundingStreamPeriodSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingStreamPeriodSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingStreamPeriodSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamPeriodCode = row.CellStringValue(1, "FundingStreamPeriodCode"),
                Name = row.CellStringValue(2, "Name"),
                PeriodTypeCode = row.CellStringValue(3, "PeriodTypeCode"),
                Period = row.CellStringValue(4, "Period"),
                StartDate = row.CellDateValue(5, "StartDate"),
                EndDate = row.CellDateValue(6, "EndDate"),
                FundingStreamCode = row.CellStringValue(7, "FundingStreamCode"),
                AllocationReferencePrefix = row.CellStringValue(8, "AllocationReferencePrefix"),
                ProcessFutureActuals = row.CellBooleanValue(9, "ProcessFutureActuals"),
                PersistCurrentActualsState = row.CellBooleanValue(10, "PersistCurrentActualsState"),
                PaymentMethod = row.CellStringValue(11, "PaymentMethod"),
                PaymentCappingPeriod = row.CellStringValue(12, "PaymentCappingPeriod"),
                PaymentCappingLevel = row.CellStringValue(13, "PaymentCappingLevel"),
                ZeroiseMissingActuals = row.CellBooleanValue(16, "ZeroiseMissingActuals"),
                ShouldCapPayments = row.CellBooleanValue(18, "ShouldCapPayments"),
                Procurement = row.CellStringValue(19, "Procurement"),
                ActivityCloseDate = row.CellNullableDateValue(20, "ActivityCloseDate"),
                ShouldUseContractAllocationDescription = row.CellBooleanValue(24, "ShouldUseContractAllocationDescription"),
                SummaryOfFundingDisplayName = row.CellStringValue(25, "SummaryOfFundingDisplayName"),
                ContractDocumentDisplayOrder = int.Parse(row.CellStringValue(26, "ContractDocumentDisplayOrder")),
                ShouldGenerateFundingAgreement = row.CellBooleanValue(27, "ShouldGenerateFundingAgreement"),
                GeneratePayments = row.CellBooleanValue(29, "GeneratePayments"),
                Template = row.CellStringValue(30, "Template"),
                ExtraPagesTemplate = row.CellStringValue(31, "ExtraPagesTemplate"),
                MultiCollectionReturns = row.CellBooleanValue(32, "MultiCollectionReturns"),
                FSPGroup = row.CellStringValueNullIfEmpty(34, "FSPGroup"),
                FundingAgreementDisplayName = row.CellStringValue(35, "FundingAgreementDisplayName"),
                FspReportingName = row.CellStringValue(36, "FspReportingName"),
                AgencyPayment = row.CellStringValue(44, "AgencyPayment"),                
                CreatedDate = DateTime.Now
            };
        }
    }
}
