namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Linq;
    using Castle.Core.Internal;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    [TestClass]
    public class ClosedCollectionRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void HeldReportedActualGroupRepository_GetRows_ShouldReturnAllRows()
        {
            // arrange
            const int numberOfClosedCollections = 50;

            ClearDownAllClosedCollections();
            CreateClosedCollections(numberOfClosedCollections);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var repository = new ClosedCollectionRepository();

                // act
                repository.GetClosedCollections();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var assertClosedCollections = context.ClosedCollections;

                // assert
                Assert.IsNotNull(assertClosedCollections, "ClosedCollections were not returned");
                Assert.AreEqual(numberOfClosedCollections, assertClosedCollections.Count(), "Incorrect number of ClosedCollections");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void HeldReportedActualGroupRepository_GetRows_ShouldReturnNoRows()
        {
            // arrange
            ClearDownAllClosedCollections();

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var repository = new ClosedCollectionRepository();

                // act
                repository.GetClosedCollections();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var assertClosedCollections = context.ClosedCollections;

                // assert
                Assert.IsNotNull(assertClosedCollections, "ClosedCollections were not returned");
                Assert.AreEqual(0, assertClosedCollections.Count(), "Incorrect number of ClosedCollections");
            }
        }

        private static void CreateClosedCollections(int numberOfItemsToCreate)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                Enumerable.Range(0, numberOfItemsToCreate).ToList().ForEach(i =>
                {
                    context.ClosedCollections.Add(
                        new ClosedCollection(
                            $"collectionType{i}", 
                            $"collectionType{i}",
                            new DateTime(2020,01,29), 
                            i)); 
                });

                context.SaveChanges();
            }
        }

        private static void ClearDownAllClosedCollections()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.ClosedCollections.ToList()
                    .ForEach(cc => context.ClosedCollections.Remove(cc));

                context.SaveChanges();
            }
        }
    }
}