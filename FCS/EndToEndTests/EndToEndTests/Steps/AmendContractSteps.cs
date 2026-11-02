using EndToEndTests.PageObjects;
using EndToEndTests.ValueObjects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace EndToEndTests.Steps
{
    [Binding]
    public class AmendContractSteps
    {
        private ContractManager _contractManager;
        private CRMContracts _crmContracts;

        [BeforeScenario]
        public void BeforeScenario()
        {
            _crmContracts = new CRMContracts();
            _contractManager = new ContractManager(_crmContracts);
        }

        [Given(@"allocations file contract (.*)")]
        public void GivenAllocationsFile(string contractId)
        {
            _contractManager.Contract = new Contract { ContractId = contractId };
        }

        [Given(@"approved contract (.*) version (.*)")]
        public void GivenApprovedContractVersion(string contractId, int version)
        {
            _crmContracts.Contract = new Contract {ContractId = contractId, Version = version, Status = "Approved"};
        }

        [When(@"the file is imported")]
        public void WhenTheFileIsImported()
        {
            _contractManager.ImportFileContents();
        }

        [Then(@"the contact is amended to version (.*)")]
        public void ThenTheContactIsAmended(int version)
        {
            Assert.AreEqual(version, _crmContracts.Contract.Version);
        }
    }
}
