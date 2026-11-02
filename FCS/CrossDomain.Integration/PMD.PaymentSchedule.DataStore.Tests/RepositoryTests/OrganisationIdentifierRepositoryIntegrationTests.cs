namespace PMD.PaymentSchedule.DataStore.Tests.RepositoryTests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using UnitTests.Common;

    [TestClass]
    public class OrganisationIdentifierRepositoryIntegrationTests
    {
        const string TestAllocationNumber = "ALLOC-01";
        const int TestAllocationVersion = 1;

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.OrganisationIdentifiers.RemoveWhere(o => o.AllocationNumber == TestAllocationNumber && o.VersionNumber == TestAllocationVersion);

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationIdentifierRepository_GetOrganisationIdentifierForAllocation_ReturnsOrgIdentifierForGivenAllocation()
        {
            // Arrange
            
            string testUkprn = "12345";
            string testOrgId = "ORG000001";

            SetupTestData(TestAllocationNumber, TestAllocationVersion, testUkprn, testOrgId);

            var orgIdentifierRepo = new OrganisationIdentifierRepository();

            // Act
            var orgId = orgIdentifierRepo.GetOrganisationIdentiferForAllocation(TestAllocationNumber, TestAllocationVersion,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // Assert
            Assert.AreEqual(testOrgId, orgId.MainOrganisationIdentifier);
            Assert.AreEqual(testUkprn, orgId.OrganisationId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationIdentifierRepository_ShouldUpdateAnExistingOrganisationIdentifier()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;
            const string testMainOrgIdentifier = "oi_test";
            const string testOrganisationId = "oi_test_id";
            
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.OrganisationIdentifiers.Where(oi => oi.AllocationNumber == testAllocationNumber)
                   .ForEach(oi => context.OrganisationIdentifiers.Remove(oi));

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.OrganisationIdentifiers.Add(new OrganisationIdentifer
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    MainOrganisationIdentifier = testMainOrgIdentifier,
                    OrganisationId = testOrganisationId
                });

                context.SaveChanges();
            }

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                OrganisationIdentifierRepository repository = new OrganisationIdentifierRepository();

                repository.AddOrUpdate(new OrganisationIdentifer
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    MainOrganisationIdentifier = testMainOrgIdentifier,
                    OrganisationId = testOrganisationId,
                    OrganisationIdentifierName = OrganisationIdentifierName.LINKEDURNS
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingOrg = context.OrganisationIdentifiers.Find(testAllocationNumber,
                    testVersionNumber, testMainOrgIdentifier, testOrganisationId);

                Assert.AreEqual(OrganisationIdentifierName.LINKEDURNS, matchingOrg.OrganisationIdentifierName);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationIdentifierRepository_ShouldInsertWhenThereIsNoExistingOrganisationIdentifier()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;
            const string testMainOrgIdentifier = "oi_test";
            const string testOrganisationId = "oi_test_id";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.OrganisationIdentifiers.Where(oi => oi.AllocationNumber == testAllocationNumber)
                   .ForEach(oi => context.OrganisationIdentifiers.Remove(oi));

                context.SaveChanges();
            }

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                OrganisationIdentifierRepository repository = new OrganisationIdentifierRepository();

                repository.AddOrUpdate(new OrganisationIdentifer
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    MainOrganisationIdentifier = testMainOrgIdentifier,
                    OrganisationId = testOrganisationId,
                    OrganisationIdentifierName = OrganisationIdentifierName.LINKEDURNS
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingOrg = context.OrganisationIdentifiers.Find(testAllocationNumber,
                    testVersionNumber, testMainOrgIdentifier, testOrganisationId);

                Assert.AreEqual(OrganisationIdentifierName.LINKEDURNS, matchingOrg.OrganisationIdentifierName);
            }
        }

        private void SetupTestData(string testAllocationNumber, int testAllocationVersion, string testUkprn, string testOrgId)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.OrganisationIdentifiers.Add(new OrganisationIdentifer
                {
                    AllocationNumber = testAllocationNumber,
                    MainOrganisationIdentifier = testOrgId,
                    OrganisationId = testUkprn,
                    OrganisationIdentifierName = OrganisationIdentifierName.UKPRN,
                    VersionNumber = testAllocationVersion
                });

                context.SaveChanges();
            }
        }
    }
}
