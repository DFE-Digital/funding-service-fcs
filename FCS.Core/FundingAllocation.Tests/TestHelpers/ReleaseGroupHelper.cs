namespace FundingAllocation.Tests.TestHelpers
{
    using System;
    using DataStore.Model;

    public static class ReleaseGroupHelper
    {
        public static ReleaseGroup ReleaseGroupNamed(string releaseGroupName)
        {
            return new ReleaseGroup("", "", "","", Guid.Empty, releaseGroupName);
        }
    }
}
