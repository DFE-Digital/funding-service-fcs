namespace OrganisationDomain.Integration.Messages.Commands
{
    public class CreateProviderUpdatedNotificationCommand
    {
        public int Ukprn { get; set; }

        public string Notification { get; set; }

        public override string ToString()
        {
            return $"Ukprn: {Ukprn}, Notification: {Notification}";
        }
    }
}
