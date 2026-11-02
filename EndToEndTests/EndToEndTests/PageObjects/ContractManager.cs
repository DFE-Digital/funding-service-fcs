using EndToEndTests.ValueObjects;

namespace EndToEndTests.PageObjects
{
    class ContractManager
    {
        public Contract Contract { get; set; }
        private readonly CRMContracts _crmContracts;

        public ContractManager(CRMContracts crmContracts)
        {
            _crmContracts = crmContracts;
        }

        public void ImportFileContents()
        {
            if (_crmContracts.Contract == null)
            {
                _crmContracts.Create(Contract);
            }
            else
            {
                Contract.Version = _crmContracts.Contract.Version;
                Contract.Status = "Draft";

                if (_crmContracts.Contract.Status.Equals("Approved"))
                {
                    Contract.Version++;
                }

                _crmContracts.Add(Contract);
            }
        }

        public void Approve()
        {
            Contract.Status = "Approved";
            _crmContracts.Add(Contract);
        }
    }
}
