namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    public class ContractRequestCommandInfo
    {        
        public ContractRequestCommandInfo(object commandObject, string informationText, int loggingId)
        {
            InformationText = informationText;
            LoggingId = loggingId;
            CommandObject = commandObject;
        }

        public object CommandObject { get; }
        public string InformationText { get; }
        public int LoggingId { get; set; }
    }
}
