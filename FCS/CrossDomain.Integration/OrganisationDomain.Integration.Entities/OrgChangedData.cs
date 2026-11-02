namespace OrganisationDomain.Integration.Entities
{
    using System.Collections.Generic;

    public class OrgChangedData
    {
        public OrgChangedData(OrgSupplementaryData orgSupplementaryData, IReadOnlyCollection<string> notificationMessages)
        {
            OrgSupplementaryData = orgSupplementaryData;
            NotificationMessages = notificationMessages;
        }

        public IReadOnlyCollection<string> NotificationMessages { get; }

        public OrgSupplementaryData OrgSupplementaryData { get; }
    }
}