namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests.Integration
{
    using System.Collections.Generic;
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingStreamPeriodRepositoryTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingStreamPeriodRepository_ShouldGet()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);

                IReadOnlyCollection<FSPGroup> groups = new FundingStreamPeriodRepository(context)
                    .GetFspGroups(new List<string> { "APPS1920", "ALLF1920", "ALLB1920", "AEBC-ASCL1920", "AEBC-19TRN1920", "16-18TRN1920" });

                Assert.AreEqual(4, groups.Count);
            }
        }
    }
}
