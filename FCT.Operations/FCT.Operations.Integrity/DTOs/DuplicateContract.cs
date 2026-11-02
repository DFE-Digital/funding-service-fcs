namespace SFA.FCT.Operations.Integrity.DTOs
{
    public class DuplicateContract
    {
        public DuplicateContract(string contractNumber, int version, int subVersion, int numDuplicateAllocations, int numDuplicateContracts)
        {
            ContractNumber = contractNumber;
            Version = version;
            SubVersion = subVersion;
            NumDuplicateAllocations = numDuplicateAllocations;
            NumDuplicateContracts = numDuplicateContracts;
        }

        public string ContractNumber { get; }

        public int Version { get; }

        public int SubVersion { get; }

        public int NumDuplicateAllocations { get; }

        public int NumDuplicateContracts { get; }

        private bool HasDuplicateAllocations => NumDuplicateAllocations > 0;

        private bool HasDuplicateContracts => NumDuplicateContracts > 0;

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, Version: {Version}, SubVersion: {SubVersion}, HasDuplicateAllocations: {HasDuplicateAllocations}, HasDuplicateContracts: {HasDuplicateContracts}";
        }

        public override bool Equals(object obj)
        {
            if (obj is DuplicateContract other)
            {
                return other.ContractNumber == ContractNumber 
                       && other.Version == Version 
                       && other.SubVersion == SubVersion
                    && other.NumDuplicateAllocations == NumDuplicateAllocations
                    && other.NumDuplicateContracts == NumDuplicateContracts;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return ContractNumber.GetHashCode() 
                   ^ Version.GetHashCode() 
                   ^ SubVersion.GetHashCode()
                   ^ NumDuplicateAllocations.GetHashCode()
                   ^ NumDuplicateContracts.GetHashCode();
        }
    }
}