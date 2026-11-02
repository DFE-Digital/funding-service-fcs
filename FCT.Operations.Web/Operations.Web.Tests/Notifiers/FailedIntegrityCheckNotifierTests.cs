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
    public class FailedIntegrityCheckersNotifierTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FailedIntegrityCheckersNotifier_ShouldReturnNotificationWhenLastRunningOfAnIntegrityCheckerHasFailedOrErroredInLastFourDays()
        {
            // arrange
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.IntegrityCheckItems.RemoveAll();

                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_TOO_OLD", "Failed", DateTime.UtcNow.AddDays(-5)));

                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_FAILS_THEN_SUCCEEDS", "Failed", DateTime.UtcNow.AddDays(-2)));
                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_SUCCEEDS_THEN_FAILS", "Success", DateTime.UtcNow.AddDays(-2)));
                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_SUCCEEDS_THEN_ERRORS", "Success", DateTime.UtcNow.AddDays(-2)));

                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_FAILS_THEN_SUCCEEDS", "Success", DateTime.UtcNow.AddDays(-1)));
                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_SUCCEEDS_THEN_FAILS", "Failed", DateTime.UtcNow.AddDays(-1)));
                context.IntegrityCheckItems.Add(CreateErroredIntegrityCheck("INTEGRITY_CHECKER_SUCCEEDS_THEN_ERRORS", DateTime.UtcNow.AddDays(-1)));
                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_FAILS", "Failed", DateTime.UtcNow.AddDays(-1)));
                context.IntegrityCheckItems.Add(CreateFinishedIntegrityCheck("INTEGRITY_CHECKER_SUCCEEDS", "Success", DateTime.UtcNow.AddDays(-1)));

                context.IntegrityCheckItems.Add(CreateRunningIntegrityCheck("INTEGRITY_CHECKER_STILL_RUNNING",  DateTime.UtcNow));

                context.SaveChanges();
            }

            // act
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                FailedIntegrityCheckersNotifier notifier = new FailedIntegrityCheckersNotifier(context);

                Notification notification = notifier.GetNotification().Result;

                // assert
                Assert.IsNotNull(notification);
                Assert.AreEqual("Failed Integrity Checkers", notification.NotificationName);
                Assert.AreEqual("INTEGRITY_CHECKER_FAILS, INTEGRITY_CHECKER_SUCCEEDS_THEN_ERRORS, INTEGRITY_CHECKER_SUCCEEDS_THEN_FAILS", notification.Description);
                Assert.AreEqual(NotificationType.Warning, notification.NotificationType);
            }
        }

        private static IntegrityCheck CreateFinishedIntegrityCheck(string checkerType, string outcome, DateTime startDate)
        {
            IntegrityCheck check = IntegrityCheck.CreateIntegrityCheck(checkerType, "Completed", startDate);
            check.FinishDate = startDate.AddHours(1);
            check.Outcome = outcome;

            return check;
        }

        private static IntegrityCheck CreateErroredIntegrityCheck(string checkerType, DateTime startDate)
        {
            return IntegrityCheck.CreateIntegrityCheck(checkerType, "Error", startDate);
        }

        private static IntegrityCheck CreateRunningIntegrityCheck(string checkerType, DateTime startDate)
        {
            return IntegrityCheck.CreateIntegrityCheck(checkerType, "Running", startDate);
        }
    }
}
