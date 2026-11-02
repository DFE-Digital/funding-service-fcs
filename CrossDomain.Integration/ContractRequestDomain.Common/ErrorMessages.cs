namespace SFA.FCT.ContractRequestDomain.Common
{
    public class ErrorMessages
    {
        // File Level Validation Error Messages. 
        public const string FundingTypeCodeInvalidMessage = "Funding type specified is not a valid funding type.";
        public const string PeriodTypeCodeInvalidMessage = "Period type specified is not a valid Period type.";
        public const string PeriodInvalidMessage = "Period specified is not a valid Period.";
        public const string FileTypeInvalidMessage = "File type is not as expected. Expected file type is .xlsx";
        public const string FileNameInvalidMessage = "File name is not as expected";
        public const string FileStructureInvalidMessage = "File structure is not as expected. File structure expected as per 'Bulk Import File Specification'";
        public const string TypeCombinationInvalidMessage = "The combination of Funding Type, Period Type and Period is not a valid combination";
        public const string FileNameFundingTypeInvalidMessage = "Funding type code in file name should match the funding type code in the 'Control Sheet' tab";
        public const string FileNamePeriodTypeInvalidMessage = "Period type code in file name should match the Period type code in the 'Control Sheet' tab";
        public const string FileNamePeriodInvalidMessage = "Period n file name should match the Period code in the 'Control Sheet' tab";
        public const string NoContractsDataMessage = "The file must contain at least 1 Contract entry";
        
        // Message Level Validation Error Messages. 
        public const string EndDateBeforeStartDateErrorMessage = "An end date cannot be before the start date.";
        public const string MandatoryItemMissingErrorMessage = "<Data Item> is a mandatory field and therefore can not be null as specified in 'Bulk Import File Specification'";
        public const string DataTypeInvalidErrorMessage = "<Data Item> is not as per expected data type as specified in 'Bulk Import File Specification'";
        public const string DataLengthInvalidErrorMessage = "<Data Item> is not as per expected length as specified in 'Bulk Import File Specification'";
        public const string ConditionalMandatoryItemMissingErrorMessage = "<Data Item> is a mandatory field for the funding type and therefore can not be null as specified in the 'Bulk Import File Specification'.";
    }
}
