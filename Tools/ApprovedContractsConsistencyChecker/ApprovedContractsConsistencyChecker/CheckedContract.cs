
namespace ApprovedContractsConsistencyChecker
{
    public class CheckedContract
    {
        public string ContractNumber { get; set; }
        public int? ContractVersion { get; set; }
        public bool IsInAtomFeed { get; set; }

        public override string ToString()
        {
            return "Contract Number: " + ContractNumber + ", Contract Version:  " + ContractVersion;
        }

    }
}
