namespace OrganisationDomain.Implementation.Services
{
    using System.Collections.Generic;
    using Extensions;
    using Integration.DataStore.Model;
    using Integration.Entities;

    public static class OrgChangeDataComparer
    {
        public static IReadOnlyCollection<string> GetNotificationMessages(OrgSupplementaryData orgSupplementaryData, Organisation organisation)
        {
            string changeMessage = $" has been updated for provider {organisation.Ukprn} ({organisation.TradingName})";

            List<string> notificationMessages = new List<string>();

            if (orgSupplementaryData.CompanyNumber != organisation.CompanyRegistrationNumber)
            {
                notificationMessages.Add("Company Number" + changeMessage);
            }

            if (orgSupplementaryData.CharityNumber != organisation.CharityNumber)
            {
                notificationMessages.Add("Charity Number" + changeMessage);
            }

            var supplementaryAddressInOrgFormat = orgSupplementaryData.LegalAddress.ToDbAddress();
            if (!supplementaryAddressInOrgFormat.Equals(organisation.Address))
            {
                notificationMessages.Add("Address" + changeMessage);
            }

            return notificationMessages;
        }

        public static IReadOnlyCollection<string> GetNotificationMessages(OrgSupplementaryDataExtended orgSupplementaryData)
        {
            string changeMessage = $" has been updated for provider {orgSupplementaryData.Ukprn} ({orgSupplementaryData.TradingName})";

            List<string> notificationMessages = new List<string>();

            if (!string.IsNullOrEmpty(orgSupplementaryData.CompanyNumber))
            {
                notificationMessages.Add("Company Number" + changeMessage);
            }

            if (!string.IsNullOrEmpty(orgSupplementaryData.CharityNumber))
            {
                notificationMessages.Add("Charity Number" + changeMessage);
            }

            if (orgSupplementaryData.LegalAddress.HasValue)
            {
                notificationMessages.Add("Address" + changeMessage);
            }

            return notificationMessages;
        }

        public static IReadOnlyCollection<string> GetNotificationMessages(Organisation beforeUpdateOrganisation, Organisation afterUpdateOrganisation)
        {
            List<string> notificationMessages = new List<string>();

            if (beforeUpdateOrganisation.TradingName != afterUpdateOrganisation.TradingName)
            {
                notificationMessages.Add($"Name has been updated for provider {beforeUpdateOrganisation.Ukprn} ({beforeUpdateOrganisation.TradingName})");
            }

            string afterUpdateStatus = afterUpdateOrganisation.Status;

            if (beforeUpdateOrganisation.Status != afterUpdateStatus)
            {
                notificationMessages.Add($"Status has been updated to {afterUpdateStatus} for provider {beforeUpdateOrganisation.Ukprn} ({beforeUpdateOrganisation.TradingName})");
            }

            return notificationMessages;
        }

        public static bool AreObjectContentsTheSame(OrgSupplementaryData orgSupplementaryData, Organisation organisation)
        {
            return orgSupplementaryData.CharityNumber == organisation.CharityNumber &&
                   orgSupplementaryData.CompanyNumber == organisation.CompanyRegistrationNumber &&
                   orgSupplementaryData.LegalAddress.ToDbAddress().Equals(organisation.Address);
        }
    }
}