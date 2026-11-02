namespace PerformanceManagement.IntegrationTests.State
{
    using System.Collections.Generic;

    public class ClaimReferenceProfileValueState
    {
        public ClaimReferenceProfileValueState()
        {
            Values = new List<ClaimReferenceProfileValue>();   
        }

        public IList<ClaimReferenceProfileValue> Values { get; }
    }
}
