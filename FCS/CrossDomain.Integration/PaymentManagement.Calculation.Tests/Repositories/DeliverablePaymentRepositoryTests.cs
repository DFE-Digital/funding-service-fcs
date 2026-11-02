namespace PaymentManagement.Calculation.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using Allocation = SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    [TestClass]
    public class DeliverablePaymentRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetDeliverablePeriodPaymentInfos_ShouldReturnDeliverablePeriodPaymentInfos()
        {
            // arrange
            const string allocationNumber = "AllocNo_DeliverablePeriodPaymentInfo";
            const int versionNumber = 99;
            
            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);
            
            CreateDeliverablePayment(allocationNumber, versionNumber, "202001", 1, 66.66m, 60m, -6, 6);
            CreateDeliverablePayment(allocationNumber, versionNumber, "202002", 1, 77.77m, 70m, -7, 7);
            CreateDeliverablePayment(allocationNumber, versionNumber, "202003", 1, 88.88m, 80m, -8, 8);
            CreateDeliverablePayment(allocationNumber, versionNumber, "202004", 1, 99.99m, 90m, -9, 9); 

            using (var context = new PaymentSchedulePolicyContext())
            {
                var repository = new DeliverablePaymentRepository();

                // act
                var assertDeliverablePeriodPaymentInfos = repository.GetDeliverablePeriodPaymentInfos(allocationNumber, versionNumber,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert 
                Assert.AreEqual(4, assertDeliverablePeriodPaymentInfos.Count, "Incorrect number of CensusPeriodInfos returned");

                var assertDeliverablePeriodPaymentInfo = assertDeliverablePeriodPaymentInfos
                    .SingleOrDefault(ddpi =>
                        ddpi.Period == 202001 &&
                        ddpi.DeliverableCode == 1 &&
                        ddpi.NetPaymentAmount == 66.66m &&
                        ddpi.PlannedValue == 60m &&
                        ddpi.CappedPaymentAmount == -6m &&
                        ddpi.ReconciliationPaymentAmount == 6m);

                Assert.IsNotNull(assertDeliverablePeriodPaymentInfo, "Expected deliverablePeriodPaymentInfo was not returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_AddOrUpdateDeliverablePaymentsWithActualValues_ShouldAddAndUpdateDeliverablePeriods()
        {
            // arrange
            const string allocationNumber = "AllocNo_UpsertDeliverablePayment";
            const int versionNumber = 99;

            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);

            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202002", 10, 22.22m, 2);
            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202003", 10, 33.33m, 3);
            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202004", 10, 44.44m, 4);
            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202005", 10, 55.55m, 5);

            var contractAllocationActualsType = new ContractAllocationActualsType();

            contractAllocationActualsType.ContractAllocationNumber = allocationNumber;
            contractAllocationActualsType.ContractReference.ContractVersionNumber = versionNumber;
            contractAllocationActualsType.ActualsSummary = new List<ActualsSummaryType>
            {
                new ActualsSummaryType {DeliverableCode = 10, Period = "202003", ActualValue = 1000003.03m, ActualVolume = 1100003},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202004", ActualValue = 1000004.04m, ActualVolume = 1100003},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202005", ActualValue = 1000005.05m, ActualVolume = 1100004},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202006", ActualValue = 1000006.06m, ActualVolume = 1100006},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202007", ActualValue = 1000007.07m, ActualVolume = 1100007},

                new ActualsSummaryType {DeliverableCode = 22, Period = "202005", ActualValue = 2200005.05m, ActualVolume = 2200005},
                new ActualsSummaryType {DeliverableCode = 22, Period = "202006", ActualValue = 2200006.06m, ActualVolume = 2200006}
            };


            using (var context = new PaymentSchedulePolicyContext())
            {
                var repository = new DeliverablePaymentRepository();

                // act
                repository.AddOrUpdateDeliverablePaymentsWithActualValues(contractAllocationActualsType, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                var assertDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                // Assert
                Assert.AreEqual(8, assertDeliverablePayments.Count, "Incorrect number of delivery payment records in table");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202001" && adp.DeliverableCode == 10 && adp.ActualValue == 22.22m && 
                    adp.ActualVolume == 2), "DeliverablePayment was incorrectly updated");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202006" && adp.DeliverableCode == 22 && adp.ActualValue == 2200006.06m &&
                    adp.ActualVolume == 2200006), "DeliverablePayment was not added");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202007" && adp.DeliverableCode == 10 && adp.ActualValue == 1000007.07m &&
                    adp.ActualVolume == 1100007), "DeliverablePayment was not updated");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_AddOrUpdateDeliverablePaymentsWithActualValues_ShouldAddPeriodsWhenThereAreNoDeliverablePaymentRecords()
        {
            // arrange
            const string allocationNumber = "AllocNo_UpsertDeliverablePayment";
            const int versionNumber = 99;

            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);

            var contractAllocationActualsType = new ContractAllocationActualsType();

            contractAllocationActualsType.ContractAllocationNumber = allocationNumber;
            contractAllocationActualsType.ContractReference.ContractVersionNumber = versionNumber;
            contractAllocationActualsType.ActualsSummary = new List<ActualsSummaryType>
            {
                new ActualsSummaryType {DeliverableCode = 10, Period = "202003", ActualValue = 1000003.03m, ActualVolume = 1100003},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202004", ActualValue = 1000004.04m, ActualVolume = 1100003},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202005", ActualValue = 1000005.05m, ActualVolume = 1100004},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202006", ActualValue = 1000006.06m, ActualVolume = 1100006},
                new ActualsSummaryType {DeliverableCode = 10, Period = "202007", ActualValue = 1000007.07m, ActualVolume = 1100007},

                new ActualsSummaryType {DeliverableCode = 22, Period = "202005", ActualValue = 2200005.05m, ActualVolume = 2200005},
                new ActualsSummaryType {DeliverableCode = 22, Period = "202006", ActualValue = 2200006.06m, ActualVolume = 2200006}
            };
            
            using (var context = new PaymentSchedulePolicyContext())
            {
                var repository = new DeliverablePaymentRepository();

                // act
                repository.AddOrUpdateDeliverablePaymentsWithActualValues(contractAllocationActualsType, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                var assertDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                // Assert
                Assert.AreEqual(7, assertDeliverablePayments.Count, "Incorrect number of delivery payment records in table");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202006" && adp.DeliverableCode == 22 && adp.ActualValue == 2200006.06m &&
                    adp.ActualVolume == 2200006), "DeliverablePayment was not added");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202007" && adp.DeliverableCode == 10 && adp.ActualValue == 1000007.07m &&
                    adp.ActualVolume == 1100007), "DeliverablePayment was not updated");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_AddOrUpdateDeliverablePaymentsWithActualValues_ShouldDoNothingWhenThereAreNoActualSummaryPeriods()
        {
            // arrange
            const string allocationNumber = "AllocNo_UpsertDeliverablePayment";
            const int versionNumber = 99;

            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);

            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202002", 10, 22.22m, 2);

            var contractAllocationActualsType = new ContractAllocationActualsType();

            contractAllocationActualsType.ContractAllocationNumber = allocationNumber;
            contractAllocationActualsType.ContractReference.ContractVersionNumber = versionNumber;
            contractAllocationActualsType.ActualsSummary = new List<ActualsSummaryType>();

            using (var context = new PaymentSchedulePolicyContext())
            {
                var repository = new DeliverablePaymentRepository();

                // act
                repository.AddOrUpdateDeliverablePaymentsWithActualValues(contractAllocationActualsType, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                var assertDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                // Assert
                Assert.AreEqual(1, assertDeliverablePayments.Count, "Incorrect number of delivery payment records in table");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202001" && adp.DeliverableCode == 10 && adp.ActualValue == 22.22m &&
                    adp.ActualVolume == 2), "DeliverablePayment was incorrectly updated");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_AddOrUpdateDeliverablePaymentsWithCalculatedValues_ShouldUpdateCalculatedValues()
        {
            // arrange
            ClearDownDeliverablePaymentsForAllocationNumberAndVersion("TEST-1234", 1);

            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = "TEST-1234",
                    VersionNumber = 1,
                    DeliverableCode = 1,
                    Period = "202001",
                    ProfilePaymentAmount = null,
                    CappedPaymentAmount = null,
                    BalancingPaymentAmount = null,
                    ReconciliationPaymentAmount = null,
                    NetPaymentAmount = 0
                });
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = "TEST-1234",
                    VersionNumber = 1,
                    DeliverableCode = 1,
                    Period = "202002",
                    ProfilePaymentAmount = null,
                    CappedPaymentAmount = null,
                    BalancingPaymentAmount = null,
                    ReconciliationPaymentAmount = null,
                    NetPaymentAmount = 0
                });
                context.SaveChanges();
            }

            DeliverablePaymentRepository repository = new DeliverablePaymentRepository();

            AllocationDeliverable allocationDeliverable = new AllocationDeliverable
            {
                DeliverableCode = 1,
                ScheduledPayments = new List<ScheduledPayment>
                {
                    new ScheduledPayment
                    {
                        Period = "202001",
                        ProfilePaymentAmount = 1,
                        CappedPaymentAmount = 2,
                        BalancingPaymentAmount = 3,
                        ReconciliationPaymentAmount = 4,
                        NetPaymentAmount = 5
                    },
                    new ScheduledPayment
                    {
                        Period = "202002",
                        ProfilePaymentAmount = 1,
                        CappedPaymentAmount = 2,
                        BalancingPaymentAmount = 3,
                        ReconciliationPaymentAmount = 4,
                        NetPaymentAmount = 5
                    }
                }
            };

            // act
            repository.AddOrUpdateDeliverablePaymentsWithCalculatedValues("TEST-1234", 1, allocationDeliverable,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                List<DeliverablePayment> storedDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == "TEST-1234" && dp.VersionNumber == 1 && dp.DeliverableCode == 1)
                    .ToList();

                Assert.AreEqual(2, storedDeliverablePayments.Count, "Unexpected number of deliverable payments stored");

                DeliverablePayment sampleStoredDeliverablePeriod = storedDeliverablePayments.SingleOrDefault(dp => dp.Period == "202001");
                Assert.IsNotNull(sampleStoredDeliverablePeriod, "Expected period not stored");
                Assert.AreEqual(1, sampleStoredDeliverablePeriod.ProfilePaymentAmount, "Incorrect ProfilePaymentAmount stored");
                Assert.AreEqual(2, sampleStoredDeliverablePeriod.CappedPaymentAmount, "Incorrect CappedPaymentAmount stored");
                Assert.AreEqual(3, sampleStoredDeliverablePeriod.BalancingPaymentAmount, "Incorrect BalancingPaymentAmount stored");
                Assert.AreEqual(4, sampleStoredDeliverablePeriod.ReconciliationPaymentAmount, "Incorrect ReconciliationPaymentAmount stored");
                Assert.AreEqual(5, sampleStoredDeliverablePeriod.NetPaymentAmount, "Incorrect NetPaymentAmount stored");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_PersistPaymentScheduleAndActuals__ShouldAddAndUpdateDeliverablePeriods()
        {
            // arrange
            const string allocationNumber = "AllocNo_PersistPaymentScheduleAndActuals";
            const int versionNumber = 99;

            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);

            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202002", 10, 0, 0);
            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202003", 10, 0, 0);

            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202002", 20, 0, 0);
            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, "202003", 20, 0, 0);

            var repository = new DeliverablePaymentRepository();

            var allocation = new Allocation
            {
                AllocationNumber = allocationNumber,
                VersionNumber = versionNumber,
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 10,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "202002", ReconciliationPaymentAmount = 2, CappedPaymentAmount = 2, BalancingPaymentAmount = 2, ProfilePaymentAmount = 2, NetPaymentAmount = 2, ActualVolume = 2, ActualValue = 2, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode2"},
                            new ScheduledPayment {Period = "202003", ReconciliationPaymentAmount = 3, CappedPaymentAmount = 3, BalancingPaymentAmount = 3, ProfilePaymentAmount = 3, NetPaymentAmount = 3, ActualVolume = 3, ActualValue = 3, PlannedValue = 3, PlannedVolume = 3, CollectionReturnCode = "CollRCode3"},
                            new ScheduledPayment {Period = "202004", ReconciliationPaymentAmount = 4, CappedPaymentAmount = 4, BalancingPaymentAmount = 4, ProfilePaymentAmount = 4, NetPaymentAmount = 4, ActualVolume = 4, ActualValue = 4, PlannedValue = 4, PlannedVolume = 4, CollectionReturnCode = "CollRCode4"},
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 20,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "202002", ReconciliationPaymentAmount = 22, CappedPaymentAmount = 22, BalancingPaymentAmount = 22, ProfilePaymentAmount = 22, NetPaymentAmount = 22, ActualVolume = 22, ActualValue = 22, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode2"},
                            new ScheduledPayment {Period = "202004", ReconciliationPaymentAmount = 24, CappedPaymentAmount = 24, BalancingPaymentAmount = 24, ProfilePaymentAmount = 24, NetPaymentAmount = 24, ActualVolume = 24, ActualValue = 24, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode4"},
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 30,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "202002", ReconciliationPaymentAmount = 32, CappedPaymentAmount = 32, BalancingPaymentAmount = 32, ProfilePaymentAmount = 32, NetPaymentAmount = 32, ActualVolume = 32, ActualValue = 32, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode2"},
                        }
                    },

                }
            };

            // act 
            repository.PersistPaymentScheduleAndActuals(allocation, ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var assertDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                // Assert
                Assert.AreEqual(7, assertDeliverablePayments.Count, "Incorrect number of delivery payment records in table");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202002" && adp.DeliverableCode == 10 && adp.ActualValue == 2 && adp.ActualVolume == 2 && adp.ReconciliationPaymentAmount == 2 &&
                    adp.CappedPaymentAmount == 2 && adp.BalancingPaymentAmount == 2 && adp.ProfilePaymentAmount == 2 && adp.NetPaymentAmount == 2 && adp.ActualVolume == 2 && 
                    adp.ActualValue == 2 && adp.PlannedValue == 2 && adp.PlannedVolume == 2 && adp.CollectionReturnCode == "CollRCode2"), "DeliverablePayment was incorrectly updated");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202002" && adp.DeliverableCode == 30 && adp.ActualValue == 32 && adp.ActualVolume == 32 && adp.ReconciliationPaymentAmount == 32 &&
                    adp.CappedPaymentAmount == 32 && adp.BalancingPaymentAmount == 32 && adp.ProfilePaymentAmount == 32 && adp.NetPaymentAmount == 32 && adp.ActualVolume == 32 &&
                    adp.ActualValue == 32 && adp.PlannedValue == 32 && adp.PlannedVolume == 32 && adp.CollectionReturnCode == "CollRCode2"), "DeliverablePayment was not added correctly");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202003" && adp.DeliverableCode == 20 && adp.ActualValue == null && adp.ActualVolume == null && adp.ReconciliationPaymentAmount == null &&
                    adp.CappedPaymentAmount == null && adp.BalancingPaymentAmount == null && adp.ProfilePaymentAmount == null && adp.NetPaymentAmount == null && adp.ActualVolume == null &&
                    adp.ActualValue == null && adp.PlannedValue == null && adp.PlannedVolume == null && adp.CollectionReturnCode == null), "DeliverablePayment should not have been updated");
            }
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_PersistPaymentScheduleAndActuals_ShouldAddPeriodsWhenThereAreNoDeliverablePaymentRecords()
        {
            // arrange
            const string allocationNumber = "AllocNo_PersistPaymentScheduleAndActuals";
            const int versionNumber = 99;

            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);

            var repository = new DeliverablePaymentRepository();

            var allocation = new Allocation
            {
                AllocationNumber = allocationNumber,
                VersionNumber = versionNumber,
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 10,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "202002", ReconciliationPaymentAmount = 2, CappedPaymentAmount = 2, BalancingPaymentAmount = 2, ProfilePaymentAmount = 2, NetPaymentAmount = 2, ActualVolume = 2, ActualValue = 2, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode2"},
                            new ScheduledPayment {Period = "202003", ReconciliationPaymentAmount = 3, CappedPaymentAmount = 3, BalancingPaymentAmount = 3, ProfilePaymentAmount = 3, NetPaymentAmount = 3, ActualVolume = 3, ActualValue = 3, PlannedValue = 3, PlannedVolume = 3, CollectionReturnCode = "CollRCode3"},
                            new ScheduledPayment {Period = "202004", ReconciliationPaymentAmount = 4, CappedPaymentAmount = 4, BalancingPaymentAmount = 4, ProfilePaymentAmount = 4, NetPaymentAmount = 4, ActualVolume = 4, ActualValue = 4, PlannedValue = 4, PlannedVolume = 4, CollectionReturnCode = "CollRCode4"},
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 20,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "202002", ReconciliationPaymentAmount = 22, CappedPaymentAmount = 22, BalancingPaymentAmount = 22, ProfilePaymentAmount = 22, NetPaymentAmount = 22, ActualVolume = 22, ActualValue = 22, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode2"},
                            new ScheduledPayment {Period = "202004", ReconciliationPaymentAmount = 24, CappedPaymentAmount = 24, BalancingPaymentAmount = 24, ProfilePaymentAmount = 24, NetPaymentAmount = 24, ActualVolume = 24, ActualValue = 24, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode4"},
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 30,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "202002", ReconciliationPaymentAmount = 32, CappedPaymentAmount = 32, BalancingPaymentAmount = 32, ProfilePaymentAmount = 32, NetPaymentAmount = 32, ActualVolume = 32, ActualValue = 32, PlannedValue = 2, PlannedVolume = 2, CollectionReturnCode = "CollRCode2"},
                        }
                    },

                }
            };

            // act 
            repository.PersistPaymentScheduleAndActuals(allocation, ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var assertDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                // Assert
                Assert.AreEqual(6, assertDeliverablePayments.Count, "Incorrect number of delivery payment records in table");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202002" && adp.DeliverableCode == 10 && adp.ActualValue == 2 && adp.ActualVolume == 2 && adp.ReconciliationPaymentAmount == 2 &&
                    adp.CappedPaymentAmount == 2 && adp.BalancingPaymentAmount == 2 && adp.ProfilePaymentAmount == 2 && adp.NetPaymentAmount == 2 && adp.ActualVolume == 2 &&
                    adp.ActualValue == 2 && adp.PlannedValue == 2 && adp.PlannedVolume == 2 && adp.CollectionReturnCode == "CollRCode2"), "DeliverablePayment was incorrectly updated");

                Assert.IsNotNull(assertDeliverablePayments.Where(adp =>
                    adp.Period == "202002" && adp.DeliverableCode == 30 && adp.ActualValue == 32 && adp.ActualVolume == 32 && adp.ReconciliationPaymentAmount == 32 &&
                    adp.CappedPaymentAmount == 32 && adp.BalancingPaymentAmount == 32 && adp.ProfilePaymentAmount == 32 && adp.NetPaymentAmount == 32 && adp.ActualVolume == 32 &&
                    adp.ActualValue == 32 && adp.PlannedValue == 32 && adp.PlannedVolume == 32 && adp.CollectionReturnCode == "CollRCode2"), "DeliverablePayment was not added correctly");

                Assert.IsNull(assertDeliverablePayments.SingleOrDefault(adp =>
                    adp.Period == "202003" && adp.DeliverableCode == 20 && adp.ActualValue == null && adp.ActualVolume == null && adp.ReconciliationPaymentAmount == null &&
                    adp.CappedPaymentAmount == null && adp.BalancingPaymentAmount == null && adp.ProfilePaymentAmount == null && adp.NetPaymentAmount == null && adp.ActualVolume == null &&
                    adp.ActualValue == null && adp.PlannedValue == null && adp.PlannedVolume == null && adp.CollectionReturnCode == null), "DeliverablePayment should not have been updated");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_PersistPaymentScheduleAndActualsShouldDoNothingWhenThereAreNoScheduledPayments()
        {
            // arrange
            const string allocationNumber = "AllocNo_PersistPaymentScheduleAndActuals";
            const int versionNumber = 99;

            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);

            var repository = new DeliverablePaymentRepository();

            var allocation = new Allocation
            {
                AllocationNumber = allocationNumber,
                VersionNumber = versionNumber,
                AllocationDeliverables = new List<AllocationDeliverable>()
            };

            // act 
            repository.PersistPaymentScheduleAndActuals(allocation, ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var assertDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                // Assert
                Assert.AreEqual(0, assertDeliverablePayments.Count, "Incorrect number of delivery payment records in table");
            }
        }

        private static void ClearDownDeliverablePaymentsForAllocationNumberAndVersion(string allocationNumber, int versionNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList()
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }
        }

        private static void CreateDeliverablePayment(string allocationNumber, int versionNumber, string period, int deliverableCode, 
            decimal netPaymentAmount, decimal plannedValue, decimal cappedPaymentAmount, decimal reconciliationPaymentAmount)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(
                    new DeliverablePayment
                    {
                        AllocationNumber =  allocationNumber,
                        VersionNumber = versionNumber,
                        Period = period,
                        DeliverableCode = deliverableCode,
                        NetPaymentAmount = netPaymentAmount,
                        PlannedValue = plannedValue,
                        CollectionReturnCode = "random",
                        CappedPaymentAmount = cappedPaymentAmount,
                        ReconciliationPaymentAmount = reconciliationPaymentAmount
                    }
                );

                context.SaveChanges();
            }
        }

        private static void CreateDeliverablePaymentWithActuals(string allocationNumber, int versionNumber, string period, int deliverableCode,
            decimal actualValue, int actualVolume)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(
                    new DeliverablePayment
                    {
                        AllocationNumber = allocationNumber,
                        VersionNumber = versionNumber,
                        Period = period,
                        DeliverableCode = deliverableCode,
                        ActualValue = actualValue,
                        ActualVolume = actualVolume
                    }
                );

                context.SaveChanges();
            }
        }
    }
}