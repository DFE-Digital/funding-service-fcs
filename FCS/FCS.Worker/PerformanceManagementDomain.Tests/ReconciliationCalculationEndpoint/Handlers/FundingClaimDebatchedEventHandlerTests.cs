namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using UnitTests.Common;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ClaimReconciliationAllocationGroupRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationAllocationGroupRepository;
    using ClaimReferenceProfileRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReferenceProfileRepository;
    using ContractAllocationDeliverableRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ContractAllocationDeliverableRepository;
    using ContractAllocationRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ContractAllocationRepository;
    using ClaimTypeRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimTypeRepository;
    using FspDeliverableClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.FspDeliverableClaimRepository;
    using ClaimReconciliationBehaviourRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationBehaviourRepository;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using NServiceBus;
    using NServiceBus.Testing;

    [TestClass]
    public class FundingClaimDebatchedEventHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimDebatchedEventHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IPerformanceManagementDbContext>().ImplementedBy<PerformanceManagementDbContext>().LifestyleScoped().IsDefault())
                .Register(Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped().IsDefault())
                .Register(Component.For<FundingClaimDebatchedEventHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<FundingClaimDebatchedEventHandler>();
        }

        [TestMethod, TestCategory("DataDependent")]
        public void FundingClaimDebatchedEventHandler_Handle_InvestigateWhyItErrorsInDat()
        {
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
                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                var handler = new FundingClaimDebatchedEventHandler(Mock.Of<ILogger>(),
                calculationService, fundingClaimEnrichmentService, mockSessionConnectionFactory.Object);

                var message = GetFromFundingClaimDebatchedEventFile();

                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // act
                handler.Handle(message, testableContext).Wait();
            }
        }

        private FundingClaimDebatchedEvent GetFromFundingClaimDebatchedEventFile()
        {
            return TestResource.FromJson<FundingClaimDebatchedEvent>(
                "PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.TestResources",
                "FundingClaimDebatchedEvent_AEBL-450.json");
        }
    }
}