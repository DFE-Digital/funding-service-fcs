using EndToEndTests.PageObjects;
using EndToEndTests.ValueObjects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace EndToEndTests.Steps
{
    [Binding]
    public class ApproveContractSteps
    {
        private CRMContracts _crmContracts;
        private ContractManager _contractManager;

        [BeforeScenario]
        public void BeforeScenario()
        {
            _crmContracts = new CRMContracts();
            _contractManager = new ContractManager(_crmContracts);
        }

        [Given(@"contract (.*) version (.*)")]
        public void GivenContractVersion(string contractId, int version)
        {
            _contractManager.Contract = new Contract {ContractId = contractId, Version = version};
        }
        
        [When(@"the Contract Advisor approves the contract")]
        public void WhenTheContractAdvisorApprovesTheContract()
        {
            _contractManager.Approve();
        }
        
        [Then(@"the contract state is Approved")]
        public void ThenTheContractStateIsApproved()
        {
            Assert.AreEqual("Approved", _crmContracts.Contract.Status);
        }
    }
}
