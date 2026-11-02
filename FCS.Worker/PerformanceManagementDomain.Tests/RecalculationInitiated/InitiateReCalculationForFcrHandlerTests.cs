namespace PerformanceManagementDomain.Tests.RecalculationInitiated
{
    using System;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.RecalculationInitiated;
    using PerformanceManagementDomain.RecalculationInitiated.Dto;
    using PerformanceManagementDomain.RecalculationInitiated.Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;

    [TestClass]
    public class InitiateReCalculationForFcrHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateReCalculationForFcrHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<InitiateReCalculationForFcrHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<InitiateReCalculationForFcrHandler>();
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateReCalculationForFcrHandler_WhenUserHasChangedReconciliationValue_ShouldSpecifyProposedReconciliationValueIsNotUpdated()
        {
            // arrange
            Mock<IFundingClaimReconciliationRepository> repositoryMock = new Mock<IFundingClaimReconciliationRepository>();
            repositoryMock
                .Setup(m => m.GetFundingClaimReconciliationInfo(It.IsAny<Guid>()))
                .Returns(new FundingClaimReconciliationInfo(Guid.NewGuid(), null, 1, null, null, null, null, new []{new FundingClaimReconciliationAllocationInfo(1m,1m), }));

            InitiateReCalculationForFcrHandler handler = new InitiateReCalculationForFcrHandler(Mock.Of<ILogger>(), repositoryMock.Object);
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            InitiateReCalculationForFcrCommand incomingCommand = new InitiateReCalculationForFcrCommand
            {
                FcrId = Guid.NewGuid().ToString(),
                HasFinalReconciliationValueChanged = true
            };

            // act
            handler.Handle(incomingCommand, context).Wait();

            // assert
            RecalculateFcrOnCappedClaimAdjustmentCommand sentCommand = context.SentMessages.Select(m => m.Message).OfType<RecalculateFcrOnCappedClaimAdjustmentCommand>().Single();
            Assert.IsFalse(sentCommand.ShouldUpdateFinalReconciliation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateReCalculationForFcrHandler_WhenUserHasNotChangedReconciliationValue_ShouldSpecifyProposedReconciliationValueIsUpdated()
        {
            // arrange
            Mock<IFundingClaimReconciliationRepository> repositoryMock = new Mock<IFundingClaimReconciliationRepository>();
            repositoryMock
                .Setup(m => m.GetFundingClaimReconciliationInfo(It.IsAny<Guid>()))
                .Returns(new FundingClaimReconciliationInfo(Guid.NewGuid(), null, 1, null, null, null, null, new []{new FundingClaimReconciliationAllocationInfo(1m,1m), }));

            InitiateReCalculationForFcrHandler handler = new InitiateReCalculationForFcrHandler(Mock.Of<ILogger>(), repositoryMock.Object);
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            InitiateReCalculationForFcrCommand incomingCommand = new InitiateReCalculationForFcrCommand
            {
                FcrId = Guid.NewGuid().ToString(),
                HasFinalReconciliationValueChanged = false
            };

            // act
            handler.Handle(incomingCommand, context).Wait();

            // assert
            RecalculateFcrOnCappedClaimAdjustmentCommand sentCommand = context.SentMessages.Select(m => m.Message).OfType<RecalculateFcrOnCappedClaimAdjustmentCommand>().Single();
            Assert.IsTrue(sentCommand.ShouldUpdateFinalReconciliation);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void InitiateReCalculationForFcrHandler_WhenFundingClaimReconciliationHasMultipleAllocationsAndHenceClaimValueCannotBeAdjusted_ShouldThrowArgumentException()
        {
            // arrange
            Mock<IFundingClaimReconciliationRepository> repositoryMock = new Mock<IFundingClaimReconciliationRepository>();
            repositoryMock
                .Setup(m => m.GetFundingClaimReconciliationInfo(It.IsAny<Guid>()))
                .Returns(new FundingClaimReconciliationInfo(Guid.NewGuid(), null, 1, null, null, null, null, new []{ new FundingClaimReconciliationAllocationInfo(1m,1m), new FundingClaimReconciliationAllocationInfo(1m, 1m) }));

            InitiateReCalculationForFcrHandler handler = new InitiateReCalculationForFcrHandler(Mock.Of<ILogger>(), repositoryMock.Object);
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            InitiateReCalculationForFcrCommand incomingCommand = new InitiateReCalculationForFcrCommand
            {
                FcrId = Guid.NewGuid().ToString(),
                HasFinalReconciliationValueChanged = false
            };

            // act
            bool expectedExceptionThrown = false;

            try
            {
                handler.Handle(incomingCommand, context).Wait();
            }
            catch (AggregateException aex) when (aex.InnerExceptions.Single() is ArgumentException)
            {
                expectedExceptionThrown = true;
            }

            // assert
            Assert.IsTrue(expectedExceptionThrown);
        }

    }
}
