namespace SFA.FCT.DocumentsDomain.Common.Commands
{
    using CrossDomain.Integration.Entities.CorporateContract;
    using Framework.Logging;

    [LogDetails]
    public class DocumentSaveCommand
    {
        [LogDetail("Length")]
        public byte[] FCTDocumentDatabus { get; set; }

        [LogDetail]
        public string TargetFileName { get; set; }

        [LogDetail]
        public string DocumentLocation { get; set; }

        public string UKPRN { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public bool SendReply { get; set; }

        [LogDetail]
        public contract Contract { get; set; }

        [LogDetail]
        public string CorrelationId { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, ContractVersionNumber {ContractVersionNumber}, TargetFileName: {TargetFileName}";
        }
    }
}
