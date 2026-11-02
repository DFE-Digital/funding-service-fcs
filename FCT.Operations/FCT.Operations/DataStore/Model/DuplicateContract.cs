namespace FCT.Operations.DataStore.Model
{
    public class DuplicateContract
    {
        private DuplicateContract()
        {
        }

        public DuplicateContract(string contractNumber, int version, int subVersion, int numDuplicateAllocations, int numDuplicateContracts)
        {
            ContractNumber = contractNumber;
            Version = version;
            SubVersion = subVersion;
            NumDuplicateAllocations = numDuplicateAllocations;
            NumDuplicateContracts = numDuplicateContracts;
        }

        public string ContractNumber { get; private set; }
        public int Version { get; private set; }
        public int SubVersion { get; private set; }
        public int NumDuplicateAllocations { get; private set; }
        public int NumDuplicateContracts { get; private set; }
    }
}
