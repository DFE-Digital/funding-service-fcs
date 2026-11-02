namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class DuplicateContract
    {
        private DuplicateContract() // for ef
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

        [Key, Column(Order = 0)]
        [Required, MaxLength(30)]
        public string ContractNumber { get; private set; }

        [Key, Column(Order = 1)]
        [Required]
        public int Version { get; private set; }

        [Key, Column(Order = 2)]
        [Required]
        public int SubVersion { get; private set; }

        public int NumDuplicateAllocations { get; private set; }

        public int NumDuplicateContracts { get; private set; }
    }
}
