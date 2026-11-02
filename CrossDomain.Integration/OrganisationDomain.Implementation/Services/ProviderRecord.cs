using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Implementation.Services
{
    public class ProviderRecord
    {
        public string UKPRN { get; set; }
        public string ProviderName { get; set; }
        public string ProviderStatus { get; set; }
        public DateTime? VerificationDate { get; set; }

        public LegalAddress LegalAddress { get; set; }

        public List<LegalAddress> TradingAddresses { get; set; }
        public List<ProviderContact> ProviderContacts { get; set; }
        public List<ProviderAlias> ProviderAliases { get; set; }
        public List<VerificationDetail> VerificationDetails { get; set; }
    }

    public class ProviderAlias
    {
        public string Name { get; set; }
    }

    public class LegalAddress
    {
        public string AddressType { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string Address4 { get; set; }
        public string Town { get; set; }
        public string County { get; set; }
        public string Postcode { get; set; }
    }
    public class ProviderContact
    {
        public ContactPersonalDetails ContactPersonalDetails { get; set; }

        public string ContactRole { get; set; }
        public string ContactTelephone1 { get; set; }
        public string ContactTelephone2 { get; set; }
        public string ContactEmail { get; set; }

        public DateTime? LastUpdated { get; set; }
    }
    public class ContactPersonalDetails
    {
        public int Id { get; set; }
        public string PersonNameTitle { get; set; }
        public string PersonGivenName { get; set; }
        public string PersonFamilyName { get; set; }
    }
    public class VerificationDetail
    {
        public string VerificationAuthority { get; set; }
        public string VerificationID { get; set; }
    }

}
