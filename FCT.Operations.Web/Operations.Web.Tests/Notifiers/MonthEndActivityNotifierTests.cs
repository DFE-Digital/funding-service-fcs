namespace Operations.Web.Tests.Notifiers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System;
    using Operations.Web.Repositories;
    using Operations.Web.Notifiers;
    using Dtos;
    using Extensions;
    using System.Threading.Tasks;
    using Moq;

    [TestClass]
    public class MonthEndActivityNotifierTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndActivityNotifier_GetNotification_ShouldReturnMonthEndCompletedNotificationWhenMonthEndFinishedLessThanThreeHoursAgoAndAccountingForLocalTime()
        {
            // arrange
            var latestEndTimeUtc = DateTime.UtcNow.AddHours(-2.9).ToDateTimeWithoutMillisecondsUtc();
            var latestEndTimeLocal = TimeZoneInfo.ConvertTime(latestEndTimeUtc, TimeZoneInfo.FindSystemTimeZoneById("GMT Standard Time"));

            var expectedFormattedDateTime = $"{latestEndTimeLocal:MMMM dd 'at' h:mm tt}";

            var expectedNotificationDescription = "Month End completed: " + $"{expectedFormattedDateTime}";
            const string expectedNotificationName = "Month End Activity";

            var mockMonthEndRepository = new Mock<IMonthEndRepository>();
            mockMonthEndRepository.Setup(m => m.GetLatestEndTime())
                .Returns(Task.FromResult(new DateTime?(latestEndTimeUtc)));

            var notifier = new MonthEndActivityNotifier(mockMonthEndRepository.Object);

            //  act
            var notification = notifier.GetNotification().Result;

            // assert
            Assert.IsNotNull(notification, "Notification was not returned");
            Assert.AreEqual(expectedNotificationName, notification.NotificationName, "Incorrect NotificationName was returned");
            Assert.AreEqual(expectedNotificationDescription, notification.Description, "Incorrect Description was returned");
            Assert.AreEqual(NotificationType.Info, notification.NotificationType, "Incorrect NotificationType was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndActivityNotifier_GetNotification_ShouldReturnMonthEndProcessingNotificationNullWhenMonthEndIsStillRunning()
        {
            // arrange 
            const string expectedNotificationName = "Month End Activity";
            const string expectedNotificationDescription = "Month End Progressing";

            var mockMonthEndRepository = new Mock<IMonthEndRepository>();
            mockMonthEndRepository.Setup(m => m.GetLatestEndTime())
                .Returns(Task.FromResult((DateTime?) null));

            var notifier = new MonthEndActivityNotifier(mockMonthEndRepository.Object);

            //  act
            var notification = notifier.GetNotification().Result;
             
            // assert
            Assert.IsNotNull(notification, "Notification was not returned");
            Assert.AreEqual(expectedNotificationName, notification.NotificationName, "Incorrect NotificationName was returned");
            Assert.AreEqual(expectedNotificationDescription, notification.Description, "Incorrect Description was returned");
            Assert.AreEqual(NotificationType.Info, notification.NotificationType, "Incorrect NotificationType was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndActivityNotifier_GetNotification_ShouldReturnNullWhenMonthEndFinishedMoreThanThreeHoursAgo()
        {
            // arrange 
            DateTime? latestEndTime = DateTime.UtcNow.AddHours(-3.1).ToDateTimeWithoutMilliseconds();

            var mockMonthEndRepository = new Mock<IMonthEndRepository>();
            mockMonthEndRepository.Setup(m => m.GetLatestEndTime())
                .Returns(Task.FromResult(latestEndTime));

            var notifier = new MonthEndActivityNotifier(mockMonthEndRepository.Object);

            //  act
            var notification = notifier.GetNotification().Result;

            // assert
            Assert.IsNull(notification, "Notification was returned");
        }
    }
}