namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class ContractType
    {
        private ContractType() { }

        public ContractType(string contractTypeName)
        {
            ContractTypeName = contractTypeName;
        }

        [Key]
        [StringLength(100)]
        public string ContractTypeName { get; private set; }
    }
}