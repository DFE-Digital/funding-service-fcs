namespace Operations.Web.Notifiers
{
    using System;
    using System.Threading.Tasks;
    using Dtos;
    using OrganisationDomain.Integration.DataStore.Repositories;

    public class ProviderNotYetRetrievedFromUkrlpNotifier : INotifier
    {
        private readonly IOrganisationRepository _organisationRepository;

        public ProviderNotYetRetrievedFromUkrlpNotifier(IOrganisationRepository organisationRepository)
        {
            _organisationRepository = organisationRepository;
        }

        public async Task<Notification> GetNotification()
        {
            const string notificationName = "Provider Information Missing from Ukrlp";
            try
            {
                int count = await _organisationRepository.GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp();

                return count == 0 ? null : new Notification(count.ToString(), notificationName, NotificationType.Error);
            }
            catch (Exception ex)
            {
                return new Notification(ex.Message, notificationName, NotificationType.Fatal);
            }
        }
    }
}