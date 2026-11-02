namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using CrossDomain.Integration.Events;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services;

    [TestClass]
    public class MessageDeferrerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MessageDeferrer_WhenADeferIsNotNeeded_ShouldInvokeAction()
        {
            // Arrange
            string testErrorMessage = "";
            int numberOfTimesActionWasInvoked = 0;
            Mock<IBus> moqBus = new Mock<IBus>();
            Mock<IDeferrableEvent> message = new Mock<IDeferrableEvent>();
            message = message.SetupProperty(m => m.TimesMessageDeferred, 39);
            message.Setup(m => m.ToString()).Returns("");

            // Act
            bool wasDeferred = MessageDeferrer.DeferEventIfNecessary(moqBus.Object, message.Object, () => false, () => numberOfTimesActionWasInvoked++, testErrorMessage);

            // Assert
            Assert.AreEqual(false, wasDeferred, "MessageDeferrer returned unexpected bool");
            Assert.AreEqual(1, numberOfTimesActionWasInvoked, "Unexpected number of invocations of the action");
            Assert.AreEqual(39, message.Object.TimesMessageDeferred, "Unexpected number in TimesMessageDeferred field");
            moqBus.Verify(b => b.Defer(It.IsAny<TimeSpan>(), It.IsAny<object>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MessageDeferrer_WhenADeferIsNeeded_ShouldDeferMessageAndIncrementAppropriateField()
        {
            // Arrange
            string testErrorMessage = "";
            int numberOfTimesActionWasInvoked = 0;

            Mock<IBus> moqBus = new Mock<IBus>();
            Mock<IDeferrableEvent> message = new Mock<IDeferrableEvent>();
            message = message.SetupProperty(m => m.TimesMessageDeferred, 39);

            // Act
            bool wasDeferred = MessageDeferrer.DeferEventIfNecessary(moqBus.Object, message.Object, () => true, () => numberOfTimesActionWasInvoked++, testErrorMessage);

            // Assert
            Assert.AreEqual(true, wasDeferred, "MessageDeferrer returned unexpected bool");
            Assert.AreEqual(0, numberOfTimesActionWasInvoked, "Unexpected number of invocations of the action");
            Assert.AreEqual(40, message.Object.TimesMessageDeferred, "Unexpected number in TimesMessageDeferred field");
            moqBus.Verify(b => b.Defer(It.IsAny<TimeSpan>(), It.IsAny<object>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MessageDeferrer_WhenTheNumberOfTimesMessageReferredIsOnThreshold_ShouldThrowAnExceptionAndNotDefer()
        {
            // Arrange
            string testErrorMessage = "";
            int numberOfTimesActionWasInvoked = 0;

            Mock<IBus> moqBus = new Mock<IBus>();
            Mock<IDeferrableEvent> message = new Mock<IDeferrableEvent>();
            message = message.SetupProperty(m => m.TimesMessageDeferred, 40);

            // Act
            bool wasDeferred = false;
            try
            {
                wasDeferred = MessageDeferrer.DeferEventIfNecessary(moqBus.Object, message.Object, () => true, () => numberOfTimesActionWasInvoked++, testErrorMessage);
            }
            catch (ArgumentOutOfRangeException)
            {}

            // Assert
            Assert.AreEqual(false, wasDeferred, "MessageDeferrer returned unexpected bool");
            Assert.AreEqual(0, numberOfTimesActionWasInvoked, "Unexpected number of invocations of the action");
            Assert.AreEqual(40, message.Object.TimesMessageDeferred, "Unexpected number in TimesMessageDeferred field");
            moqBus.Verify(b => b.Defer(It.IsAny<TimeSpan>(), It.IsAny<object>()), Times.Never);
        }
    }
}
