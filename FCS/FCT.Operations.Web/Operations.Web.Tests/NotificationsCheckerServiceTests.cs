namespace Operations.Web.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Moq;
    using Services;
    using System.Configuration;

    [TestClass]
    public class NotificationsCheckerServiceTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
        
        [TestMethod, TestCategory("UnitTest")]
        public void NotificationsService_GetNotifications_ShouldReturnNotifications()
        {
            // arrange
            const string notificationMessage = "Random notification description";
            Notification nullNotification = null;

            Mock<INotifierFactory> mockNotifierFactory = new Mock<INotifierFactory>();
            mockNotifierFactory.Setup(m => m.GetNotifiers())
                              .Returns(new List<Func<Task<Notification>>>
                              {
                                  () => Task.FromResult(new Notification(notificationMessage, string.Empty, NotificationType.Error)),
                                  () => Task.FromResult(new Notification(string.Empty, string.Empty, NotificationType.Error)),
                                  () => Task.FromResult(nullNotification)
                              });

            NotificationsService service = new NotificationsService(mockNotifierFactory.Object);

            // act
            var notifications = Task.Run(() => service.GetNotifications()).GetAwaiter().GetResult();

            // assert

            Assert.AreEqual(2, notifications.Count);
            Assert.AreEqual(notificationMessage, notifications.First().Description);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NotificationsService_GetNotifications_ShouldReturnNoNotifications()
        {
            // arrange
            Notification nullNotification = null;

            Mock <INotifierFactory> mockNotifierFactory = new Mock<INotifierFactory>();
            mockNotifierFactory.Setup(m => m.GetNotifiers())
                              .Returns(new List<Func<Task<Notification>>>
                              {
                                  () => Task.FromResult(nullNotification),
                                  () => Task.FromResult(nullNotification)
                              });

            NotificationsService service = new NotificationsService(mockNotifierFactory.Object);

            // act
            var notifications = Task.Run(() => service.GetNotifications()).GetAwaiter().GetResult();

            // assert

            Assert.AreEqual(0, notifications.Count);
        }
    }
}