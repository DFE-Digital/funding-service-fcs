namespace OrganisationDomain.Endpoint.Xrm.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class ProviderNotificationRepository : IProviderNotificationRepository
    {
        private readonly IOrganizationService _organizationService;
        private readonly ITeamRepository _teamRepository;

        public ProviderNotificationRepository(IOrganizationService organizationService, ITeamRepository teamRepository)
        {
            _organizationService = organizationService;
            _teamRepository = teamRepository;
        }

        public void CreateProviderDetailsUpdatedNotification(int ukprn, string notification)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                EntityReference providerEntityReference = GetEntityReferenceForProvider(ukprn, xrmServiceContext);
                EntityReference teamEntityReference = _teamRepository.GetContractManagersTeamAsEntityReference(xrmServiceContext);

                sfa_notification sfaNotification = new sfa_notification
                {
                    sfa_NotificationType = new OptionSetValue((int)sfa_notificationtype.ProviderDetailsUpdated),
                    sfa_Name = $"Provider Details Updated - {ukprn}",
                    OwnerId = teamEntityReference,
                    sfa_Notification = notification,
                    sfa_provider = providerEntityReference,
                };
                xrmServiceContext.AddObject(sfaNotification);
                xrmServiceContext.SaveChanges();
            }
        }

        private static EntityReference GetEntityReferenceForProvider(int ukprn, XrmServiceContext xrmServiceContext)
        {
            Guid providerId = xrmServiceContext.AccountSet
                        .Where(a => a.sfa_UKPRN == ukprn.ToString())
                        .Select(a => a.Id)
                        .FirstOrDefault();
            return new EntityReference(Account.EntityLogicalName, providerId);
        }
    }
}
