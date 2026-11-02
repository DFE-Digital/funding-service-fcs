namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Repositories
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public interface ICrmNotificationRepository
    {
        Guid CreateNotificationForUser(sfa_notificationtype notificationType, string notificationName, string notificationText, Guid userId);
    }
}