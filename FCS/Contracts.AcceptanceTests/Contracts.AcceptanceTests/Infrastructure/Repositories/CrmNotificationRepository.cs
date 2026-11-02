namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using DTO;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Services;

    public static class CrmNotificationRepository
    {
        public static IReadOnlyCollection<SimpleNotification> GetNotificationsByTypeAndOwnerTeam(
            sfa_notificationtype notificationtype, EntityReference ownerTeam)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_notificationSet.Where(n => n.sfa_NotificationType.Value == (int) notificationtype &&
                                                       n.OwningTeam.Id == ownerTeam.Id)
                                                       .AsEnumerable()
                                                       .Select(n => new SimpleNotification(((sfa_notification_statuscode)n.statuscode.Value).ToString(), n.sfa_Name, n.sfa_Notification)).ToList();
            }
        }

        public static IReadOnlyCollection<SimpleNotification> GetNotificationsByTypeAndUser(
           sfa_notificationtype notificationtype, string ownerUserFullName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from n in context.sfa_notificationSet
                    join u in context.SystemUserSet on n.OwnerId.Id equals u.Id
                    where n.sfa_NotificationType.Value == (int) notificationtype
                          && u.FullName == ownerUserFullName
                    select (new SimpleNotification(((sfa_notification_statuscode) n.statuscode.Value).ToString(),
                            n.sfa_Name, n.sfa_Notification))).ToList();
            }
        }

        public static IReadOnlyCollection<SimpleNotification> GetNotificationsByTypeAndUserAndName(
            sfa_notificationtype notificationtype, string ownerUserFullName, string name)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from n in context.sfa_notificationSet
                    join u in context.SystemUserSet on n.OwnerId.Id equals u.Id
                    where n.sfa_NotificationType.Value == (int)notificationtype
                          && u.FullName == ownerUserFullName
                          && n.sfa_Name == name
                    select (new SimpleNotification(((sfa_notification_statuscode)n.statuscode.Value).ToString(),
                        n.sfa_Name, n.sfa_Notification))).ToList();
            }
        }

        public static IReadOnlyCollection<SimpleNotification> GetNotificationsByTypeAndOwnerTeamAndProvider(
           sfa_notificationtype notificationtype, EntityReference ownerTeam, EntityReference providerEntityReference)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_notificationSet.Where(n => n.sfa_NotificationType.Value == (int)notificationtype &&
                                                       n.OwningTeam.Id == ownerTeam.Id &&
                                                       n.sfa_provider.Id == providerEntityReference.Id)
                                                       .AsEnumerable()
                                                       .Select(n => new SimpleNotification(((sfa_notification_statuscode)n.statuscode.Value).ToString(), n.sfa_Name, n.sfa_Notification)).ToList();
            }
        }

        public static void DeleteNotificationsForUkprn(string ukprn)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            GetNotificationIdsForUkprn(ukprn).ForEach(notificationId =>
            {
                organizationService.Delete(sfa_notification.EntityLogicalName, notificationId);
                CrmReplicatedRepository.DeleteNotificationsForNotificationId(notificationId);
            });
        }

        public static void DeleteNotificationsThatContainUkprnInText(string ukprn)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            GetNotificationIdsForUkprnInText(ukprn).ForEach(notificationId =>
            {
                organizationService.Delete(sfa_notification.EntityLogicalName, notificationId);
                CrmReplicatedRepository.DeleteNotificationsForNotificationId(notificationId);
            });
        }

        public static sfa_notificationtype ParseNotificationType(string notificationType)
        {
            string noSpaceNotificationType = notificationType.Replace(" ", string.Empty).Replace("-", string.Empty);

            return (sfa_notificationtype)Enum.Parse(typeof(sfa_notificationtype), noSpaceNotificationType);
        }

        public static void DeleteNotificationsByTypeForUkprn(string notificationType, string ukprn)
        {
            var connection = CrmConnectionFactory.GetConnection();

            sfa_notificationtype notificationTypeEnum = ParseNotificationType(notificationType);

            using (var xrmContext = new XrmServiceContext(connection))
            {
                var c = xrmContext.sfa_notificationSet.Select(s => s.Id).ToList();
                IReadOnlyCollection<Guid> notificationIds =
                    xrmContext.sfa_notificationSet
                        .Where(n => n.sfa_NotificationType.Value == (int)notificationTypeEnum
                            && n.sfa_Notification.Contains(ukprn))
                        .Select(n => n.sfa_notificationId.Value)
                        .ToList();

                notificationIds.ForEach(n => connection.Delete(sfa_notification.EntityLogicalName, n));

            }
        }

        private static IReadOnlyCollection<Guid> GetNotificationIdsForUkprn(string ukprn)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from n in context.sfa_notificationSet
                    join a in context.AccountSet on n.sfa_provider.Id equals a.AccountId.Value
                    where a.sfa_UKPRN == ukprn
                    select n.sfa_notificationId.Value).ToList();
            }
        }

        private static IReadOnlyCollection<Guid> GetNotificationIdsForUkprnInText(string ukprn)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_notificationSet.Where(n => n.sfa_Notification.Contains(ukprn))
                        .Select(n => n.Id)
                        .ToList();
            }
        }
    }
}
