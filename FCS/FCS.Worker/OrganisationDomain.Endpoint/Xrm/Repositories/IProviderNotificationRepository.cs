namespace OrganisationDomain.Endpoint.Xrm.Repositories
{
    public interface IProviderNotificationRepository
    {
        void CreateProviderDetailsUpdatedNotification(int ukprn, string notification);
    }
}
