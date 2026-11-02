using System;
using EndToEndTests.PageObjects;
using EndToEndTests.ValueObjects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace EndToEndTests.Steps
{
    [Binding]
    public class PaymentCalculationSteps
    {
        private CRMContracts _crmContracts;
        private ActualsManager _actualsManager;
        private PaymentManager _paymentManager;

        [BeforeScenario]
        public void BeforeScenario()
        {
            _crmContracts = new CRMContracts();
            _actualsManager = new ActualsManager(_crmContracts);
            _paymentManager = new PaymentManager(_actualsManager, _crmContracts);
        }

        [Given(@"approved contract (.*) ready for payment")]
        public void GivenApprovedContractReadyForPayment(string contractId)
        {
            _crmContracts.Add(new Contract {ContractId = contractId, Status = "Approved"});
        }

        [Given(@"summarised actuals for period (.*) in FCS system")]
        public void GivenSummarisedActualsInFcsSystem(int periodNumber)
        {
            _actualsManager.SummarisedActuals.Add(new SummarisedActuals {PeriodNumber = periodNumber});
        }
        
        [When(@"the payment calculation is invoked")]
        public void WhenThePaymentCalculationIsInvoked()
        {
            _paymentManager.Calculate();
        }
        
        [Then(@"payments are added to the contract period (.*)")]
        public void ThenPaymentsAreAddedToTheContractPeriod(int p0)
        {
            Assert.AreEqual(1, _crmContracts.Payments.Count);
            Assert.AreEqual("abc123", _crmContracts.Payments[0].ContractId);
            Assert.AreEqual(1, _crmContracts.Payments[0].PeriodNumber);
            Assert.AreEqual(1000, _crmContracts.Payments[0].ValuePounds);
        }
    }
}
