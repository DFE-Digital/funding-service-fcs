using EndToEndTests.ValueObjects;

namespace EndToEndTests.PageObjects
{
    public class PaymentManager
    {
        private ActualsManager _actualsManager;

        private CRMContracts _crmContracts;

        public PaymentManager(ActualsManager actualsManager, CRMContracts crmContracts)
        {
            _actualsManager = actualsManager;
            _crmContracts = crmContracts;
        }

        public void Calculate()
        {
            foreach (var summarisedActuals in _actualsManager.SummarisedActuals)
            {
                var payment = new Payment
                {
                    ContractId = _crmContracts.Contract.ContractId,
                    PeriodNumber = summarisedActuals.PeriodNumber,
                    ValuePounds = 1000,
                };

                _crmContracts.Add(payment);
            }
        }
    }
}
