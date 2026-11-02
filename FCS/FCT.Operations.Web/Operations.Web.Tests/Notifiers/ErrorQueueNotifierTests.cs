namespace Operations.Web.Tests.Notifiers
{
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Notifiers;

    [TestClass]
    public class ErrorQueueNotifierTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void ErrorQueueNotifier_GetNotification_ShouldReturnNullNotificationWhenErrorQueueEmpty()
        {
            // arrange
            ErrorQueueNotifier notifier = new ErrorQueueNotifier();

            // act
            Notification notification = notifier.GetNotification().Result;

            // assert
            Assert.IsNull(notification);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ErrorQueueNotifier_GetNotification_ShouldReturnNotificationWhenErrorQueueNotEmpty()
        {
            // arrange
            ErrorQueueNotifier notifier = new ErrorQueueNotifier();

            // act
            Notification notification = notifier.GetNotification().Result;

            // assert
            Assert.IsNotNull(notification);
        }
    }
}