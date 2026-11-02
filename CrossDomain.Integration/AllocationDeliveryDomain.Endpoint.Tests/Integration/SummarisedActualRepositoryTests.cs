namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;
    using ClosedCollection = SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model.ClosedCollection;

    [TestClass]
    public class SummarisedActualRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualRepository_ShouldReturnExpectedRows()
        {
            // arrange
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.ClosedCollections.RemoveWhere(cc => cc.CollectionType == "APPS");
                context.SaveChanges();

                context.ClosedCollections.Add(new ClosedCollection("APPS", "APPS01", DateTime.UtcNow, 100000));
                context.ClosedCollections.Add(new ClosedCollection("APPS", "APPS02", DateTime.UtcNow, 100000));
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = 201912,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1",
                    DeliverableCode = 2,
                    Period = 201912,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS02",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = 201912,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG2",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = 201912,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP2",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = 201912,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP2",
                    DeliverableCode = 1,
                    Period = 201912,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SaveChanges();
            }

            // act
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                SummarisedActualRepository repository = new SummarisedActualRepository();

                SummarisedActualOrgFspGroupKey groupKey = new SummarisedActualOrgFspGroupKey
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1"
                };

                IReadOnlyCollection<SummarisedActual> returnedSummarisedActuals = repository.GetSummarisedActuals(groupKey, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(2, returnedSummarisedActuals.Count, "Unexpected number of rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.CollectionType == "APPS"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.CollectionReturnCode == "APPS01"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.OrganisationId == "ORG1"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.FundingStreamPeriodCode == "FSP1"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.UopCode == "UOP1"), "Unexpected rows returned");
            }
        }
    }
}
