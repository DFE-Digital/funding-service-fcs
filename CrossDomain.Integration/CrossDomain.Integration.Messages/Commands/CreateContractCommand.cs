namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.CorporateContract;

    public class CreateContractCommand
    {
        public string CorrelationId { get; set; }

        public string BatchId { get; set; }

        public ExtendedContractType CorporateContract { get; set; }

        public override string ToString()
        {
            return CorporateContract != null ? CorporateContract.ToString() : "Empty";
        }
    }
}
