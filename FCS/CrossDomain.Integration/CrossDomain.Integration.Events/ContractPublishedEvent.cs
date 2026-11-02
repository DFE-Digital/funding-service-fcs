namespace SFA.FCT.CrossDomain.Integration.Events
{
    using System.Collections.Generic;
    using Entities;

    public class ContractPublishedEvent
    {
        public ContractPublishedEvent(IReadOnlyCollection<ContractIdentity> childContractIdentities, string masterContractNumber)
        {
            ChildContractIdentities = childContractIdentities;
            MasterContractNumber = masterContractNumber;
        }

        public IReadOnlyCollection<ContractIdentity> ChildContractIdentities { get; }
        public string MasterContractNumber { get; }

        public override string ToString()
        {
            return $"ChildContracts: {string.Join(", ", ChildContractIdentities ?? new List<ContractIdentity>())}, MasterContractNumber: {MasterContractNumber}";
        }
    }
}
