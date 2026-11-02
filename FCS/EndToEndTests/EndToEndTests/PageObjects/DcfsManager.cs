using System.Collections.Generic;
using EndToEndTests.ValueObjects;

namespace EndToEndTests.PageObjects
{
    public class DcfsManager
    {
        public List<SummarisedActuals> SummarisedActuals { get; set; }

        public DcfsManager()
        {
            SummarisedActuals = new List<SummarisedActuals>();
        }
    }
}
