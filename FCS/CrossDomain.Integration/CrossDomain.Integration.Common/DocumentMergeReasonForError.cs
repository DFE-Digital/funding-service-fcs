namespace SFA.FCT.CrossDomain.Integration.Common
{
    public class DocumentMergeReasonForError
    {
        public const string DocumentNotUploaded =
            "Automatic merge cannot occur where documentation has not been uploaded for contract UKPRN: {UKPRN} & Contract: {ContractNumber}. Please upload documentation and re-try";

        public const string DocumentIncorrectOrderNumber50 =
           "Automatic merge cannot occur for contract UKPRN: {UKPRN} & Contract: {ContractNumber}. Failure is due to documentation using order number of 50. Please use a valid order number and re-try";

        public static string DocumentMergeFormattedErrorMessage(string val,string ukprn, string contractNumber) => val.Replace("{UKPRN}", ukprn).Replace("{ContractNumber}", contractNumber);
        
    }
}
