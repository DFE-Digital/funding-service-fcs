namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using CrossDomain.Integration.Entities.Data;
    using Microsoft.Extensions.Logging;
    using FundingClaimReconciliation.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentSchedule.DataStore;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;
    using Model = PaymentSchedule.DataStore.Model;

    [TestClass]
    public class PaymentScheduleAllocationCommandRepositoryTests
    {
        private const string AllocationNumber = "ALLOC-12345";
        private const int AllocationVersion = 1;
        private readonly DateTime _allocationStartDate = new DateTime(2015, 08, 01, 0, 0, 0, DateTimeKind.Utc);
        private readonly DateTime _allocationEndDate = new DateTime(2015, 07, 31, 0, 0, 0, DateTimeKind.Utc);
        private IPaymentScheduleAllocationCommandRepository _repository;

        [TestInitialize]
        public void TestInitialize()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory()));
            container.BeginScope();
            _repository = container.Resolve<IPaymentScheduleAllocationCommandRepository>();

            CleanupDatabaseTestFixtures();
            SetupPaymentScheduleDatabaseTestFixtures();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            CleanupDatabaseTestFixtures();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentScheduleAllocationCommandRepository_UpdateDeliverablePaymentsForAllocation_ShouldCorrectlyUpdatePaymentSchedule()
        {
            // arrange
            PaymentSchedule.Allocation inputAllocation = CreatePayCalcOutputAllocation();

            // act
            _repository.UpdateDeliverablePaymentsForAllocation(inputAllocation, _allocationStartDate, _allocationEndDate,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                Model.Allocation retrievedAllocation = context.Allocations.Find(AllocationNumber, AllocationVersion);
                Assert.IsNotNull(retrievedAllocation, "Retrieved allocation is null.");
                Assert.AreEqual(AllocationNumber, retrievedAllocation.AllocationNumber, "Retrieved AllocationNumber is incorrect.");
                Assert.AreEqual(AllocationVersion, retrievedAllocation.VersionNumber, "Retrieved VersionNumber is incorrect.");
                Assert.AreEqual(inputAllocation.FundingStreamPeriodCode, retrievedAllocation.FundingStreamPeriodCode, "Retrieved FundingStreamPeriodCode is incorrect.");
                Assert.AreEqual(inputAllocation.ContractNumber, retrievedAllocation.ContractNumber, "Retrieved ContractNumber is incorrect.");
                Assert.AreEqual(inputAllocation.ContractVersionNumber, retrievedAllocation.ContractVersionNumber, "Retrieved ContractVersionNumber is incorrect.");
                Assert.AreEqual(_allocationStartDate, retrievedAllocation.AllocationStartDate, "Retrieved AllocationStartDate is incorrect.");
                Assert.AreEqual(_allocationEndDate, retrievedAllocation.AllocationEndDate, "Retrieved AllocationEndDate is incorrect.");

                List<Model.DeliverablePayment> retrievedDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == AllocationNumber && dp.VersionNumber == AllocationVersion)
                    .ToList();
                Assert.AreEqual(3, retrievedDeliverablePayments.Count, "Incorrect number of deliverable payments retrieved.");

                PaymentSchedule.AllocationDeliverable expectedDeliverable = inputAllocation.AllocationDeliverables.Single();
                PaymentSchedule.ScheduledPayment expectedPayment201508 = expectedDeliverable.ScheduledPayments.Single(sp => sp.Period == "201508");
                PaymentSchedule.ScheduledPayment expectedPayment201509 = expectedDeliverable.ScheduledPayments.Single(sp => sp.Period == "201509");
                PaymentSchedule.ScheduledPayment expectedPayment201510 = expectedDeliverable.ScheduledPayments.Single(sp => sp.Period == "201510");

                Model.DeliverablePayment actualDeliverablePayment201508 = retrievedDeliverablePayments.SingleOrDefault(dp => dp.Period == "201508");
                Assert.IsNotNull(actualDeliverablePayment201508, "Retrieved deliverable payment for 201508 is null.");
                Assert.AreEqual(expectedPayment201508.Period, actualDeliverablePayment201508.Period, "Retrieved deliverable payment for 201508 Period is incorrect");
                Assert.AreEqual((Model.PeriodTypeCode)Enum.Parse(typeof(Model.PeriodTypeCode), expectedPayment201508.PeriodTypeCode), actualDeliverablePayment201508.PeriodTypeCode, "Retrieved deliverable payment for 201508 PeriodTypeCode is incorrect");
                Assert.AreEqual(expectedPayment201508.CollectionReturnCode, actualDeliverablePayment201508.CollectionReturnCode, "Retrieved deliverable payment for 201508 CollectionReturnCode is incorrect");
                Assert.AreEqual(expectedPayment201508.ActualValue, actualDeliverablePayment201508.ActualValue, "Retrieved deliverable payment for 201508 ActualValue is incorrect");
                Assert.AreEqual(expectedPayment201508.ActualVolume, actualDeliverablePayment201508.ActualVolume, "Retrieved deliverable payment for 201508 ActualVolume is incorrect");
                Assert.AreEqual(expectedPayment201508.BalancingPaymentAmount, actualDeliverablePayment201508.BalancingPaymentAmount, "Retrieved deliverable payment for 201508 BalancingPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201508.CappedPaymentAmount, actualDeliverablePayment201508.CappedPaymentAmount, "Retrieved deliverable payment for 201508 CappedPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201508.NetPaymentAmount, actualDeliverablePayment201508.NetPaymentAmount, "Retrieved deliverable payment for 201508 NetPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201508.PlannedValue, actualDeliverablePayment201508.PlannedValue, "Retrieved deliverable payment for 201508 PlannedValue is incorrect");
                Assert.AreEqual(expectedPayment201508.PlannedVolume, actualDeliverablePayment201508.PlannedVolume, "Retrieved deliverable payment for 201508PlannedVolume  is incorrect");
                Assert.AreEqual(expectedPayment201508.ProfilePaymentAmount, actualDeliverablePayment201508.ProfilePaymentAmount, "Retrieved deliverable payment for 201508ProfilePaymentAmount  is incorrect");
                Assert.AreEqual(expectedPayment201508.ReconciliationPaymentAmount, actualDeliverablePayment201508.ReconciliationPaymentAmount, "Retrieved deliverable payment for 201508 ReconciliationPaymentAmount is incorrect");

                Model.DeliverablePayment actualDeliverablePayment201509 = retrievedDeliverablePayments.SingleOrDefault(dp => dp.Period == "201509");
                Assert.IsNotNull(actualDeliverablePayment201509, "Retrieved deliverable payment for 201509 is null.");
                Assert.AreEqual(expectedPayment201509.Period, actualDeliverablePayment201509.Period, "Retrieved deliverable payment for 201509 Period is incorrect");
                Assert.AreEqual((Model.PeriodTypeCode)Enum.Parse(typeof(Model.PeriodTypeCode), expectedPayment201509.PeriodTypeCode), actualDeliverablePayment201509.PeriodTypeCode, "Retrieved deliverable payment for 201509 PeriodTypeCode is incorrect");
                Assert.AreEqual(expectedPayment201509.CollectionReturnCode, actualDeliverablePayment201509.CollectionReturnCode, "Retrieved deliverable payment for 201509 CollectionReturnCode is incorrect");
                Assert.AreEqual(expectedPayment201509.ActualValue, actualDeliverablePayment201509.ActualValue, "Retrieved deliverable payment for 201509 ActualValue is incorrect");
                Assert.AreEqual(expectedPayment201509.ActualVolume, actualDeliverablePayment201509.ActualVolume, "Retrieved deliverable payment for 201509 ActualVolume is incorrect");
                Assert.AreEqual(expectedPayment201509.BalancingPaymentAmount, actualDeliverablePayment201509.BalancingPaymentAmount, "Retrieved deliverable payment for 201509 BalancingPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201509.CappedPaymentAmount, actualDeliverablePayment201509.CappedPaymentAmount, "Retrieved deliverable payment for 201509 CappedPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201509.NetPaymentAmount, actualDeliverablePayment201509.NetPaymentAmount, "Retrieved deliverable payment for 201509 NetPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201509.PlannedValue, actualDeliverablePayment201509.PlannedValue, "Retrieved deliverable payment for 201509 PlannedValue is incorrect");
                Assert.AreEqual(expectedPayment201509.PlannedVolume, actualDeliverablePayment201509.PlannedVolume, "Retrieved deliverable payment for 201509PlannedVolume  is incorrect");
                Assert.AreEqual(expectedPayment201509.ProfilePaymentAmount, actualDeliverablePayment201509.ProfilePaymentAmount, "Retrieved deliverable payment for 201509ProfilePaymentAmount  is incorrect");
                Assert.AreEqual(expectedPayment201509.ReconciliationPaymentAmount, actualDeliverablePayment201509.ReconciliationPaymentAmount, "Retrieved deliverable payment for 201509 ReconciliationPaymentAmount is incorrect");

                Model.DeliverablePayment actualDeliverablePayment201510 = retrievedDeliverablePayments.SingleOrDefault(dp => dp.Period == "201510");
                Assert.IsNotNull(actualDeliverablePayment201510, "Retrieved deliverable payment for 201510 is null.");
                Assert.AreEqual(expectedPayment201510.Period, actualDeliverablePayment201510.Period, "Retrieved deliverable payment for 201510 Period is incorrect");
                Assert.AreEqual((Model.PeriodTypeCode)Enum.Parse(typeof(Model.PeriodTypeCode), expectedPayment201510.PeriodTypeCode), actualDeliverablePayment201510.PeriodTypeCode, "Retrieved deliverable payment for 201510 PeriodTypeCode is incorrect");
                Assert.AreEqual(expectedPayment201510.CollectionReturnCode, actualDeliverablePayment201510.CollectionReturnCode, "Retrieved deliverable payment for 201510 CollectionReturnCode is incorrect");
                Assert.AreEqual(expectedPayment201510.ActualValue, actualDeliverablePayment201510.ActualValue, "Retrieved deliverable payment for 201510 ActualValue is incorrect");
                Assert.AreEqual(expectedPayment201510.ActualVolume, actualDeliverablePayment201510.ActualVolume, "Retrieved deliverable payment for 201510 ActualVolume is incorrect");
                Assert.AreEqual(expectedPayment201510.BalancingPaymentAmount, actualDeliverablePayment201510.BalancingPaymentAmount, "Retrieved deliverable payment for 201510 BalancingPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201510.CappedPaymentAmount, actualDeliverablePayment201510.CappedPaymentAmount, "Retrieved deliverable payment for 201510 CappedPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201510.NetPaymentAmount, actualDeliverablePayment201510.NetPaymentAmount, "Retrieved deliverable payment for 201510 NetPaymentAmount is incorrect");
                Assert.AreEqual(expectedPayment201510.PlannedValue, actualDeliverablePayment201510.PlannedValue, "Retrieved deliverable payment for 201510 PlannedValue is incorrect");
                Assert.AreEqual(expectedPayment201510.PlannedVolume, actualDeliverablePayment201510.PlannedVolume, "Retrieved deliverable payment for 201510PlannedVolume  is incorrect");
                Assert.AreEqual(expectedPayment201510.ProfilePaymentAmount, actualDeliverablePayment201510.ProfilePaymentAmount, "Retrieved deliverable payment for 201510ProfilePaymentAmount  is incorrect");
                Assert.AreEqual(expectedPayment201510.ReconciliationPaymentAmount, actualDeliverablePayment201510.ReconciliationPaymentAmount, "Retrieved deliverable payment for 201510 ReconciliationPaymentAmount is incorrect");
            }

        }

        private static PaymentSchedule.Allocation CreatePayCalcOutputAllocation()
        {
            return new PaymentSchedule.Allocation
            {
                AllocationNumber = AllocationNumber,
                VersionNumber = AllocationVersion,
                FundingStreamPeriodCode = "FSP1516",
                ContractNumber = "MAIN-12345",
                ContractVersionNumber = 1,
                AllocationDeliverables = new List<PaymentSchedule.AllocationDeliverable>
                {
                    new PaymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<PaymentSchedule.ScheduledPayment>
                        {
                            new PaymentSchedule.ScheduledPayment
                            {
                                Period = "201508",
                                PeriodTypeCode = "AY",
                                CollectionReturnCode = "R12",
                                ActualValue = 31,
                                ActualVolume = 32,
                                BalancingPaymentAmount = 33,
                                CappedPaymentAmount = 34,
                                NetPaymentAmount = 35,
                                PlannedValue = 36,
                                PlannedVolume = 37,
                                ProfilePaymentAmount = 38,
                                ReconciliationPaymentAmount = 39
                            },
                            new PaymentSchedule.ScheduledPayment
                            {
                                Period = "201509",
                                PeriodTypeCode = "AY",
                                CollectionReturnCode = "R12",
                                ActualValue = 41,
                                ActualVolume = 42,
                                BalancingPaymentAmount = 43,
                                CappedPaymentAmount = 44,
                                NetPaymentAmount = 45,
                                PlannedValue = 46,
                                PlannedVolume = 347,
                                ProfilePaymentAmount = 48,
                                ReconciliationPaymentAmount = 49
                            },
                            new PaymentSchedule.ScheduledPayment
                            {
                                Period = "201510",
                                PeriodTypeCode = "AY",
                                CollectionReturnCode = "R12",
                                ActualValue = 51,
                                ActualVolume = 52,
                                BalancingPaymentAmount = 53,
                                CappedPaymentAmount = 54,
                                NetPaymentAmount = 55,
                                PlannedValue = 56,
                                PlannedVolume = 57,
                                ProfilePaymentAmount = 58,
                                ReconciliationPaymentAmount = 59
                            }
                        }
                    }
                }
            };
        }

        private void SetupPaymentScheduleDatabaseTestFixtures()
        {
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Add(new Model.Allocation
                {
                    AllocationNumber = AllocationNumber,
                    VersionNumber = AllocationVersion,
                    FundingStreamPeriodCode = "FSP1516",
                    ContractNumber = "MAIN-12345",
                    ContractVersionNumber = 1,
                    AllocationStartDate = _allocationStartDate,
                    AllocationEndDate = _allocationEndDate,
                    LastModifiedDate = DateTime.UtcNow
                });

                ((DbSet<Model.DeliverablePayment>) context.DeliverablePayments).AddRange(new List<Model.DeliverablePayment>
                {
                    new Model.DeliverablePayment
                    {
                        AllocationNumber = AllocationNumber,
                        VersionNumber = AllocationVersion,
                        DeliverableCode = 1,
                        Period = "201508",
                        PeriodTypeCode = Model.PeriodTypeCode.AY,
                        CollectionReturnCode = "R12",
                        LastModifiedDate = DateTime.UtcNow,
                        ActualValue = 11,
                        ActualVolume = 12,
                        BalancingPaymentAmount = 13,
                        CappedPaymentAmount = 14,
                        NetPaymentAmount = 15,
                        PlannedVolume = 16,
                        PlannedValue = 17,
                        ProfilePaymentAmount = 18,
                        ReconciliationPaymentAmount = 19
                    },
                    new Model.DeliverablePayment
                    {
                        AllocationNumber = AllocationNumber,
                        VersionNumber = AllocationVersion,
                        DeliverableCode = 1,
                        Period = "201509",
                        PeriodTypeCode = Model.PeriodTypeCode.AY,
                        CollectionReturnCode = "R12",
                        LastModifiedDate = DateTime.UtcNow,
                        ActualValue = 21,
                        ActualVolume = 22,
                        BalancingPaymentAmount = 23,
                        CappedPaymentAmount = 24,
                        NetPaymentAmount = 25,
                        PlannedVolume = 26,
                        PlannedValue = 27,
                        ProfilePaymentAmount = 28,
                        ReconciliationPaymentAmount = 29
                    }
                });

                context.SaveChanges();
            }
        }

        private static void CleanupDatabaseTestFixtures()
        {
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.Database.ExecuteSqlCommand(
                    "DELETE FROM [PaymentSchedule].[Allocation] WHERE [AllocationNumber] = @allocationNumber",
                    new SqlParameter("@allocationNumber", AllocationNumber));

                context.Database.ExecuteSqlCommand(
                    "DELETE FROM [PaymentSchedule].[DeliverablePayment] WHERE [AllocationNumber] = @allocationNumber",
                    new SqlParameter("@allocationNumber", AllocationNumber));
            }
        }
    }
}
