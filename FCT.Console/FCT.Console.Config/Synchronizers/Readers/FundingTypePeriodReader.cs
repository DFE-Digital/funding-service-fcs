namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingTypePeriodReader
    {
        public IReadOnlyCollection<FundingTypePeriodSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingTypePeriodSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingTypePeriodSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeName = row.CellStringValue(1, "FundingTypeName"),
                FundingTypeCode = row.CellStringValue(2, "FundingTypeCode"),
                FundingPeriod = row.CellStringValue(3, "FundingPeriod"),
                ApprovalType = row.CellStringValue(4, "ApprovalType"),
                DocumentsRequired = row.CellBooleanValue(5, "DocumentsRequired"),
                SkipCaseloadAssignment = row.CellBooleanValue(6, "SkipCaseloadAssignment"),
                SkipReviewAndInternalApproval = row.CellBooleanValue(7, "SkipReviewAndInternalApproval"),
                SkipDocumentMerge = row.CellBooleanValue(8, "SkipDocumentMerge"),
                DefaultContractStartDate = row.CellNullableDateValue(10, "DefaultContractStartDate"),
                TemplateName = row.CellStringValueNullIfEmpty(11, "TemplateName"),
                ContractingActivityCloseDate = row.CellNullableDateValue(12, "ContractingActivityCloseDate"),
                AreContractsOpenEnded = row.CellBooleanValue(13, "AreContractsOpenEnded"),
                AllowUseOfDeliveryOrgs = row.CellBooleanValue(15, "AllowUseOfDeliveryOrgs"),
                AllowNewAmendment = row.CellBooleanValue(16, "AllowNewAmendment"),
                IncludeAllContractsOnSummaryOfFunding = row.CellBooleanValue(17, "IncludeAllContractsOnSummaryOfFunding"),
                AmendmentTemplate = row.CellStringValueNullIfEmpty(18, "AmendmentTemplate"),
                OnlyGenerateFundingAgreementForNewOrUpdatedAllocations = row.CellBooleanValue(19, "OnlyGenerateFundingAgreementForNewOrUpdatedAllocations"),
                FtpGroupCode = row.CellStringValueNullIfEmpty(20, "FtpGroupCode"),
                PrecedingFtpFundingType = row.CellStringValueNullIfEmpty(21, "PrecedingFtpFundingType"),
                PrecedingFtpFundingPeriod = row.CellStringValueNullIfEmpty(22, "PrecedingFtpFundingPeriod"),
                AllAmendmentsRequireSigning = row.CellBooleanValueNullIfEmpty(23, "AllAmendmentsRequireSigning"),
                ContractExpiryDate = row.CellNullableDateValue(24, "ContractExpiryDate")
            };
        }
    }
}
