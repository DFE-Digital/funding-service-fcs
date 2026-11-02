namespace SFA.FCT.CrossDomain.Integration.Messages.Dtos
{
    using Entities;

    public class ContractAndStatus
    {
        public ContractAndStatus(ContractIdentity contractIdentity, string status, string subStatus)
        {
            ContractIdentity = contractIdentity;
            Status = status;
            SubStatus = subStatus;
        }

        public ContractIdentity ContractIdentity { get; }

        public string Status { get; }

        public string SubStatus { get; }

        public override string ToString()
        {
            return $"ContractIdentity: {ContractIdentity}, Status: {Status}, SubStatus: {SubStatus}";
        }
    }
}