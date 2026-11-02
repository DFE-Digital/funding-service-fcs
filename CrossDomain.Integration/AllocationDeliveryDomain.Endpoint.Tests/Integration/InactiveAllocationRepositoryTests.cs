namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class InactiveAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void InactiveAllocationRepository_AddOrUpdate_ShouldAddInactiveAllocationWhenItDoesntPreviouslyExist()
        {
            // Arrange 
            const string contractAllocationNumber = "TEST_ALLOC_NEW";
            const InactiveReason inactiveReason = InactiveReason.Closed;

            InactiveAllocation inactiveAllocation = new InactiveAllocation(contractAllocationNumber: contractAllocationNumber, reason: inactiveReason);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // remove
                context.InactiveAllocations.RemoveWhere(ia => ia.ContractAllocationNumber == contractAllocationNumber);
                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var inactiveAllocationRepository = new InactiveAllocationRepository(context);
                // Act
                inactiveAllocationRepository.AddOrUpdate(inactiveAllocation, ConnectionInfo.CreateDefault());
                inactiveAllocationRepository.SaveChanges();

                // Assert
                List<InactiveAllocation> inactiveAllocationsToAssert = context.InactiveAllocations
                    .Where(ac => ac.ContractAllocationNumber == contractAllocationNumber).ToList();

                Assert.AreEqual(1, inactiveAllocationsToAssert.Count, "One Contract Allocation record should have been returned");
                Assert.AreEqual(contractAllocationNumber, inactiveAllocationsToAssert[0].ContractAllocationNumber, "Incorrect Contract Allocation Number returned");
                Assert.AreEqual(inactiveReason, inactiveAllocationsToAssert[0].Reason, "Incorrect inactive reason returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InactiveAllocationRepository_AddOrUpdate_ShouldUpdateInactiveAllocationWhenItAlreadyExisted()
        {
            // Arrange 
            const string contractAllocationNumber = "TEST_ALLOC_UPDATE";
            const InactiveReason inactiveReason = InactiveReason.Closed;

            InactiveAllocation inactiveAllocation = new InactiveAllocation(contractAllocationNumber: contractAllocationNumber, reason: inactiveReason);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // remove
                context.InactiveAllocations.RemoveWhere(ia => ia.ContractAllocationNumber == contractAllocationNumber);
                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // add
                context.InactiveAllocations.Add(inactiveAllocation);
                context.SaveChanges();

                // change reason value
                context.Database.ExecuteSqlCommand(
                    "UPDATE[MonitoringDeliverables].[InactiveAllocation] SET reason = 5 " +
                    " WHERE[ContractAllocationNumber] = @ContractAllocationNumber"
                    , new SqlParameter("@ContractAllocationNumber", contractAllocationNumber));
            }


            using (var context = new MonitoringDeliverablesDbContext())
            {
                var inactiveAllocationRepository = new InactiveAllocationRepository(context);
                // Act
                inactiveAllocationRepository.AddOrUpdate(inactiveAllocation, ConnectionInfo.CreateDefault());
                inactiveAllocationRepository.SaveChanges();

                // Assert
                List<InactiveAllocation> inactiveAllocationsToAssert = context.InactiveAllocations
                    .Where(ac => ac.ContractAllocationNumber == contractAllocationNumber).ToList();

                Assert.AreEqual(1, inactiveAllocationsToAssert.Count, "One Contract Allocation record should have been returned");
                Assert.AreEqual(contractAllocationNumber, inactiveAllocationsToAssert[0].ContractAllocationNumber, "Incorrect Contract Allocation Number returned");
                Assert.AreEqual(inactiveReason, inactiveAllocationsToAssert[0].Reason, "Incorrect inactive reason returned");
            }
        }
    }
}
