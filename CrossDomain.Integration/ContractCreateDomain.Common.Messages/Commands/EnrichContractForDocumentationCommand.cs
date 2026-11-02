namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class EnrichContractForDocumentationCommand
    {
        public contract Contract { get; set; }

        public string MasterContractNumber { get; set; }

        public string ReplyToEndpointName { get; set; }

        public override string ToString() =>
            $"Contract: {Contract}, MasterContractNumber: {MasterContractNumber}, ReplyToEndpointName: {ReplyToEndpointName}, Ukprn: {Contract.contractor.ukprn}";
    }
}
