using System.Collections.Generic;
using EndToEndTests.ValueObjects;

namespace EndToEndTests.PageObjects
{
    public class ActualsManager
    {
        public List<SummarisedActuals> SummarisedActuals { get; set; }

        private CRMContracts _crmContracts;
        private readonly DcfsManager _dcfsManager;

        public ActualsManager(DcfsManager dcfsManager, CRMContracts crmContracts)
        {
            _dcfsManager = dcfsManager;
            _crmContracts = crmContracts;
            SummarisedActuals = new List<SummarisedActuals>();
        }

        public ActualsManager(CRMContracts crmContracts)
        {
            _dcfsManager = null;
            _crmContracts = crmContracts;
            SummarisedActuals = new List<SummarisedActuals>();
        }

        public void Import()
        {
            foreach (var summarisedActuals in _dcfsManager.SummarisedActuals)
            {
                SummarisedActuals.Add(summarisedActuals);
            }
        }
    }
}
