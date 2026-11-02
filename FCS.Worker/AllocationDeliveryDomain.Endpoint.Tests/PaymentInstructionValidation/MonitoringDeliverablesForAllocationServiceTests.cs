namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation
{
    using System.Collections.Generic;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using Endpoint.PaymentInstructionValidation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.NullObjects;

    [TestClass]
    public class MonitoringDeliverablesForAllocationServiceTests
    {
        private const string ContractNumber = "MAIN-1234";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 2;
        private const string AllocationNumber = "CL-100";
        private const string EsfAllocationNumber = "ESF-100";
        private const string ValidOrganisationId = "ORG0000001";
        private const string Ukprn = "10000020";
        private const string ValidFundingStreamPeriodCode = "CL1516";
        private const string ValidEsfFundingStreamPeriodCode = "ESF1516";
        private const string DeliverableName = "DeliverableName";

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesForAllocationService_PopulateMissingValidDeliverables_ShouldCreateADPRecordsWhenIsAllowedToBeAddedIsTrue()
        {
            // arrange
            const int testDeliverableCode = 3;

            RemoveAdpRecords();
            CreateAdpRecords();
            SetFspDeliverable(true, testDeliverableCode);

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = testDeliverableCode.ToString(),
                    Period = "201508",
                    UoPCode = ""
                }
            };

            bool raiseMonitoringDeliverableAddedPostApprovalEventCalled = false;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var monitoringDeliverablesForAllocationService = new MonitoringDeliverablesForAllocationService(new MonitoringDeliverableStore(new LoggerNullObject()));
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                monitoringDeliverablesForAllocationService.PopulateMissingValidDeliverables(actuals,
                    a => { raiseMonitoringDeliverableAddedPostApprovalEventCalled = true; }, connectionInfo);
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var allocationDeliverablePeriods = context.AllocationDeliverablePeriods.Where(
                    adp => adp.ContractNumber == ContractNumber && adp.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && adp.DeliverableCode == testDeliverableCode);

                Assert.AreEqual(3, allocationDeliverablePeriods.Count(), $"AllocationDeliverablePeriods were not correctly created for deliverable {testDeliverableCode}");
            }

            Assert.IsTrue(raiseMonitoringDeliverableAddedPostApprovalEventCalled, "raiseMonitoringDeliverableAddedPostApprovalEvent was not called");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesForAllocationService_PopulateMissingValidDeliverables_ShouldCreateADPRecordsOnceWhenIsAllowedToBeAddedIsTrueAndThereAreManyReportActuals()
        {
            // arrange
            const int testDeliverableCode = 3;

            RemoveAdpRecords();
            CreateAdpRecords();
            SetFspDeliverable(true, testDeliverableCode);

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = testDeliverableCode.ToString(),
                    Period = "201508",
                    UoPCode = ""
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = testDeliverableCode.ToString(),
                    Period = "201509",
                    UoPCode = ""
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = testDeliverableCode.ToString(),
                    Period = "201510",
                    UoPCode = ""
                }
            };

            bool raiseMonitoringDeliverableAddedPostApprovalEventCalled = false;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var monitoringDeliverablesForAllocationService = new MonitoringDeliverablesForAllocationService(new MonitoringDeliverableStore(new LoggerNullObject()));
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                monitoringDeliverablesForAllocationService.PopulateMissingValidDeliverables(actuals,
                    a => { raiseMonitoringDeliverableAddedPostApprovalEventCalled = true; }, connectionInfo);
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var allocationDeliverablePeriods = context.AllocationDeliverablePeriods.Where(
                    adp => adp.ContractNumber == ContractNumber && adp.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && adp.DeliverableCode == testDeliverableCode);

                Assert.AreEqual(3, allocationDeliverablePeriods.Count(), $"AllocationDeliverablePeriods were not correctly created for deliverable {testDeliverableCode}");
            }

            Assert.IsTrue(raiseMonitoringDeliverableAddedPostApprovalEventCalled, "raiseMonitoringDeliverableAddedPostApprovalEvent was not called");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesForAllocationService_PopulateMissingValidDeliverables_ShouldNotCreateADPRecordsWhenIsAllowedToBeAddedIsFalse()
        {
            // arrange
            const int testDeliverableCode = 3;

            RemoveAdpRecords();
            CreateAdpRecords();
            SetFspDeliverable(false, testDeliverableCode);

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = testDeliverableCode.ToString(),
                    Period = "201508",
                    UoPCode = ""
                }
            };

            bool raiseMonitoringDeliverableAddedPostApprovalEventCalled = false;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var monitoringDeliverablesForAllocationService = new MonitoringDeliverablesForAllocationService(new MonitoringDeliverableStore(new LoggerNullObject()));
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                monitoringDeliverablesForAllocationService.PopulateMissingValidDeliverables(actuals,
                    a => { raiseMonitoringDeliverableAddedPostApprovalEventCalled = true; }, connectionInfo);
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var allocationDeliverablePeriods = context.AllocationDeliverablePeriods.Where(
                    adp => adp.ContractNumber == ContractNumber && adp.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && adp.DeliverableCode == testDeliverableCode);

                Assert.AreEqual(0, allocationDeliverablePeriods.Count(), $"AllocationDeliverablePeriods were incorrectly created for deliverable {testDeliverableCode}");
            }

            Assert.IsFalse(raiseMonitoringDeliverableAddedPostApprovalEventCalled, "raiseMonitoringDeliverableAddedPostApprovalEvent was incorrectly called");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesForAllocationService_PopulateMissingValidDeliverables_ShouldNotCreateADPRecordsWhenActualsDoNotIncludeMissingDeliverable()
        {
            // arrange
            const int testDeliverableCode = 3;

            RemoveAdpRecords();
            CreateAdpRecords();
            SetFspDeliverable(true, testDeliverableCode);

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201508",
                    UoPCode = ""
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201509",
                    UoPCode = ""
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201510",
                    UoPCode = ""
                }
            };

            bool raiseMonitoringDeliverableAddedPostApprovalEventCalled = false;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var monitoringDeliverablesForAllocationService = new MonitoringDeliverablesForAllocationService(new MonitoringDeliverableStore(new LoggerNullObject()));
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                monitoringDeliverablesForAllocationService.PopulateMissingValidDeliverables(actuals,
                    a => { raiseMonitoringDeliverableAddedPostApprovalEventCalled = true; }, connectionInfo);
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var allocationDeliverablePeriods = context.AllocationDeliverablePeriods.Where(
                    adp => adp.ContractNumber == ContractNumber && adp.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && adp.DeliverableCode == testDeliverableCode);

                Assert.AreEqual(0, allocationDeliverablePeriods.Count(), $"AllocationDeliverablePeriods were incorrectly created for deliverable {testDeliverableCode}");
            }

            Assert.IsFalse(raiseMonitoringDeliverableAddedPostApprovalEventCalled, "raiseMonitoringDeliverableAddedPostApprovalEvent was incorrectly called");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesForAllocationService_PopulateMissingValidDeliverables_ShouldDoNothingIfNoActiveAllocationDeliverablePeriods()
        {
            // arrange
            RemoveAdpRecords();

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201508",
                    UoPCode = ""
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201509",
                    UoPCode = ""
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201510",
                    UoPCode = ""
                }
            };

            bool raiseMonitoringDeliverableAddedPostApprovalEventCalled = false;

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var monitoringDeliverablesForAllocationService = new MonitoringDeliverablesForAllocationService(new MonitoringDeliverableStore(new LoggerNullObject()));
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                // act
                monitoringDeliverablesForAllocationService.PopulateMissingValidDeliverables(actuals,
                    a => { raiseMonitoringDeliverableAddedPostApprovalEventCalled = true; }, connectionInfo);
            }

            // assert
            Assert.IsFalse(raiseMonitoringDeliverableAddedPostApprovalEventCalled);
        }

        private static void CreateAdpRecords()
        {
            var allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>
            {
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn,
                    UopCode = ""
                },

                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = EsfAllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidEsfFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = EsfAllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidEsfFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = EsfAllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidEsfFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = EsfAllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidEsfFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = EsfAllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidEsfFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn,
                    UopCode = ""
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = EsfAllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidEsfFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn,
                    UopCode = ""
                }
            };

            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods.AddRange(allocationDeliverablePeriods);
                context.SaveChanges();
            }
        }

        private static void RemoveAdpRecords()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods.Where(
                        adp => adp.ContractNumber == ContractNumber)
                    .ForEach(row => context.AllocationDeliverablePeriods.Remove(row));

                context.SaveChanges();
            }
        }

        private static void SetFspDeliverable(bool isAllowedToBeAdded, int deliverableCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var fundingStreamPeriodDeliverable = new FundingStreamPeriodDeliverable
                {
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = deliverableCode,
                    ParentDeliverableCode = 0,
                    DeliverableName = DeliverableName,
                    AllowProfile = false,
                    AllowActuals = true,
                    AllowPayment = true,
                    DisplayOrder = 99,
                    IsAllowedToBeAdded = isAllowedToBeAdded
                };

                context.FundingStreamPeriodDeliverables.AddOrUpdate(fundingStreamPeriodDeliverable);
                context.SaveChanges();
            }
        }
    }
}