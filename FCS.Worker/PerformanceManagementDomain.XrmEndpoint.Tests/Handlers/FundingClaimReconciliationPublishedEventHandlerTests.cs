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

    [TestClass]
    public class FundingClaimReconciliationPublishedEventHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedEventHandler_ShouldCallSetStatusOfFundingClaimReconciliationToManuallyPublished()
        {
            // arrange 
            Mock<IFundingClaimReconciliationCommandRepository> fundingClaimReconciliationCommandRepositoryMock =
                new Mock<IFundingClaimReconciliationCommandRepository>();

            FundingClaimReconciliationPublishedEventHandler handler = new FundingClaimReconciliationPublishedEventHandler(
                Mock.Of<ILogger>(),
                fundingClaimReconciliationCommandRepositoryMock.Object
            );

            // act 
            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                IsForManualPublication = true
            }, Mock.Of<IMessageHandlerContext>());

            // assert
            fundingClaimReconciliationCommandRepositoryMock.Verify(
                x => x.SetStatusOfFundingClaimReconciliationToManuallyPublished(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Once, "SetStatusOfFundingClaimReconciliationToManuallyPublished was not called");
            fundingClaimReconciliationCommandRepositoryMock.Verify(
                x => x.SetStatusOfFundingClaimReconciliationToPublished(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never, "SetStatusOfFundingClaimReconciliationToPublished was called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedEventHandler_ShouldCallSetStatusOfFundingClaimReconciliationToPublished()
        {
            // arrange 
            Mock<IFundingClaimReconciliationCommandRepository> fundingClaimReconciliationCommandRepositoryMock =
                new Mock<IFundingClaimReconciliationCommandRepository>();

            FundingClaimReconciliationPublishedEventHandler handler = new FundingClaimReconciliationPublishedEventHandler(
                Mock.Of<ILogger>(),
                fundingClaimReconciliationCommandRepositoryMock.Object
            );

            // act 
            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                IsForManualPublication = false
            }, Mock.Of<IMessageHandlerContext>());

            // assert
            fundingClaimReconciliationCommandRepositoryMock.Verify(
                x => x.SetStatusOfFundingClaimReconciliationToManuallyPublished(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never, "SetStatusOfFundingClaimReconciliationToManuallyPublished was called");
            fundingClaimReconciliationCommandRepositoryMock.Verify(
                x => x.SetStatusOfFundingClaimReconciliationToPublished(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Once, "SetStatusOfFundingClaimReconciliationToPublished was not called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationFailedPublicationEventHandler_ShouldCallSetStatusOfFundingClaimReconciliationToPublishFailed()
        {
            // arrange 
            Mock<IFundingClaimReconciliationCommandRepository> fundingClaimReconciliationCommandRepositoryMock =
                new Mock<IFundingClaimReconciliationCommandRepository>();

            FundingClaimReconciliationPublishedEventHandler handler = new FundingClaimReconciliationPublishedEventHandler(
                Mock.Of<ILogger>(),
                fundingClaimReconciliationCommandRepositoryMock.Object
            );

            // act 
            handler.Handle(new FundingClaimReconciliationFailedPublicationEvent(), Mock.Of<IMessageHandlerContext>());

            // assert
            fundingClaimReconciliationCommandRepositoryMock.Verify(
                x => x.SetStatusOfFundingClaimReconciliationToPublishFailed(It.IsAny<Guid>(),
                    It.IsAny<DateTime>(),
                    It.IsAny<string>()),
                Times.Once,
                "SetStatusOfFundingClaimReconciliationToPublishFailed was not called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationFailedPublicationEventHandler_ShouldResolve()
        {
            // arrange
            using (IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            {
                container.Register(global::Castle.MicroKernel.Registration.Component.For<global::Microsoft.Xrm.Sdk.IOrganizationService>().Instance(global::Moq.Mock.Of<global::Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());
                container.Register(Component.For<FundingClaimReconciliationPublishedEventHandler>());
                container.BeginScope();

                // act
                var handler = container.Resolve<FundingClaimReconciliationPublishedEventHandler>();

                // assert
                Assert.IsNotNull(handler, "Handler failed to resolve");
            }
        }
    }
}