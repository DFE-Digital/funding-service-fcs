namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.CorporateContract;
    using Framework.Logging;

    [LogDetails]
    public class DocumentGenerationCommand
    {
        [LogDetail]
        public string CorrelationId { get; set; }

        [LogDetail]
        public Contract CorporateContract { get; set; }

        [LogDetail]
        public string MasterContractNumber { get; set; }

        public override string ToString()
        {
            return $"{CorporateContract}";
        }
    }
}
