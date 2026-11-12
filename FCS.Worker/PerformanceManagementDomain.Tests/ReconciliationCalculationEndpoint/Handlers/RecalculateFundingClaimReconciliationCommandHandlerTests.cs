namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using PerformanceManagementDomain.Services;
    using ContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.ContractAllocation;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using ClaimReconciliationAllocationGroupFspRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationAllocationGroupFspRepository;
    using ClaimReconciliationAllocationGroupRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationAllocationGroupRepository;
    using ClaimReferenceProfileRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReferenceProfileRepository;
    using ContractAllocationDeliverableRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ContractAllocationDeliverableRepository;
    using ContractAllocationRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ContractAllocationRepository;
    using FundingClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.FundingClaimRepository;
    using IFundingClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.IFundingClaimRepository;
    using ClaimTypeRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimTypeRepository;
    using FspDeliverableClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.FspDeliverableClaimRepository;
    using ClaimReconciliationBehaviourRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationBehaviourRepository;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;
    using NServiceBus.Testing;
    using Infrastructure;
    using NServiceBus;

    [TestClass]
    public class RecalculateFundingClaimReconciliationCommandHandlerTests
    {
        private const string OrgId = "ORG0017192";
        private const int VersionNumber = 3;
        private const string ClaimType = "YEAREND";
        private const string PeriodTypeCode = "AY";
        private const string Period = "1617";
        private const string AllocationGroup = "AAC1617";

        [TestMethod, TestCategory("UnitTest")]
        public void RecalculateFundingClaimReconciliationCommandHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<RecalculateFundingClaimReconciliationCommandHandler>().ImplementedBy<RecalculateFundingClaimReconciliationCommandHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<RecalculateFundingClaimReconciliationCommandHandler>();
        }

        [TestMethod, TestCategory("DataDependent")]
        public void RecalculateFundingClaimReconciliationCommandHandler_Handle_RecalculateFundingClaimReconciliationCommand_ShouldProduceCorrectInputToCalculate()
        {
            // arrange
            // data is setup by running Acceptance Test A192
            List<DebatchedFundingClaim> fundingClaimPassedForCalc = new List<DebatchedFundingClaim>();

            IFundingClaimDebatchService fundingClaimDebatchService =
                new FundingClaimDebatchService(new ClaimReconciliationAllocationGroupFspRepository());

            IFundingClaimRepository fundingClaimRepository = new FundingClaimRepository();

            IFundingClaimEnrichmentService fundingClaimEnrichmentService =
                new FundingClaimEnrichmentService(new ContractAllocationDeliverableRepository(),
                    new PolicyDeliverableRepository(),
                    new FspDeliverableClaimRepository(),
                    Mock.Of<IParentDeliverableResolver>());

            Mock<ICalculationService> mockCalcService = new Mock<ICalculationService>();
            mockCalcService.Setup(c => c.Calculate(It.IsAny<DebatchedFundingClaim>(), It.IsAny<ConnectionInfo>(), 0, 0))
                .Callback<DebatchedFundingClaim, ConnectionInfo, decimal>((dfc, ci, c) => fundingClaimPassedForCalc.Add(dfc))
                .Returns(
                    () => Task.FromResult(
                        new FundingClaimReconciliation
                        {
                            Amounts = new AmountSummary { ProposedReconciliationValue = 0m }
                        }));

            using (var context = new PerformanceManagementDbContext())
            {
                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                var handler = new RecalculateFundingClaimReconciliationCommandHandler(
                    mockCalcService.Object, fundingClaimRepository, fundingClaimDebatchService, Mock.Of<IFcrUpdateService>(), 
                    fundingClaimEnrichmentService, Mock.Of<ILogger>(), mockSessionConnectionFactory.Object);

                var message = new RecalculateFundingClaimReconciliationCommand(
                    OrgId, VersionNumber, ClaimType, PeriodTypeCode, Period, AllocationGroup, Guid.Empty, 0);

                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // act
                handler.Handle(message, testableContext).Wait();

                // assert
                Assert.AreNotEqual(0, fundingClaimPassedForCalc.Count);
                AssertCalcInputIsAsExpected(fundingClaimPassedForCalc);
            }
        }

        [TestMethod, TestCategory("DataDependent")]
        public void RecalculateFundingClaimReconciliationCommandHandler_Handle_RecalculateFundingClaimReconciliationCommand_ShouldProduceCorrectResultToStoreToCrm()
        {
            // arrange
            // data is setup by running Acceptance Test A823
            IFundingClaimDebatchService fundingClaimDebatchService =
                new FundingClaimDebatchService(new ClaimReconciliationAllocationGroupFspRepository());

            IFundingClaimRepository fundingClaimRepository = new FundingClaimRepository();

            ICalculationService calculationService =
                new CalculationService(new ClaimReconciliationBehaviourRepository(),
                    new FspDeliverableClaimRepository(), new ContractAllocationRepository(),
                    new ClaimReconciliationAllocationGroupRepository(), new ClaimTypeRepository(),
                    new DeliverableGroupAmountSummaryCreator(new ClaimReferenceProfileRepository()));

            IFundingClaimEnrichmentService fundingClaimEnrichmentService =
                new FundingClaimEnrichmentService(new ContractAllocationDeliverableRepository(),
                    new PolicyDeliverableRepository(),
                    new FspDeliverableClaimRepository(),
                    new ParentDeliverableResolver());

            using (var context = new PerformanceManagementDbContext())
            {
                Mock<IFcrUpdateService> mockFcrUpdateService = new Mock<IFcrUpdateService>();
                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                var handler = new RecalculateFundingClaimReconciliationCommandHandler(
                    calculationService, fundingClaimRepository, fundingClaimDebatchService,
                    mockFcrUpdateService.Object, fundingClaimEnrichmentService, Mock.Of<ILogger>(), mockSessionConnectionFactory.Object);

                var message = GetRecalculateFundingClaimReconciliationCommandFromFile();
                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // act
                handler.Handle(message, testableContext).Wait();

                // assert
                mockFcrUpdateService.Verify(m => m.UpdateFundingClaimReconciliationInCrm(
                        It.Is<AmountSummary>(a => a.ProposedReconciliationValue == 0m),
                        It.IsAny<IEnumerable<SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractAllocation>>(),
                        It.IsAny<Guid>()),
                    Times.Once);
            }
        }


        private void AssertCalcInputIsAsExpected(List<DebatchedFundingClaim> dfc)
        {
            var aac = dfc.SingleOrDefault(d => d.AllocationGroupCode == "AAC1617");

            Assert.IsNotNull(aac, "Allocation group code was AAC not found");
            Assert.AreEqual(Period, aac.Period, "Period was not as expected");
            Assert.AreEqual(ClaimType, aac.ClaimTypeName.ToString(), "ClaimType was not as expected");
            Assert.AreEqual(PeriodTypeCode, aac.PeriodTypeCode.ToString(), "PeriodTypeCode was not as expected");
            Assert.AreEqual(VersionNumber, aac.VersionNumber, "VersionNumber was not as expected");
            Assert.AreEqual(OrgId, aac.Contractor.OrganisationIdentifier, "Organisation Id was not as expected");

            AssertAllocationsAsExpected(aac.ContractAllocations);
        }

        private void AssertAllocationsAsExpected(List<ContractAllocation> contractAllocations)
        {
            var aac = contractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == "AAC-192");
            //var dls = contractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == "DLS-948");

            Assert.IsNotNull(aac, "ALLC Allocation was not found");
            //Assert.IsNotNull(dls, "DLS allocation was not found");
            Assert.AreEqual(1, contractAllocations.Count, "Wrong number of allocations in Debatched Funding Claim");
            //Assert.AreEqual(4, dls.DeliverableLines.Count, "Wrong number of DLS deliverable lines");
            Assert.AreEqual(9, aac.DeliverableLines.Count, "Wrong number of ALLC deliverable lines");
        }

        private RecalculateFundingClaimReconciliationCommand GetRecalculateFundingClaimReconciliationCommandFromFile()
        {
            return TestResource.FromJson<RecalculateFundingClaimReconciliationCommand>(
                "PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.TestResources",
                "RecalculateFundingClaimReconciliationCommand.json");
        }
    }
}