using EndToEndTests.PageObjects;
using EndToEndTests.ValueObjects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace EndToEndTests.Steps
{
    [Binding]
    public class ImportActualsSteps
    {
        private CRMContracts _crmContracts;
        private DcfsManager _dcfsManager;
        private ActualsManager _actualsManager;

        [BeforeScenario]
        public void BeforeScenario()
        {
            _crmContracts = new CRMContracts();
            _dcfsManager = new DcfsManager();
            _actualsManager = new ActualsManager(_dcfsManager, _crmContracts);
        }

        [Given(@"approved contract (.*) version (.*) period (.*)")]
        public void GivenApprovedContractVersionPeriod(string contractId, int version, int period)
        {
            _crmContracts.Contract = new Contract { ContractId = contractId, Version = version, Status = "Approved"};
        }

        [Given(@"summarised actuals")]
        public void GivenSummarisedActuals()
        {
            _dcfsManager.SummarisedActuals.Add(new SummarisedActuals());
        }

        [When(@"the summarised actuals import process is invoked")]
        public void WhenTheSummarisedActualsImportProcessIsInvoked()
        {
            _actualsManager.Import();
        }
        
        [Then(@"summarised actuals are imported into FCS")]
        public void ThenSummarisedActualsAreImportedIntoFcs()
        {
            Assert.AreEqual(1, _actualsManager.SummarisedActuals.Count);
        }
    }
}
