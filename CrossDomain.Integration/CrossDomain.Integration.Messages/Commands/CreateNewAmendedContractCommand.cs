namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.CorporateContract;

    public class CreateNewAmendedContractCommand
    {
        public string CorrelationId { get; set; }

        public string BatchId { get; set; }

        public ExtendedContractType CorporateContract { get; set; }
    }
}
