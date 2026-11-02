namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class UnQueueFundingAllocationsForContractCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public string EventSource { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, EventSource: {EventSource}";
        }
    }
}