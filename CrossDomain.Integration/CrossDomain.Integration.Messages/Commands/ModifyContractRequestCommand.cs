namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System.Linq;
    using Entities.ContractRequest;

    public abstract class ModifyContractRequestCommand
    {
        public contractRequestType ContractRequest { get; set; }

        public override string ToString()
        {
            string contractNumbers = string.Join(", ", ContractRequest.contract.contracts.Select(c => c.contractNumber));
            return $"MasterContractNumber: {ContractRequest.contract.contractNumber}, ContractNumber(s): {contractNumbers}, Ukrpn: {ContractRequest.contract.contractor.ukprn}";
        }
    }
}