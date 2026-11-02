namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class AllocationsUnderTerminationQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationsUnderTerminationQueryRepository_GetTerminationDate_WhenAllocationUnderTerminationPresent_ShouldReturnTerminationDate()
        {
            const string contractNumber = "CONT-1234";
            const string allocationNumber = "TERMALLOC-123";
            DateTime expectedTerminationDate = new DateTime(2018, 09, 30, 0, 0, 0, DateTimeKind.Utc);
            DateTime? actualTerminationDate;

            // arrange
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationsUnderTermination.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);
                context.AllocationsUnderTermination.Add(new AllocationUnderTermination(contractNumber, allocationNumber, expectedTerminationDate));
                context.SaveChanges();
            }

            // act
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                AllocationsUnderTerminationQueryRepository repository = new AllocationsUnderTerminationQueryRepository();
                actualTerminationDate = repository.GetTerminationDate(allocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.IsNotNull(actualTerminationDate);
            Assert.AreEqual(expectedTerminationDate, actualTerminationDate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationsUnderTerminationQueryRepository_GetTerminationDate_WhenAllocationUnderTerminationNotPresent_ShouldReturnNull()
        {
            const string allocationNumber = "TERMALLOC-123";
            DateTime? actualTerminationDate;

            // arrange
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationsUnderTermination.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);
                context.SaveChanges();
            }

            // act
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                AllocationsUnderTerminationQueryRepository repository = new AllocationsUnderTerminationQueryRepository();
                actualTerminationDate = repository.GetTerminationDate(allocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.IsNull(actualTerminationDate);
        }
    }
}
