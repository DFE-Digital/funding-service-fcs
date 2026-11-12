namespace PerformanceManagementDomain.XrmEndpoint.Tests.Handlers
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Events;
    using PerformanceManagementDomain.XrmEndpoint.Handlers;
    using PerformanceManagementDomain.XrmEndpoint.Repositories;
    using NServiceBus;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.Lifestyle;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    [TestClass]
    public class ProposedReconciliationCalculatedEventHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ProposedReconciliationCalculatedEventHandler_ShouldResolve()
        {
            // arrange
            using (IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            {
                container.Register(Component.For<ProposedReconciliationCalculatedEventHandler>());
                container.BeginScope();

                // act
                var handler = container.Resolve<ProposedReconciliationCalculatedEventHandler>();

                // assert
                Assert.IsNotNull(handler, "Handler failed to resolve");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProposedReconciliationCalculatedEventHandler_ShouldCallCreateFundingClaimReconciliation()
        {
            // arrange 
            Mock<IFundingClaimReconciliationCommandRepository> fundingClaimReconciliationCommandRepositoryMock =
                new Mock<IFundingClaimReconciliationCommandRepository>();

            ProposedReconciliationCalculatedEventHandler handler = new ProposedReconciliationCalculatedEventHandler(
                Mock.Of<ILogger>(),
                fundingClaimReconciliationCommandRepositoryMock.Object
            );

            var message = new ProposedReconciliationCalculatedEvent {FundingClaimReconciliation = new FundingClaimReconciliation()};
            // act 
            handler.Handle(message, Mock.Of<IMessageHandlerContext>());

            // assert
            fundingClaimReconciliationCommandRepositoryMock.Verify(
                x => x.CreateFundingClaimReconciliation(It.IsAny<FundingClaimReconciliation>()),
                Times.Once,
                "CreateFundingClaimReconciliation was not called");
        }

    }
}