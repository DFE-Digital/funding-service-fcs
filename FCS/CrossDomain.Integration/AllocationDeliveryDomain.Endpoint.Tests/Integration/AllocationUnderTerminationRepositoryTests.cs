namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Core.Internal;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class AllocationUnderTerminationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationUnderTerminationRepository_AddRange_ShouldAddCorrectRangeOfAllocationUnderTerminations()
        {
            // arrange
            const string contractNumber = "CONT-1234";
            List<string> allocationNumbers = new List<string> { "TEST Alloc 1", "TEST Alloc 2" };
            DateTime now = DateTime.Now;
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationsUnderTermination.Where(a => allocationNumbers.Contains(a.ContractAllocationNumber)).ToList()
                    .ForEach(a => context.AllocationsUnderTermination.Remove(a));

                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // act
                new AllocationUnderTerminationRepository().AddRange(allocationNumbers.Select(a => new AllocationUnderTermination(contractNumber, a, now)).ToList(),
                        new ConnectionInfo(null, context.Database.Connection))
                    .Wait();
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                int countInDb = context.AllocationsUnderTermination.Count(aut => allocationNumbers.Contains(aut.ContractAllocationNumber));

                Assert.AreEqual(allocationNumbers.Count, countInDb);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationUnderTerminationRepository_RemoveAllocationUnderTerminationsForContract_ShouldRemoveAllocationUnderTerminationsAssociatedToContractNumber()
        {
            // arrange
            const string testContractNumber = "TEST-1234";
            const string randomAContractNumber = "RAND-1234";
            List<string> testAllocationNumbers = new List<string> { "TEST Alloc 1", "TEST Alloc 2" };
            List<string> randomAllocationNumbers = new List<string> { "RAND Alloc 1", "RAND Alloc 2" };
            DateTime now = DateTime.Now;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationsUnderTermination.Where(a => testAllocationNumbers.Contains(a.ContractAllocationNumber)).ToList()
                    .ForEach(a => context.AllocationsUnderTermination.Remove(a));

                context.AllocationsUnderTermination.Where(a => randomAllocationNumbers.Contains(a.ContractAllocationNumber)).ToList()
                    .ForEach(a => context.AllocationsUnderTermination.Remove(a));

                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var testAllocationUnderTerminations = testAllocationNumbers.Select(a => new AllocationUnderTermination(testContractNumber, a, now)).ToList();
                context.AllocationsUnderTermination.AddRange(testAllocationUnderTerminations);

                var randomAllocationUnderTerminations = randomAllocationNumbers.Select(a => new AllocationUnderTermination(randomAContractNumber, a, now)).ToList();
                context.AllocationsUnderTermination.AddRange(randomAllocationUnderTerminations);

                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // act
                new AllocationUnderTerminationRepository().RemoveAllocationUnderTerminationsForContract(testContractNumber,
                        new ConnectionInfo(null, context.Database.Connection))
                    .Wait();
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var countOfRecordsForTestAllocationNumbers = context.AllocationsUnderTermination.Count(aut => testAllocationNumbers.Contains(aut.ContractAllocationNumber));
                Assert.AreEqual(0, countOfRecordsForTestAllocationNumbers, "The incorrect number of AllocationUnderTermination records, for allocation number, were removed");

                var countOfRecordsForTestContractNumber = context.AllocationsUnderTermination.Count(cn => cn.ContractNumber == testContractNumber);
                Assert.AreEqual(0, countOfRecordsForTestContractNumber, "The incorrect number of AllocationUnderTermination, for contract number, records were removed");

                var countOfRecordsForRandomAllocationNumbers = context.AllocationsUnderTermination.Count(aut => randomAllocationNumbers.Contains(aut.ContractAllocationNumber));
                Assert.AreEqual(2, countOfRecordsForRandomAllocationNumbers, "AllocationUnderTermination records that should have remained on database, for allocation number, were removed");

                var countOfRecordsForRandomContractNumber = context.AllocationsUnderTermination.Count(cn => cn.ContractNumber == randomAContractNumber);
                Assert.AreEqual(2, countOfRecordsForRandomContractNumber, "AllocationUnderTermination records that should have remained on database, for contract number, were removed");
            }
        }
    }
}
