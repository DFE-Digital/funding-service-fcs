namespace SFA.FCT.ContractManagementDomain.Integration.Extensions
{
    using System.Linq;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Events;

    public static class CorporateContractExtensions
    {
        public static ContractPublishedEvent ToContractPublishedEvent(
            this SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract contract)
        {
            var childContracts = contract.contracts.Select(c =>
                new ContractIdentity(c.contractNumber, c.contractVersionNumber, c.contractSubVersionNumber)).ToList();

            return new ContractPublishedEvent(childContracts, masterContractNumber:contract.contractNumber);
        }
    }
}
