namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Repositories
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;

    public class CrmNotificationRepository : ICrmNotificationRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmNotificationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Guid CreateNotificationForUser(sfa_notificationtype notificationType, string notificationName, string notificationText, Guid userId)
        {
            sfa_notification notification = new sfa_notification
            {
                sfa_NotificationType = new OptionSetValue((int)notificationType),
                sfa_Name = notificationName,
                sfa_Notification = notificationText,
                OwnerId = new EntityReference(SystemUser.EntityLogicalName, userId)
            };

            return _organizationService.Create(notification);
        }
    }
}