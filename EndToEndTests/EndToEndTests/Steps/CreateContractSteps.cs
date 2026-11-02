using EndToEndTests.PageObjects;
using EndToEndTests.ValueObjects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace EndToEndTests.Steps
{
    [Binding]
    public class CreateContractSteps
    {
        private ContractManager _contractManager;
        private CRMContracts _crmContracts;

        [BeforeScenario]
        public void BeforeScenario()
        {
            _crmContracts = new CRMContracts();
            _contractManager = new ContractManager(_crmContracts);
        }

        [Given(@"create contract allocations file")]
        public void GivenCreateContractAllocationsFile()
        {
            _contractManager.Contract = new Contract();
        }
        
        [When(@"the create contract allocations file is imported")]
        public void WhenTheCreateContractAllocationsFileIsImported()
        {
            _crmContracts.Create(_contractManager.Contract);
        }
        
        [Then(@"the contact (.*) is created at version (.*)")]
        public void ThenTheContactIsCreatedAtVersion(string contractId, int version)
        {
            Assert.AreEqual("abc1", _crmContracts.Contract.ContractId);
            Assert.AreEqual(1, _crmContracts.Contract.Version);
            Assert.AreEqual("Draft", _crmContracts.Contract.Status);
        }
    }
}
