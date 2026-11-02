namespace SFA.FCT.ContractRequestDomain.Common.Commands
{
    public class StartBulkImportProcessingCommand
    {
        public string BatchId { get; set; }

        public string Filename { get; set; }
    }
}
