namespace Datafix.Tests.Tests
{
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrganisationRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void OrganisationRepository_ShouldUpdatePaaS()
        {
            const int ukprn = 10001895;
            const string newName = "test";

            OrganisationRepository.UpdateOrgName(ukprn, newName);
        }
    }
}
