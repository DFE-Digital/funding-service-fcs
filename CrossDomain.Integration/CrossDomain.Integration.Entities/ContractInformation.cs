namespace SFA.FCT.CrossDomain.Integration.Entities
{
    using System.Collections.Generic;
    using System.Linq;

    public enum ContractStatus
    {
        Draft, Approved, Closed, Other, Withdrawn
    }

    public enum ContractSubStatus
    {
        Approved, PublishedtoProvider, AwaitingClosureApproval, ClosureInitiationinProgress, Closed, ClosureinProgress, Other, AwaitingTerminationInitiationApproval, AwaitingModificationApproval, Modified, Terminated, UnderTermination, WithdrawnByProvider, WithdrawnByAgency
    }

    public class ContractInformation
    {
        public ContractInformation()
        {
        }

        public ContractInformation(string contractNumber, string masterContractNumber,
           int contractVersionNumber, int subVersionNumber, string ukprn, ContractStatus contractStatus, ContractSubStatus contractSubStatus)
        {
            ContractNumber = contractNumber;
            MasterContractNumber = masterContractNumber;
            Ukprn = ukprn;
            ContractVersionNumber = contractVersionNumber;
            ContractStatus = contractStatus;
            ContractSubStatus = contractSubStatus;
            SubVersionNumber = subVersionNumber;
        }

        public string ContractNumber { get; set; }

        public string MasterContractNumber { get; set; }

        public string Ukprn { get; set; }

        public int SubVersionNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public ContractStatus ContractStatus { get; set; }

        public ContractSubStatus ContractSubStatus { get; set; }

        public IReadOnlyCollection<SimpleAllocationInfo> SimpleAllocationInfos { get; set; }

        public int NumberPartOfContractNumber => int.Parse(ContractNumber.Split('-').Last());

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, MasterContractNumber: {MasterContractNumber}, Ukprn: {Ukprn}, ContractVersionNumber: {ContractVersionNumber},  SubVersionNumber: {SubVersionNumber}, ContractStatus: {ContractStatus}, ContractSubStatus: {ContractSubStatus}";
        }
    }
}
