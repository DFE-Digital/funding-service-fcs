namespace PMD.PaymentSchedule.DataStore.Tests.RepositoryTests
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class ProvisionIdentifierRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProvisionIdentifierRepository_ShouldUpdateAnExistingProvisionIdentifier()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;
            const string testProvisionIdentifierCode = "pi_test";
            const string testProvisionIdentifierName = "pi_name_test";
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.ProvisionIdentifiers.Where(pi => pi.AllocationNumber == testAllocationNumber)
                   .ForEach(pi => context.ProvisionIdentifiers.Remove(pi));

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.ProvisionIdentifiers.Add(new ProvisionIdentifier
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    ProvisionIdentifierCode = testProvisionIdentifierCode
                });

                context.SaveChanges();
            }
            DateTime testDateTime = DateTime.Now;

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                ProvisionIdentifierRepository repository = new ProvisionIdentifierRepository();

                repository.AddOrUpdate(new ProvisionIdentifier
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    ProvisionIdentifierCode = testProvisionIdentifierCode,
                    LastModifiedDate = testDateTime,
                    ProvisionIdentifierName = testProvisionIdentifierName
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingProvisionIdentifier = context.ProvisionIdentifiers.Find(testAllocationNumber,
                    testVersionNumber, testProvisionIdentifierCode);

                Assert.AreEqual(testProvisionIdentifierName, matchingProvisionIdentifier.ProvisionIdentifierName);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProvisionIdentifierRepository_ShouldInsertWhenThereIsNoExistingProvisionIdentifier()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;
            const string testProvisionIdentifierCode = "pi_test";
            const string testProvisionIdentifierName = "pi_name_test";
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.ProvisionIdentifiers.Where(pi => pi.AllocationNumber == testAllocationNumber)
                   .ForEach(pi => context.ProvisionIdentifiers.Remove(pi));

                context.SaveChanges();
            }

            DateTime testDateTime = DateTime.Now;

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                ProvisionIdentifierRepository repository = new ProvisionIdentifierRepository();

                repository.AddOrUpdate(new ProvisionIdentifier
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    ProvisionIdentifierCode = testProvisionIdentifierCode,
                    LastModifiedDate = testDateTime,
                    ProvisionIdentifierName = testProvisionIdentifierName
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingProvisionIdentifier = context.ProvisionIdentifiers.Find(testAllocationNumber,
                    testVersionNumber, testProvisionIdentifierCode);

                Assert.AreEqual(testProvisionIdentifierName, matchingProvisionIdentifier.ProvisionIdentifierName);
            }
        }
    }
}
