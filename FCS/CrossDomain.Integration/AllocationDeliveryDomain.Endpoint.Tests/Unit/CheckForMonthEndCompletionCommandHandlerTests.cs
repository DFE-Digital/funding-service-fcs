namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using AllocationDelivery.Messages.Commands;
    using AllocationDeliveryDomain.Endpoint.IoC;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MonthEndCheck;
    using Moq;
    using NServiceBus;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CheckForMonthEndCompletionCommandHandlerTests
    {
        //[TestMethod, TestCategory("UnitTest")]
        //public void CheckForMonthEndCompletionCommandHandler_ShouldMarkMonthEndAsCompletedWhenMonthEndInitialDeferralPeriodExpiredAndMonthEndServiceBusActivityCompleted()
        //{
        //    // arrange
        //    var busMock = new Mock<IBus>();

        //    var monthEndServiceMock = new Mock<IMonthEndService>();
        //    monthEndServiceMock.Setup(m => m.HasMonthEndInitialDeferralPeriodExpired()).Returns(true);
        //    monthEndServiceMock.Setup(m => m.HasMonthEndServiceBusActivityCompleted()).Returns(true);
           
        //    var checkForMonthEndCompletionCommandHandler = new CheckForMonthEndCompletionCommandHandler(
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        monthEndServiceMock.Object,
        //        Mock.Of<IHeldReportedActualGroupEvaluator>());

        //    // act
        //    checkForMonthEndCompletionCommandHandler.Handle(new CheckForMonthEndCompletionCommand());

        //    // assert
        //    busMock.Verify(m => m.Defer(It.IsAny<TimeSpan>(), It.IsAny<object>()), Times.Never, "Message was unexpectedly deferred.");
        //    monthEndServiceMock.Verify(m => m.MarkMonthEndAsCompleted(), Times.Once, "Month-end was not marked as completed.");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void CheckForMonthEndCompletionCommandHandler_ShouldPublishMonthEndCompletedEventWhenMonthEndInitialDeferralPeriodExpiredAndMonthEndServiceBusActivityCompleted()
        //{
        //    // arrange
        //    var busMock = new Mock<IBus>();

        //    var monthEndServiceMock = new Mock<IMonthEndService>();
        //    monthEndServiceMock.Setup(m => m.HasMonthEndInitialDeferralPeriodExpired()).Returns(true);
        //    monthEndServiceMock.Setup(m => m.HasMonthEndServiceBusActivityCompleted()).Returns(true);

        //    var checkForMonthEndCompletionCommandHandler = new CheckForMonthEndCompletionCommandHandler(
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        monthEndServiceMock.Object,
        //        Mock.Of<IHeldReportedActualGroupEvaluator>());

        //    // act
        //    checkForMonthEndCompletionCommandHandler.Handle(new CheckForMonthEndCompletionCommand());

        //    // assert
        //    busMock.Verify(m => m.Publish(It.IsAny<MonthEndCompletedEvent>()), Times.Once);
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void CheckForMonthEndCompletionCommandHandler_ShouldDeferMessageWhenMonthEndInitialDeferralPeriodHasNotExpired()
        //{
        //    // arrange
        //    var busMock = new Mock<IBus>();

        //    var monthEndServiceMock = new Mock<IMonthEndService>();
        //    monthEndServiceMock.Setup(m => m.HasMonthEndInitialDeferralPeriodExpired()).Returns(false);
        //    monthEndServiceMock.Setup(m => m.HasMonthEndServiceBusActivityCompleted()).Returns(true);

        //    var checkForMonthEndCompletionCommandHandler = new CheckForMonthEndCompletionCommandHandler(
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        monthEndServiceMock.Object,
        //        Mock.Of<IHeldReportedActualGroupEvaluator>()
        //        );

        //    // act
        //    checkForMonthEndCompletionCommandHandler.Handle(new CheckForMonthEndCompletionCommand());

        //    // assert
        //    busMock.Verify(m => m.Defer(It.IsAny<TimeSpan>(), It.IsAny<object>()), Times.Once, "Message was not deferred.");
        //    monthEndServiceMock.Verify(m => m.MarkMonthEndAsCompleted(), Times.Never, "Month-end was unexpectedly marked as completed.");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void CheckForMonthEndCompletionCommandHandler_ShouldDeferMessageWhenMonthEndServiceBusActivityHasNotCompleted()
        //{
        //    // arrange
        //    var busMock = new Mock<IBus>();

        //    var monthEndServiceMock = new Mock<IMonthEndService>();
        //    monthEndServiceMock.Setup(m => m.HasMonthEndInitialDeferralPeriodExpired()).Returns(true);
        //    monthEndServiceMock.Setup(m => m.HasMonthEndServiceBusActivityCompleted()).Returns(false);

        //    var checkForMonthEndCompletionCommandHandler = new CheckForMonthEndCompletionCommandHandler(
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        monthEndServiceMock.Object,
        //        Mock.Of<IHeldReportedActualGroupEvaluator>());

        //    // act
        //    checkForMonthEndCompletionCommandHandler.Handle(new CheckForMonthEndCompletionCommand());

        //    // assert
        //    busMock.Verify(m => m.Defer(It.IsAny<TimeSpan>(), It.IsAny<object>()), Times.Once, "Message was not deferred.");
        //    monthEndServiceMock.Verify(m => m.MarkMonthEndAsCompleted(), Times.Never, "Month-end was unexpectedly marked as completed.");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void CheckForMonthEndCompletionCommandHandler_ShouldSendCommandToReleaseHeld_WhenMonthEndCompleteAndHeldPresent()
        //{
        //    // arrange
        //    var busMock = new Mock<IBus>();
        //    bool isReleaseCommandSent = false;
        //    busMock.Setup(b => b.Send(It.IsAny<object>())).Callback((object message) =>
        //    {
        //        isReleaseCommandSent = message is ReleaseHeldReportedActualsCommand;
        //    });

        //    var monthEndServiceMock = new Mock<IMonthEndService>();
        //    monthEndServiceMock.Setup(m => m.HasMonthEndInitialDeferralPeriodExpired()).Returns(true);
        //    monthEndServiceMock.Setup(m => m.HasMonthEndServiceBusActivityCompleted()).Returns(true);
        //    Mock<IHeldReportedActualGroupEvaluator> heldReportedActualGroupEvaluatorMock = new Mock<IHeldReportedActualGroupEvaluator>();
        //    heldReportedActualGroupEvaluatorMock.Setup(e => e.AreAnyHeldReportedActualGroupsReadyToBeProcessed())
        //        .Returns(true);

        //    var checkForMonthEndCompletionCommandHandler = new CheckForMonthEndCompletionCommandHandler(
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        monthEndServiceMock.Object,
        //        heldReportedActualGroupEvaluatorMock.Object);

        //    // act
        //    checkForMonthEndCompletionCommandHandler.Handle(new CheckForMonthEndCompletionCommand());

        //    // assert
        //    Assert.IsTrue(isReleaseCommandSent);
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void CheckForMonthEndCompletionCommandHandler_ShouldNotSendCommandToReleaseHeld_WhenMonthEndIsNotCompleteAndHeldPresent()
        //{
        //    // arrange
        //    var busMock = new Mock<IBus>();
        //    bool isReleaseCommandSent = false;
        //    busMock.Setup(b => b.Send(It.IsAny<object>())).Callback((object message) =>
        //    {
        //        isReleaseCommandSent = message is ReleaseHeldReportedActualsCommand;
        //    });

        //    var monthEndServiceMock = new Mock<IMonthEndService>();
        //    monthEndServiceMock.Setup(m => m.HasMonthEndInitialDeferralPeriodExpired()).Returns(true);
        //    monthEndServiceMock.Setup(m => m.HasMonthEndServiceBusActivityCompleted()).Returns(false);
        //    Mock<IHeldReportedActualGroupEvaluator> heldReportedActualGroupEvaluatorMock = new Mock<IHeldReportedActualGroupEvaluator>();
        //    heldReportedActualGroupEvaluatorMock.Setup(e => e.AreAnyHeldReportedActualGroupsReadyToBeProcessed())
        //        .Returns(true);

        //    var checkForMonthEndCompletionCommandHandler = new CheckForMonthEndCompletionCommandHandler(
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        monthEndServiceMock.Object,
        //        heldReportedActualGroupEvaluatorMock.Object);

        //    // act
        //    checkForMonthEndCompletionCommandHandler.Handle(new CheckForMonthEndCompletionCommand());

        //    // assert
        //    Assert.IsFalse(isReleaseCommandSent);
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ShouldResolve_IHeldReportedActualGroupEvaluator()
        //{
        //    var obj = CreateContainer().Resolve<IHeldReportedActualGroupEvaluator>();
        //    Assert.IsNotNull(obj);
        //}

        //private IWindsorContainer CreateContainer()
        //{
        //    ILoggerFactory loggerFactory = new LoggerFactory();

        //    AllocationDeliveryDomain.Endpoint.IoC.WindsorInstaller windsorInstaller = new WindsorInstaller(loggerFactory);
        //    var container = new WindsorContainer().Install(windsorInstaller);
        //    container.Register(Component.For<MonitoringDeliverablesDbContext>().IsDefault());

        //    container.BeginScope();

        //    return container;
        //}
    }
}
