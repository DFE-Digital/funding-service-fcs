namespace SFA.FCT.CrossDomain.Integration.Messages.Messages
{
    using Entities.CorporateContract;

    public class DocumentGenerationComplete
    {
        public int Ukprn { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public string[] DocumentsPublished { get; set; }

        public contract Contract { get; set; }

        public string CorrelationId { get; set; }

        public override string ToString()
        {
            return $"Ukprn: {Ukprn}, ContractNumber: {ContractNumber}, ContractVersionNumber: {ContractVersionNumber}";
        }
    }
}
