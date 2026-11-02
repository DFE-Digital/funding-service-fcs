namespace SFA.FCT.CrossDomain.Integration.Entities
{
    public class ContractIdentity
    {
        public ContractIdentity(string contractNumber, int versionNumber, int subVersionNumber)
        {
            ContractNumber = contractNumber;
            VersionNumber = versionNumber;
            SubVersionNumber = subVersionNumber;
        }

        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, Version: {VersionNumber}, SubVersion: {SubVersionNumber}";
        }
    }
}