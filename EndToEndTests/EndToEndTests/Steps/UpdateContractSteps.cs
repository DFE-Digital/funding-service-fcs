using System;
using EndToEndTests.PageObjects;
using EndToEndTests.ValueObjects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace EndToEndTests.Steps
{
    [Binding]
    public class UpdateContractSteps
    {
        private ContractManager _contractManager;
        private CRMContracts _crmContracts;

        [BeforeScenario]
        public void BeforeScenario()
        {
            _crmContracts = new CRMContracts();
            _contractManager = new ContractManager(_crmContracts);
        }

        [Given(@"update contract allocations file for contract (.*)")]
        public void GivenUpdateContractAllocationsFile(string contractId)
        {
            _contractManager.Contract = new Contract {ContractId = contractId};
        }
        
        [Given(@"draft contract (.*) version (.*)")]
        public void GivenDraftContractVersion(string contractId, int version)
        {
            _crmContracts.Add(new Contract {ContractId = contractId, Version = version, Status = "Draft"});
        }
        
        [When(@"the update file is imported")]
        public void WhenTheUpdateFileIsImported()
        {
            _contractManager.ImportFileContents();
        }
        
        [Then(@"the contact is updated")]
        public void ThenTheContactIsUpdated()
        {
            Assert.AreEqual(2, _crmContracts.Contract.Version);
        }
    }
}
