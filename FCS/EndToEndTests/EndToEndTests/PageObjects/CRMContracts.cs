using System.Collections.Generic;
using EndToEndTests.ValueObjects;

namespace EndToEndTests.PageObjects
{
    public class CRMContracts
    {
        public int LastContractSeed { get; set; }
        public Contract Contract { get; set; }
        public List<Payment> Payments { get; set; }

        public CRMContracts()
        {
            Payments = new List<Payment>();
            LastContractSeed = 0;
        }

        public void Add(Contract contract)
        {
            Contract = contract.Clone();
        }

        public void Add(Payment payment)
        {
            Payments.Add(payment.Clone());
        }

        public void Create(Contract contract)
        {
            Contract = contract.Clone();
            Contract.ContractId = "abc" + ++LastContractSeed;
            Contract.Version = 1;
            Contract.Status = "Draft";
        }
    }
}
