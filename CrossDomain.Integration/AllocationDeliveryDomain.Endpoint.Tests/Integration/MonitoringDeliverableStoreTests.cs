namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.NullObjects;
    using UnitTests.Common;

    [TestClass]
    public class MonitoringDeliverableStoreTests
    {
        private const string TestContractAllocationNumber = "SOME NUMBER";

        [TestCleanup, TestInitialize]
        public void CleanUp()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.ExecuteSqlCommand(
                    $"Delete from [MonitoringDeliverables].[AllocationDeliverablePeriod]" +
                    $"where [ContractAllocationNumber] = '{TestContractAllocationNumber}'");
            }

            ClearOverrideDate();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_ShouldUpdateESFAllocationIfESFAllocationPresent()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                // arrange
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());
                const string contractNumber = "SOME NUMBER";

                contractAllocationsContractAllocation contractAllocation = CreateContractAllocation("123");
                var existingESFAlloctaion = context.ESFAllocationData.Find(contractNumber,
                    contractAllocation.contractAllocationNumber);
                if (existingESFAlloctaion != null)
                {
                    context.ESFAllocationData.Remove(existingESFAlloctaion);
                    context.SaveChanges();
                }

                repository.StoreESFAllocation(contractAllocation, contractNumber, ConnectionInfo.CreateFrom(context.Database.Connection));

                const string tenderSpecificationReference = "1234";
                contractAllocation.tenderSpecificationReference = tenderSpecificationReference;

                // act
                repository.StoreESFAllocation(contractAllocation, contractNumber, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                EsfAllocationData esfAllocationData = repository.FindEsfAllocation(contractAllocation.contractAllocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));
                Assert.AreEqual(tenderSpecificationReference, esfAllocationData.TenderSpecReference);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_ShouldGetAllocationDeliverablePeriodsForAllocationAndPeriodList()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                // arrange
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());
                IList<string> periodList = new[] { "201608", "201609" };
                IList<int> deliverableList = new[] { 1, 2, 3, 4 };
                periodList.ForEach(period => deliverableList.ForEach(deliverableCode => context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    ContractAllocationNumber = TestContractAllocationNumber,
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                })));

                context.SaveChanges();

                // act
                IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods = repository.GetAllocationDeliverablePeriodsForAllocationAndPeriodList(TestContractAllocationNumber, periodList,
                    ConnectionInfo.CreateFrom(context.Database.Connection)).ToList();

                // assert
                foreach (var period in periodList)
                {
                    Assert.AreEqual(deliverableList.Count * periodList.Count, allocationDeliverablePeriods.Count(), $"The period {period} has failed");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_ShouldGetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                // Arrange
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());
                IList<string> periodList = new[] { "201608", "201609", "201610", "201611", "201612" };
                IList<int> deliverableList = new[] { 1, 2, 3, 4 };
                periodList.ForEach(period => deliverableList.ForEach(deliverableCode => context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    ContractAllocationNumber = TestContractAllocationNumber,
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                })));

                context.SaveChanges();

                string currentPeriod = "201610";

                IList<string> expectedReturnedPeriods = periodList.TakeUntil(p => p == currentPeriod).ToList();

                // Act
                IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods =
                    repository.GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(
                        TestContractAllocationNumber,
                        currentPeriod,
                        ConnectionInfo.CreateFrom(context.Database.Connection)).ToList();

                // Assert
                Assert.AreEqual(expectedReturnedPeriods.Count * deliverableList.Count, allocationDeliverablePeriods.Count(), "MonitoringDeliverableStore returned the wrong amount of allocation deliverable periods");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_ShouldGetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocationWhenCurrentPeriodInFuture()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                // Arrange
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());
                IList<string> periodList = new[] { "201608", "201609", "201610", "201611" };
                IList<int> deliverableList = new[] { 1, 2, 3, 4 };
                periodList.ForEach(period => deliverableList.ForEach(deliverableCode => context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    ContractAllocationNumber = TestContractAllocationNumber,
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                })));

                context.SaveChanges();

                string currentPeriod = "201612";

                // Act
                IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods =
                    repository.GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(
                        TestContractAllocationNumber,
                        currentPeriod,
                        ConnectionInfo.CreateFrom(context.Database.Connection)).ToList();

                // Assert
                Assert.AreEqual(periodList.Count * deliverableList.Count, allocationDeliverablePeriods.Count(), "MonitoringDeliverableStore returned the wrong amount of allocation deliverable periods");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_ShouldGetCurrentViewActualsForAllocations()
        {
            IReadOnlyCollection<string> contractAllocationNumbers = new List<string> { "Test_CA1", "Test_CA2" };

            // arrange
            RemoveCurrentViewActualsForTheseContractAllocationNumbers(contractAllocationNumbers);
            RemoveCurrentViewActualsForTheseContractAllocationNumbers(new List<string> { "Test_No" });

            using (var context = new MonitoringDeliverablesDbContext())
            {
                contractAllocationNumbers.ForEach(ca => context.CurrentViewActuals.Add(CreateCurrentViewActualForAllocation(ca)));

                context.CurrentViewActuals.Add(CreateCurrentViewActualForAllocation("Test_No"));

                context.SaveChanges();
            }

            IReadOnlyCollection<CurrentViewActual> currentViewActuals = null;
            using (var context = new MonitoringDeliverablesDbContext())
            {
                
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());

                // act
                currentViewActuals = repository.GetCurrentViewActualsForAllocations(contractAllocationNumbers, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // Assert
            Assert.AreEqual(2, currentViewActuals.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_GetEsfAllocationData_ShouldReturnAllEsfAllocationDataRecordsForProvidedList()
        {
            const string contractNumber1 = "CONTRACTNUMBER 1";
            const string contractAllocationNumber11 = "ALLOCNUMBER 1_1";

            const string contractNumber2 = "CONTRACTNUMBER 2";
            const string contractAllocationNumber21 = "ALLOCNUMBER 2_1";

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // arrange
                // clear down ESFAllocations
                contractAllocationsContractAllocation contractAllocation11 = CreateContractAllocation(contractAllocationNumber11);
                var existingEsfAlloctaion11 = context.ESFAllocationData.Find(contractNumber1, contractAllocation11.contractAllocationNumber);
                if (existingEsfAlloctaion11 != null)
                {
                    context.ESFAllocationData.Remove(existingEsfAlloctaion11);
                }

                contractAllocationsContractAllocation contractAllocation21 = CreateContractAllocation(contractAllocationNumber21);
                var existingEsfAlloctaion21 = context.ESFAllocationData.Find(contractNumber2, contractAllocation21.contractAllocationNumber);
                if (existingEsfAlloctaion21 != null)
                {
                    context.ESFAllocationData.Remove(existingEsfAlloctaion21);
                }
                context.SaveChanges();

                // create ESFAllocations
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());
                repository.StoreESFAllocation(contractAllocation11, contractNumber1, ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.StoreESFAllocation(contractAllocation21, contractNumber2, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                List<string> allocationNumbers = new List<string> { contractAllocationNumber11, contractAllocationNumber21 };
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());

                // act
                IReadOnlyCollection<EsfAllocationData> esfAllocationDatas = repository.GetEsfAllocationData(allocationNumbers, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(esfAllocationDatas.Count, 2, "Incorrect number of EsfAllocationData items returned");
                Assert.IsTrue(esfAllocationDatas.Any(str => str.ContractAllocationNumber.Contains(contractAllocationNumber11)), $"ContractAllocationNumber '{contractAllocationNumber11}' not in returned collection");
                Assert.IsTrue(esfAllocationDatas.Any(str => str.ContractAllocationNumber.Contains(contractAllocationNumber21)), $"ContractAllocationNumber '{contractAllocationNumber21}' not in returned collection");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_GetEsfAllocationData_ShouldReturnSomeEsfAllocationDataRecordForProvidedList()
        {
            const string contractNumber1 = "CONTRACTNUMBER 1";
            const string contractAllocationNumber11 = "ALLOCNUMBER 1_1";

            const string contractNumber2 = "CONTRACTNUMBER 2";
            const string contractAllocationNumber21 = "ALLOCNUMBER 2_1";

            const string contractAllocationNumberNotExists = "ALLOCNUMBER NOT EXISTS";

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // arrange
                // clear down ESFAllocations
                contractAllocationsContractAllocation contractAllocation11 = CreateContractAllocation(contractAllocationNumber11);
                var existingEsfAlloctaion11 = context.ESFAllocationData.Find(contractNumber1, contractAllocation11.contractAllocationNumber);
                if (existingEsfAlloctaion11 != null)
                {
                    context.ESFAllocationData.Remove(existingEsfAlloctaion11);
                }

                contractAllocationsContractAllocation contractAllocation21 = CreateContractAllocation(contractAllocationNumber21);
                var existingEsfAlloctaion21 = context.ESFAllocationData.Find(contractNumber2, contractAllocation21.contractAllocationNumber);
                if (existingEsfAlloctaion21 != null)
                {
                    context.ESFAllocationData.Remove(existingEsfAlloctaion21);
                }
                context.SaveChanges();

                // create ESFAllocations
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());
                repository.StoreESFAllocation(contractAllocation11, contractNumber1, ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.StoreESFAllocation(contractAllocation21, contractNumber2, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                List<string> allocationNumbers = new List<string> { contractAllocationNumber11, contractAllocationNumberNotExists };
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());

                // act
                IReadOnlyCollection<EsfAllocationData> esfAllocationDatas = repository.GetEsfAllocationData(allocationNumbers, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(esfAllocationDatas.Count, 1, "Incorrect number of EsfAllocationData items returned");
                Assert.IsTrue(esfAllocationDatas.Any(str => str.ContractAllocationNumber.Contains(contractAllocationNumber11)), $"ContractAllocationNumber '{contractAllocationNumber11}' not in returned collection");
                Assert.IsFalse(esfAllocationDatas.Any(str => str.ContractAllocationNumber.Contains(contractAllocationNumber21)), $"ContractAllocationNumber '{contractAllocationNumber21}' incorrectly returned in collection");
                Assert.IsFalse(esfAllocationDatas.Any(str => str.ContractAllocationNumber.Contains(contractAllocationNumberNotExists)), $"ContractAllocationNumber '{contractAllocationNumberNotExists}' incorrectly returned in collection");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_GetEsfAllocationData_ShouldReturnNoEsfAllocationDataForProvidedList()
        {
            const string contractNumber1 = "CONTRACTNUMBER 1";
            const string contractAllocationNumber11 = "ALLOCNUMBER 1_1";

            const string contractNumber2 = "CONTRACTNUMBER 2";
            const string contractAllocationNumber21 = "ALLOCNUMBER 2_1";

            const string contractAllocationNumberNotExists = "ALLOCNUMBER NOT EXISTS";

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // arrange
                // clear down ESFAllocations
                contractAllocationsContractAllocation contractAllocation11 = CreateContractAllocation(contractAllocationNumber11);
                var existingEsfAlloctaion11 = context.ESFAllocationData.Find(contractNumber1, contractAllocation11.contractAllocationNumber);
                if (existingEsfAlloctaion11 != null)
                {
                    context.ESFAllocationData.Remove(existingEsfAlloctaion11);
                }

                contractAllocationsContractAllocation contractAllocation21 = CreateContractAllocation(contractAllocationNumber21);
                var existingEsfAlloctaion21 = context.ESFAllocationData.Find(contractNumber2, contractAllocation21.contractAllocationNumber);
                if (existingEsfAlloctaion21 != null)
                {
                    context.ESFAllocationData.Remove(existingEsfAlloctaion21);
                }
                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                List<string> allocationNumbers = new List<string> { contractAllocationNumber11, contractAllocationNumber21, contractAllocationNumberNotExists };
                IMonitoringDeliverableStore repository = new MonitoringDeliverableStore(new SimpleConsoleLogger());

                // act
                IReadOnlyCollection<EsfAllocationData> esfAllocationDatas = repository.GetEsfAllocationData(allocationNumbers, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(esfAllocationDatas.Count, 0, "Incorrect number of EsfAllocationData items returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_GetActiveAllocationDeliverablePeriods_ShouldNotRetrieveAllocationsThatAreInactive()
        {
            // arrange
            const string contractNumber1 = "CONTRACTNUMBER 1";
            const string contractAllocationNumber11 = "ALLOCNUMBER 1_1";

            IList<string> periodList = new[] { "201608", "201609", "201610", "201611" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };

            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods
                    .RemoveWhere(adp => adp.ContractAllocationNumber == contractAllocationNumber11);

                context.InactiveAllocations
                    .RemoveWhere(ia => ia.ContractAllocationNumber == contractAllocationNumber11);

                context.SaveChanges();

                periodList.ForEach(period => deliverableList.ForEach(deliverableCode => context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    ContractAllocationNumber = contractAllocationNumber11,
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = contractNumber1,
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now.AddYears(1)
                })));

                context.InactiveAllocations.Add(new InactiveAllocation(contractAllocationNumber11, InactiveReason.Closed));

                context.SaveChanges();
            }

            // act
            using (var context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                IReadOnlyCollection<AllocationDeliverablePeriod> allocationDeliverablePeriods =
                    monitoringDeliverableStore.GetActiveAllocationDeliverablePeriods(new List<string> { contractAllocationNumber11 }, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(0, allocationDeliverablePeriods.Count, "ADPs should not have been returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_GetAllocationDeliverablePeriodsWithOrgId_ShouldNotRetrieveAllocationsThatAreInactive()
        {
            // arrange
            const string contractNumber1 = "CONTRACTNUMBER 1";
            const string contractAllocationNumber11 = "ALLOCNUMBER 1_1";
            const string fspCode = "T1213";
            const string uopCode = "TESTUOP";
            const string orgId = "ORG010101";

            IList<string> periodList = new[] { "201608", "201609", "201610", "201611" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };

            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods
                    .RemoveWhere(adp => adp.ContractAllocationNumber == contractAllocationNumber11);

                context.InactiveAllocations
                    .RemoveWhere(ia => ia.ContractAllocationNumber == contractAllocationNumber11);

                context.SaveChanges();

                periodList.ForEach(period => deliverableList.ForEach(deliverableCode => context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    ContractAllocationNumber = contractAllocationNumber11,
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = orgId,
                    FundingStreamPeriodCode = fspCode,
                    UopCode = uopCode,
                    ContractNumber = contractNumber1,
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now.AddYears(1),
                })));

                context.InactiveAllocations.Add(new InactiveAllocation(contractAllocationNumber11, InactiveReason.Closed));

                context.SaveChanges();
            }

            // act
            using (var context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                IReadOnlyCollection<AllocationDeliverablePeriod> allocationDeliverablePeriods =
                    monitoringDeliverableStore.GetActiveAllocationDeliverablePeriods(orgId, fspCode, uopCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(0, allocationDeliverablePeriods.Count, "ADPs should not have been returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_FspDeliverableExists_ShouldReturnTrueForIsAllowedToBeAddedIsTrue()
        {
            //arrange 
            const string testfundingStreamPeriodCode = "TestFspPeriodCode";
            const int testDeliverableCode = 1;
            const string testDeliverableName = "testDeliverableName";

            var testFundingStreamPeriodDeliverable = new FundingStreamPeriodDeliverable
            {
                FundingStreamPeriodCode = testfundingStreamPeriodCode,
                DeliverableCode = testDeliverableCode,
                DeliverableName = testDeliverableName,
                IsAllowedToBeAdded = true
            };

            RemoveFspDeliverable(testfundingStreamPeriodCode, testDeliverableCode);
            AddFspDeliverable(testFundingStreamPeriodDeliverable);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                // act
                bool doesFspDeliverableExist = monitoringDeliverableStore.DoesFspDeliverableExist(testfundingStreamPeriodCode, testDeliverableCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(true, doesFspDeliverableExist, "DoesFspDeliverableExist response is not true");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_FspDeliverableExists_ShouldReturnFalseForIsAllowedToBeAddedIsFalse()
        {
            //arrange 
            const string testfundingStreamPeriodCode = "TestFspPeriodCode";
            const int testDeliverableCode = 1;
            const string testDeliverableName = "testDeliverableName";

            var testFundingStreamPeriodDeliverable = new FundingStreamPeriodDeliverable
            {
                FundingStreamPeriodCode = testfundingStreamPeriodCode,
                DeliverableCode = testDeliverableCode,
                DeliverableName = testDeliverableName,
                IsAllowedToBeAdded = false
            };

            RemoveFspDeliverable(testfundingStreamPeriodCode, testDeliverableCode);
            AddFspDeliverable(testFundingStreamPeriodDeliverable);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                // act
                bool doesFspDeliverableExist = monitoringDeliverableStore.DoesFspDeliverableExist(testfundingStreamPeriodCode, testDeliverableCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(false, doesFspDeliverableExist, "DoesFspDeliverableExist response is not false");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_FspDeliverableExists_ShouldReturnFalseForFspDeliverableRecordNotExisting()
        {
            //arrange 
            const string testfundingStreamPeriodCode = "TestFspPeriodCode";
            const int testDeliverableCode = 1;

            RemoveFspDeliverable(testfundingStreamPeriodCode, testDeliverableCode);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                // act
                bool doesFspDeliverableExist = monitoringDeliverableStore.DoesFspDeliverableExist(testfundingStreamPeriodCode, testDeliverableCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(false, doesFspDeliverableExist, "DoesFspDeliverableExist response is not false");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_AddAllocationDeliverablePeriods_ShouldAddRecords()
        {           
            // arrange
            const string testOrganisationId = "testOrgId";
            const string testFundingStreamPeriodCode = "testFundingStreamPeriodCode";
            const string testUopCode = "testUopCode";
            const int testDeliverableCode = 1;
            const string testPeriod = "tstPd";
            const string testPeriod2 = "tstPd2";
            const string testContractAllocationNumber = "testAllocationNumber";
            const string testContractNumber = "testContractNumber";
            const int testContractVersionNumber = 888;
            const int testContractSubVersionNumber = 999;
            DateTime testAllocationStartDate = DateTime.Today;
            DateTime testAllocationEndDate = DateTime.Now.AddDays(2);
            const string testUkprn = "tstUkprn";


            var testAllocationDeliverablePeriod1 = new AllocationDeliverablePeriod
            {
                OrganisationId = testOrganisationId,
                FundingStreamPeriodCode = testFundingStreamPeriodCode,
                UopCode = testUopCode,
                DeliverableCode = testDeliverableCode,
                Period = testPeriod,
                ContractAllocationNumber = testContractAllocationNumber,
                ContractNumber = testContractNumber,
                ContractVersionNumber = testContractVersionNumber,
                ContractSubVersionNumber = testContractSubVersionNumber,
                AllocationStartDate = testAllocationStartDate,
                AllocationEndDate = testAllocationEndDate,
                Ukprn = testUkprn
            };

            var testAllocationDeliverablePeriod2 = new AllocationDeliverablePeriod
            {
                OrganisationId = testOrganisationId,
                FundingStreamPeriodCode = testFundingStreamPeriodCode,
                UopCode = testUopCode,
                DeliverableCode = testDeliverableCode,
                Period = testPeriod2,
                ContractAllocationNumber = testContractAllocationNumber,
                ContractNumber = testContractNumber,
                ContractVersionNumber = testContractVersionNumber,
                ContractSubVersionNumber = testContractSubVersionNumber,
                AllocationStartDate = testAllocationStartDate,
                AllocationEndDate = testAllocationEndDate,
                Ukprn = testUkprn
            };

            var allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>
                { testAllocationDeliverablePeriod1, testAllocationDeliverablePeriod2 };

            RemoveAllocationDeliverablePeriod(testAllocationDeliverablePeriod1);
            RemoveAllocationDeliverablePeriod(testAllocationDeliverablePeriod2);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                // act
                monitoringDeliverableStore.AddAllocationDeliverablePeriods(allocationDeliverablePeriods, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var allocationDeliverablePeriod = context.AllocationDeliverablePeriods.Where(adp =>
                           adp.ContractAllocationNumber == testContractAllocationNumber
                        && adp.DeliverableCode == testDeliverableCode
                        && (adp.Period == testPeriod || adp.Period == testPeriod2));

                Assert.AreEqual(2, allocationDeliverablePeriod.Count(), "AllocationDeliverablePeriods were not added");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverableStore_AddAllocationDeliverablePeriods_ShouldErrorForDuplicateUniqueIndexRecord()
        {
            // arrange
            const string testOrganisationId = "testOrgId";
            const string testFundingStreamPeriodCode = "testFundingStreamPeriodCode";
            const string testUopCode = "testUopCode";
            const int testDeliverableCode = 1;
            const string testPeriod = "testPd";
            const string testContractAllocationNumber = "testAllocationNumber";
            const string testContractNumber = "testContractNumber";
            const int testContractVersionNumber = 888;
            const int testContractSubVersionNumber = 999;
            DateTime testAllocationStartDate = DateTime.Today;
            DateTime testAllocationEndDate = DateTime.Now.AddDays(2);
            const string testUkprn = "tstUkprn";

            var testAllocationDeliverablePeriod = new AllocationDeliverablePeriod
            {
                OrganisationId = testOrganisationId,
                FundingStreamPeriodCode = testFundingStreamPeriodCode,
                UopCode = testUopCode,
                DeliverableCode = testDeliverableCode,
                Period = testPeriod,
                ContractAllocationNumber = testContractAllocationNumber,
                ContractNumber = testContractNumber,
                ContractVersionNumber = testContractVersionNumber,
                ContractSubVersionNumber = testContractSubVersionNumber,
                AllocationStartDate = testAllocationStartDate,
                AllocationEndDate = testAllocationEndDate,
                Ukprn = testUkprn
            };

            RemoveAllocationDeliverablePeriod(testAllocationDeliverablePeriod);
            AddAllocationDeliverablePeriod(testAllocationDeliverablePeriod);

            var allocationDeliverablePeriods = new List<AllocationDeliverablePeriod> { testAllocationDeliverablePeriod };

            using (var context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore =
                    new MonitoringDeliverableStore(new LoggerNullObject());

                // act & assert (duplicate insert should violate unique index and throw)
                Assert.ThrowsExactly<DbUpdateException>(() =>
                {
                    monitoringDeliverableStore.AddAllocationDeliverablePeriods(
                        allocationDeliverablePeriods,
                        ConnectionInfo.CreateFrom(context.Database.Connection));
                });
            }
        }


        private CurrentViewActual CreateCurrentViewActualForAllocation(string contractAllocationNumber)
        {
            return new CurrentViewActual
            {
                ContractVersion = 1,
                ContractSubVersion = 1,
                AllocationStartDate = DateTime.Now,
                AllocationEndDate = DateTime.Now,
                OrganisationId = "V",
                Period = "201706",
                FundingStreamPeriodCode = "FSP",
                ContractAllocationNumber = contractAllocationNumber,
                UoPCode = "0",
                DeliverableCode = 1,
                ActualVolume = 1,
                ActualValue = 1
            };
        }

        private static void RemoveCurrentViewActualsForTheseContractAllocationNumbers(IEnumerable<string> contractAllocationNumbers)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var currentViewActuals = context.CurrentViewActuals.Where(cva => contractAllocationNumbers.Contains(cva.ContractAllocationNumber));

                currentViewActuals.ForEach(cva => context.CurrentViewActuals.Remove(cva));
                context.SaveChanges();
            }
        }

        private static contractAllocationsContractAllocation CreateContractAllocation(string contractAllocationNumber)
        {
            return new contractAllocationsContractAllocation
            {
                LEPCode = "LEPCode",
                LEPName = "LEPName",
                tenderSpecificationReference = "123",
                lotReference = "lotReference",
                tenderAwardReference = "tenderAwardRef",
                ActivityDescription = "ActivityDescription",
                InvestmentPriority = "InvestmentPriority",
                AgreementNumber = "AgreementNumber",
                SpecificationTitle = "SpecificationTitle",
                RegionType = "RegionType",
                LearningRatePremium = "12.3", // ""
                description = "description",
                contractAllocationNumber = contractAllocationNumber,

                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                {
                    new contractDeliverablesTypeContractDeliverable
                    {
                        unitCost = 97m,
                        plannedVolume = 100
                        //plannedValue = 200m

                        //deliverableOrganisationRelationships = new List<organisationRelationship>
                        //{
                        //    new organisationRelationship
                        //    {
                        //        organisationRelationshipType = organisationRelationshipType.FUNDINGORGANISATION,
                        //        organisationIdentifier = 10000
                        //    }
                        //}
                    }
                }

            };
        }
        
        private void ClearOverrideDate()
        {
            using (var context = new OverrideDateDBContext())
            {
                context.OverrideDate.ForEach(od => context.OverrideDate.Remove(od));
                context.SaveChanges();
            }
        }

        private static void RemoveFspDeliverable(string fundingStreamPeriodCode, int deliverableCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var fspd = context.FundingStreamPeriodDeliverables.Find(fundingStreamPeriodCode, deliverableCode);
                if (fspd != null)
                {
                    context.FundingStreamPeriodDeliverables.Remove(fspd);
                    context.SaveChanges();
                }
            }
        }

        private static void AddFspDeliverable(FundingStreamPeriodDeliverable fundingStreamPeriodDeliverable)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.FundingStreamPeriodDeliverables.Add(fundingStreamPeriodDeliverable);
                context.SaveChanges();
            }
        }

        private static void RemoveAllocationDeliverablePeriod(AllocationDeliverablePeriod allocationDeliverablePeriod)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var adperiod = context.AllocationDeliverablePeriods.SingleOrDefault(adp =>
                    adp.ContractAllocationNumber == allocationDeliverablePeriod.ContractAllocationNumber
                    && adp.DeliverableCode == allocationDeliverablePeriod.DeliverableCode
                    && adp.Period == allocationDeliverablePeriod.Period);

                if (adperiod != null)
                {
                    context.AllocationDeliverablePeriods.Remove(adperiod);
                    context.SaveChanges();
                }
            }
        }

        private static void AddAllocationDeliverablePeriod(AllocationDeliverablePeriod allocationDeliverablePeriod)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods.Add(allocationDeliverablePeriod);
                context.SaveChanges();
            }
        }
    }
}
