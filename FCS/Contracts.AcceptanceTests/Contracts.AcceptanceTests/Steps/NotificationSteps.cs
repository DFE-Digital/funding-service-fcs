namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using TechTalk.SpecFlow;
    using Utilities;

    [Binding]
    public class NotificationSteps
    {
        [Given(@"there are notifications of type '(.*)' owned by the user '(.*)' as follows")]
        [Then(@"there are notifications of type '(.*)' owned by the user '(.*)' as follows")]
        public void ThenThereAreNotificationsOfTypeOwnedByTheUserAsFollows(string notificationType, string userName, TransformedTable table)
        {
            var notificationsExpected = table.Rows.Select(row => new SimpleNotification(row["Status"],
             row["NotificationName"],
             row["NotificationText"])).ToList();

            sfa_notificationtype notificationtype = CrmNotificationRepository.ParseNotificationType(notificationType);
            IReadOnlyCollection<SimpleNotification> actualNotifications = null;

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                 actualNotifications = CrmNotificationRepository.GetNotificationsByTypeAndUser(notificationtype,
                    userName);

                return notificationsExpected.All(n => actualNotifications.Contains(n));
            },
               maxNumChecks: 30,
               waitIntervalSeconds: 3);

            Assert.IsTrue(checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime(),
                $"We have not found the notifications expected for '{notificationType}' and '{userName}' " + notificationsExpected.FirstOrDefault(n => !actualNotifications.Contains(n)));
        }

        [Then(@"there are '(.*)' notifications of type '(.*)' owned by user '(.*)' which match the following")]
        [Then(@"there is '(.*)' notification of type '(.*)' owned by user '(.*)' which match the following")]
        [Then(@"there is '(.*)' notification of type '(.*)' owned by user '(.*)' which matches the following")]
        public void ThenThereAreIdenticalNotificationsOfTypeOwnedByTheUserAsFollows(int count, string notificationType, string userName, TransformedTable table)
        {
            var notificationsExpected = table.Rows.Select(row => new SimpleNotification(row["Status"],
             row["NotificationName"],
             row["NotificationText"])).ToList();

            sfa_notificationtype notificationtype = CrmNotificationRepository.ParseNotificationType(notificationType);
            IReadOnlyCollection<SimpleNotification> actualNotifications = null;

            int actualCount = 0;
            notificationsExpected.ForEach(expected =>
            {
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                    {
                        actualNotifications = CrmNotificationRepository.GetNotificationsByTypeAndUserAndName(notificationtype,
                            userName,
                            expected.NotificationName
                        );
                        actualCount = actualNotifications.Count(an => an.Equals(expected));

                        return actualCount == count;
                    },
                    maxNumChecks: 30,
                    waitIntervalSeconds: 3);

                Assert.IsTrue(checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime(),
                    $"Test has not found the expected number of notifications for '{notificationType}' and '{userName}'. ActualCount: {actualCount}, " + expected);
            });
            
        }

        [Given(@"there are notifications of type '(.*)' owned by the '(.*)' as follows")]
        [Then(@"there are notifications of type '(.*)' owned by the '(.*)' as follows")]
        public void ThenThereAreNotificationsOfTypeOwnedByTheAsFollows(string notificationType, string owningTeam, Table table)
        {
            sfa_notificationtype notificationtype = CrmNotificationRepository.ParseNotificationType(notificationType);

            EntityReference owningTeamEntityReference = CrmTeamRepository.GetTeamEntityReference(owningTeam);

            IReadOnlyCollection<SimpleNotification> notificationsInCrm;

            var notificationsExpected = table.Rows.Select(row => new SimpleNotification(row["Status"],
              row["NotificationName"],
              row["NotificationText"])).ToList();

            IEnumerable<SimpleNotification> notFoundNotifications = Enumerable.Empty<SimpleNotification>();

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                notificationsInCrm = CrmNotificationRepository.GetNotificationsByTypeAndOwnerTeam(notificationtype,
                    owningTeamEntityReference);

                notFoundNotifications = notificationsExpected.Where(expected => !notificationsInCrm.Contains(expected)).ToList();

                return !notFoundNotifications.Any();
            },
                maxNumChecks: 30,
                waitIntervalSeconds: 3);

            Assert.IsTrue(checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime(),
                $"We have not found the notifications expected for '{notificationType}' and '{owningTeam}' {notFoundNotifications.FirstOrDefault()}");
        }

        [Then(@"there are '(.*)' notifications of type '(.*)' owned by team '(.*)' which match the following")]
        [Then(@"there is '(.*)' notification of type '(.*)' owned by team '(.*)' which matches the following")]
        public void ThenThereAreNotificationsOfTypeOwnedByWhichMatchTheFollowing(int expectedNotificationCount, string notificationType, string owningTeam, Table table)
        {
            if (table.RowCount != 1)
            {
                Assert.Fail("Step is not intended for use with multiple table rows");
            }

            sfa_notificationtype notificationtype = CrmNotificationRepository.ParseNotificationType(notificationType);

            EntityReference owningTeamEntityReference = CrmTeamRepository.GetTeamEntityReference(owningTeam);

            SimpleNotification expectedNotification = table.Rows
                .Select(row => new SimpleNotification(row["Status"], row["NotificationName"], row["NotificationText"]))
                .Single();

            CheckResultPoller checkResultPoller = new CheckResultPoller(() =>
            {
                IReadOnlyCollection<SimpleNotification> actualNotifications =
                    CrmNotificationRepository.GetNotificationsByTypeAndOwnerTeam(notificationtype, owningTeamEntityReference);

                int matchingActualNotificationCount = actualNotifications.Count(n => n == expectedNotification);

                return matchingActualNotificationCount == expectedNotificationCount;
            }, 20, 6);

            bool foundExpectedNotifications = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.IsTrue(foundExpectedNotifications, $"We have not found {expectedNotificationCount} expected notification(s) for '{notificationType}' and '{owningTeam}': {expectedNotification}");
        }
    }
}
