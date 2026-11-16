namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ContractApprovedEventHandlerTests
    {
        private const string TestContractAllocationNumber = "TESTDG00";
        private const string NonPayOnProfileFsp = "ASTO1516";
        private const string PayOnProfileFsp = "ASC1516";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                List<ContractAllocation> allocationsToDelete = dbContext.ContractAllocations
                    .Where(ca => ca.AllocationNumber.Substring(0, 8) == TestContractAllocationNumber).ToList();
                allocationsToDelete.ForEach(x => dbContext.ContractAllocations.Remove(x));

                IEnumerable<ContractAllocationDeliverable> deliverablesToDelete = dbContext.ContractAllocationDeliverables
                    .Where(cad => cad.ContractAllocationNumber.Substring(0, 8) == TestContractAllocationNumber);
                dbContext.ContractAllocationDeliverables.RemoveRange(deliverablesToDelete);

                dbContext.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovedEventHandler_ShouldSuccessfullyPersistContractAllocations()
        {
            // Arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();

                fcrRecalculationRequiredCheckerMock.Setup(c => c.CheckIfRecalculationRequired(
                        It.IsAny<IReadOnlyCollection<AllocationInfo>>(),
                        It.IsAny<string>(), It.IsAny<decimal>()))
                    .Returns(new RecalculationCheckResult(false, null));

                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                ContractApprovedEventHandler contractApprovedEventHandler = new ContractApprovedEventHandler(
                    new Mock<ILogger>().Object,
                    new ContractAllocationRepository(),
                    new FundingStreamPeriodQueryRepository(),
                    new ContractAllocationDeliverableRepository(),
                    fcrRecalculationRequiredCheckerMock.Object,
                    mockSessionConnectionFactory.Object);

                SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract contractToTest = GetContractToTest();

                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // Act
                contractApprovedEventHandler.Handle(new ContractApprovedEvent { CorporateContract = contractToTest }, testableContext).Wait();
            }

            // Assert
            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                List<ContractAllocation> storedAllocations = dbContext.ContractAllocations.Where(x =>
                        x.AllocationNumber.Substring(0, 8) == TestContractAllocationNumber)
                    .ToList();
                Assert.AreEqual(storedAllocations.Count(), 5, "ContractApprovedEventHandler did not store 5 Allocations.");
                Assert.IsTrue(storedAllocations.All(a => a.Period.PeriodTypeName == "ACADEMICYEAR"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovedEventHandler_ShouldNotPersistContractAllocationsWhenFundingStreamPeriodIsNotPayOnProfile()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                // Arrange
                var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();

                fcrRecalculationRequiredCheckerMock.Setup(c => c.CheckIfRecalculationRequired(
                        It.IsAny<IReadOnlyCollection<AllocationInfo>>(),
                        It.IsAny<string>(), It.IsAny<decimal>()))
                    .Returns(new RecalculationCheckResult(false, null));

                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                ContractApprovedEventHandler contractApprovedEventHandler = new ContractApprovedEventHandler(
                    new Mock<ILogger>().Object,
                    new ContractAllocationRepository(),
                    new FundingStreamPeriodQueryRepository(),
                    new ContractAllocationDeliverableRepository(),
                    fcrRecalculationRequiredCheckerMock.Object,
                    mockSessionConnectionFactory.Object);

                SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract contractToTest = GetContractToTest();
                contractToTest.contracts.ForEach(c => c.contractAllocations.ForEach(a => a.fundingStreamPeriodCode = NonPayOnProfileFsp));

                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // Act
                contractApprovedEventHandler.Handle(new ContractApprovedEvent { CorporateContract = contractToTest }, testableContext).Wait();
            }

            // Assert
            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                List<ContractAllocation> storedAllocations = dbContext.ContractAllocations.Where(x => x.AllocationNumber.Substring(0, 8) == TestContractAllocationNumber).ToList();
                Assert.AreEqual(0, storedAllocations.Count(), "ContractApprovedEventHandler stored allocations that were not relevant for funding claims.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovedEventHandler_ShouldSuccessfullyPersistUpdatedContractAllocationsWhenContractVersionIncrements()
        {
            // Arrange
            SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract contractToTest = GetContractToTest();
            const int incrementedContractVersionNumber = 2;

            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();

                fcrRecalculationRequiredCheckerMock.Setup(c => c.CheckIfRecalculationRequired(
                        It.IsAny<IReadOnlyCollection<AllocationInfo>>(),
                        It.IsAny<string>(),It.IsAny<decimal>()))
                    .Returns(new RecalculationCheckResult(false,
                        null));

                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                ContractApprovedEventHandler contractApprovedEventHandler = new ContractApprovedEventHandler(
                    new Mock<ILogger>().Object,
                    new ContractAllocationRepository(),
                    new FundingStreamPeriodQueryRepository(),
                    new ContractAllocationDeliverableRepository(),
                    fcrRecalculationRequiredCheckerMock.Object,
                    mockSessionConnectionFactory.Object);

                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // Act
                contractApprovedEventHandler.Handle(new ContractApprovedEvent { CorporateContract = contractToTest }, testableContext).Wait();
            }

            // Act again using a new handler instance with new db context
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();

                fcrRecalculationRequiredCheckerMock.Setup(c => c.CheckIfRecalculationRequired(
                        It.IsAny<IReadOnlyCollection<AllocationInfo>>(),
                        It.IsAny<string>(), It.IsAny<decimal>()))
                    .Returns(new RecalculationCheckResult(false, null));

                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                ContractApprovedEventHandler contractApprovedEventHandler = new ContractApprovedEventHandler(
                    new Mock<ILogger>().Object,
                    new ContractAllocationRepository(),
                    new FundingStreamPeriodQueryRepository(),
                    new ContractAllocationDeliverableRepository(),
                    fcrRecalculationRequiredCheckerMock.Object,
                    mockSessionConnectionFactory.Object);

                contractToTest.contracts[0].contractVersionNumber = incrementedContractVersionNumber;

                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // Act
                contractApprovedEventHandler.Handle(new ContractApprovedEvent { CorporateContract = contractToTest }, testableContext).Wait();
            }

            // Assert
            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                List<ContractAllocation> storedAllocations = dbContext.ContractAllocations.Where(x => x.AllocationNumber.Substring(0, 8) == TestContractAllocationNumber).ToList();
                Assert.AreEqual(5, storedAllocations.Count(), "ContractApprovedEventHandler did not result in 5 Allocations.");
                Assert.IsTrue(storedAllocations.All(sa => sa.Contract.VersionNumber == 2));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovedEventHandler_ShouldSuccessfullyAggregateAndStoreContractAllocationDeliverables()
        {
            // Arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();

                fcrRecalculationRequiredCheckerMock.Setup(c => c.CheckIfRecalculationRequired(
                        It.IsAny<IReadOnlyCollection<AllocationInfo>>(),
                        It.IsAny<string>(), It.IsAny<decimal>()))
                    .Returns(new RecalculationCheckResult(false, null));

                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                ContractApprovedEventHandler contractApprovedEventHandler = new ContractApprovedEventHandler(
                    new Mock<ILogger>().Object,
                    new ContractAllocationRepository(),
                    new FundingStreamPeriodQueryRepository(),
                    new ContractAllocationDeliverableRepository(),
                    fcrRecalculationRequiredCheckerMock.Object,
                    mockSessionConnectionFactory.Object);


                SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract contractToTest = GetContractToTest();

                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // Act
                contractApprovedEventHandler.Handle(new ContractApprovedEvent { CorporateContract = contractToTest }, testableContext).Wait();
            }

            // Assert
            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                IEnumerable<ContractAllocationDeliverable> deliverables =
                    dbContext.ContractAllocationDeliverables
                    .Where(cad => cad.ContractAllocationNumber.Substring(0, 8) == TestContractAllocationNumber && cad.DeliverableCode == 2);
                Assert.IsTrue(deliverables.Any(), "ContractApprovedEventHandler did not store deliverables.");
                Assert.IsTrue(deliverables.All(d => d.PlannedValue == 70), "ContractApprovedEventHandler did not store deliverables with correct planned values.");
            }
        }

        private SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract GetContractToTest()
        {
            string TestLegalName = "LegalName";
            string TestOrganisationId = "OrgId";
            int TestUkPrn = 1;
            string TestFundingTypeCode = "ASC1516";
            string TestFundingTypeName = "TFTN";
            string _testContractNumber = DateTime.Now.Ticks.ToString();
            DateTime _testApprovalDate = new DateTime(2016, 01, 01);
            int TestContractVersionNumber = 1;
            int TestContractSubVersionNumber = 1;
            return new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = _testContractNumber,
                        ContractApprovalDate = _testApprovalDate,
                        contractVersionNumber = TestContractVersionNumber,
                        contractSubVersionNumber = TestContractSubVersionNumber,
                        contractor = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contractor
                        {
                            legalName = TestLegalName,
                            organisationIdentifier = TestOrganisationId,
                            ukprn = TestUkPrn
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = TestFundingTypeCode,
                            fundingTypeName = TestFundingTypeName
                        },
                        period = new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Period
                        {
                            periodType = new periodTypeType
                            {
                                periodTypeName = periodTypeNameType.ACADEMICYEAR
                            }
                        },
                        contractAllocations = GetContractAllocations()
                    }
                }
            };
        }

        private List<contractAllocationsContractAllocation> GetContractAllocations()
        {
            DateTime _testAllocationStartDate = new DateTime(2016, 02, 02);
            DateTime _testAllocationEndDate = new DateTime(2016, 03, 03);


            List<contractAllocationsContractAllocation> contractAllocations = new List<contractAllocationsContractAllocation>();
            for (int i = 1; i <= 5; i++)
            {
                contractAllocations.Add(new contractAllocationsContractAllocation
                {
                    contractAllocationNumber = TestContractAllocationNumber + i,
                    startDate = _testAllocationStartDate,
                    endDate = _testAllocationEndDate,
                    fundingStreamPeriodCode = PayOnProfileFsp,
                    contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                    {
                        new contractDeliverablesTypeContractDeliverable
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = 1
                            },
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    plannedValue = 10m
                                },
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    plannedValue = 20m
                                }
                            },
                            contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                            {
                                new contractDeliverablesTypeContractDeliverable
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = 2
                                    },
                                    contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                    {
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            plannedValue = 30m
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            plannedValue = 40m
                                        }
                                    }
                                },
                                new contractDeliverablesTypeContractDeliverable
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = 3
                                    },
                                    contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                    {
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            plannedValue = 50m
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            plannedValue = 60m
                                        }
                                    }
                                }
                            }
                        }
                    }
                });
            }

            return contractAllocations;
        }
    }
}