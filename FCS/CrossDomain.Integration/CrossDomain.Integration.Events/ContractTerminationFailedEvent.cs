namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class ContractTerminationFailedEvent
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public string FailureReason { get; set; }

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}";
        }
    }
}
