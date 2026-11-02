namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class DraftContractDeletedEvent
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, Version: {VersionNumber}, SubVersion: {SubVersionNumber}";
        }
    }
}