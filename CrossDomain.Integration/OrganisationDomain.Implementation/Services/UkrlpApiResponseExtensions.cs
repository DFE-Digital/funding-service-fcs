using OrganisationDomain.Integration.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Implementation.Services
{
    public static class UkrlpApiResponseExtensions
    {
        private const string CompanyRegistrationNumberVerificationAuthority = "COMPANY";
        private const string CharityNumberVerificationAuthority = "CHARITY";

        public static OrgSupplementaryDataServiceResult ToOrgSupplementaryDataServiceResult(
            this List<ProviderRecord> providers)
        {
            if (providers != null && providers.Any())
            {
                var provider = providers.First();

                string companyRegNumber = GetVerificationDetails(provider, CompanyRegistrationNumberVerificationAuthority);
                string charityNumber = GetVerificationDetails(provider, CharityNumberVerificationAuthority);

                var legalAddress = provider.LegalAddress;

                return new OrgSupplementaryDataServiceResult(companyRegNumber, charityNumber, true)
                {
                    LegalAddress = new OrgSupplementaryDataServiceResult.Address
                    {
                        Line1 = legalAddress?.Address1,
                        Line2 = legalAddress?.Address2,
                        Line3 = legalAddress?.Address3,
                        Line4 = legalAddress?.Address4,
                        Town = legalAddress?.Town,
                        County = legalAddress?.County,
                        Postcode = legalAddress?.Postcode
                    }
                };
            }

            return new OrgSupplementaryDataServiceResult(null, false);
        }

        public static IReadOnlyCollection<OrgSupplementaryData> ToOrgSupplementaryDataCollection(
            this List<ProviderRecord> providers)
        {
            if (providers != null && providers.Any())
            {
                return providers.Select(MapToOrgSupplementaryData).ToList();
            }

            return new List<OrgSupplementaryData>();
        }

        private static OrgSupplementaryData MapToOrgSupplementaryData(ProviderRecord provider)
        {
            return new OrgSupplementaryData(
                int.Parse(provider.UKPRN),
                GetVerificationDetails(provider, CompanyRegistrationNumberVerificationAuthority),
                GetVerificationDetails(provider, CharityNumberVerificationAuthority),
                GetLegalAddress(provider)
            );
        }

        private static string GetVerificationDetails(ProviderRecord provider, string authority)
        {
            return provider?.VerificationDetails?
                .FirstOrDefault(v => v.VerificationAuthority == authority)?.VerificationID;
        }

        private static OrgSupplementaryAddress GetLegalAddress(ProviderRecord provider)
        {
            var addr = provider?.LegalAddress;

            return new OrgSupplementaryAddress
            {
                Line1 = addr?.Address1,
                Line2 = addr?.Address2,
                Line3 = addr?.Address3,
                Line4 = addr?.Address4,
                Town = addr?.Town,
                County = addr?.County,
                Postcode = addr?.Postcode
            };
        }
    }
}
