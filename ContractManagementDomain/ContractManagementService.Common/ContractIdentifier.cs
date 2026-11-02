namespace SFA.FCT.ContractManagementService.Common
{
    public class ContractIdentifier
    {
        public string ContractNumber { get; }

        public int VersionNumber { get; }

        public int SubVersionNumber { get;}

        public ContractIdentifier(string contractNumber, int versionNumber, int subVersionNumber)
        {
            ContractNumber = contractNumber;
            VersionNumber = versionNumber;
            SubVersionNumber = subVersionNumber;
        }

        public bool IsValid()
        {
            return !string.IsNullOrEmpty(ContractNumber) &&
                   VersionNumber != 0;
        }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, Version: {VersionNumber}, SubVersion: {SubVersionNumber}";
        }

        public override bool Equals(object obj)
        {
            if (obj is ContractIdentifier other)
            {
                return ContractNumber == other.ContractNumber &&
                       VersionNumber == other.VersionNumber &&
                       SubVersionNumber == other.SubVersionNumber;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return ContractNumber.GetHashCode() ^ VersionNumber.GetHashCode() ^ SubVersionNumber.GetHashCode();
        }
    }
}
