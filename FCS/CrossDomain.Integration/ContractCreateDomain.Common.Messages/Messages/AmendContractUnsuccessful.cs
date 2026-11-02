namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public class AmendContractUnsuccessful
    {
        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int Ukprn { get; set; }

        public contractRequestType ContractRequest { get; set; }

        public errorInfoType Error { get; set; }

        public override string ToString()
        {
            return $"MasterContractNumber: {MasterContractNumber}, " +
                   $"ContractNumber: {ContractNumber}, " +
                   $"ContractVersionNumber: {ContractVersionNumber}, " +
                   $"Ukprn: {Ukprn}";
        }
    }
}