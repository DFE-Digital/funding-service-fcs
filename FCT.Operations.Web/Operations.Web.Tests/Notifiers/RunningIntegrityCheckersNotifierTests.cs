namespace Operations.Web.Tests.Notifiers
{
    using System;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;
    using Web.Notifiers;

    [TestClass]
    public class RunningIntegrityCheckersNotifierTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void RunningIntegrityCheckersNotifier_ShouldReturnNotificationWhenLastRunningOfAnIntegrityCheckerIsStillRunningInLastTwoDays()
        {
            // arrange
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.IntegrityCheckItems.RemoveAll();

                context.IntegrityCheckItems.Add(CreateRunningIntegrityCheck("INTEGRITY_CHECKER_STILL_RUNNING_BUT_LONG_AGO", DateTime.UtcNow.AddDays(-3)));

                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_FINISHED", "Success", DateTime.UtcNow.AddDays(-2)));

                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_FINISHED_BUT_NOW_RUNNING_AGAIN", "Success", DateTime.UtcNow.AddDays(-2)));
                context.IntegrityCheckItems.Add(CreateRunningIntegrityCheck("INTEGRITY_CHECKER_FINISHED_BUT_NOW_RUNNING_AGAIN",  DateTime.UtcNow.AddDays(-1)));

                context.IntegrityCheckItems.Add(CreateRunningIntegrityCheck("INTEGRITY_CHECKER_RUNNING", DateTime.UtcNow.AddMinutes(-10)));

                context.SaveChanges();
            }

            // act
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var notifier = new RunningIntegrityCheckersNotifier(context);

                Notification notification = notifier.GetNotification().Result;

                // assert
                Assert.IsNotNull(notification);
                Assert.AreEqual("Running Integrity Checkers", notification.NotificationName);
                Assert.AreEqual("INTEGRITY_CHECKER_FINISHED_BUT_NOW_RUNNING_AGAIN, INTEGRITY_CHECKER_RUNNING", notification.Description);
                Assert.AreEqual(NotificationType.Info, notification.NotificationType);
            }
        }

        private static IntegrityCheck CreateFinishedIntegrityCheck(string checkerType, string outcome, DateTime startDate)
        {
            IntegrityCheck check = IntegrityCheck.CreateIntegrityCheck(checkerType, "Completed", startDate);
            check.FinishDate = startDate.AddHours(1);
            check.Outcome = outcome;

            return check;
        }

        private static IntegrityCheck CreateRunningIntegrityCheck(string checkerType, DateTime startDate)
        {
            return IntegrityCheck.CreateIntegrityCheck(checkerType, "Running", startDate);
        }
    }
}
