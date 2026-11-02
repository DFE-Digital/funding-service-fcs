namespace OrganisationDomain.Implementation.Services
{
    public class OrgSupplementaryDataServiceResult
    {
        public OrgSupplementaryDataServiceResult(string companyRegNumber, bool isSuccessful)
            : this(companyRegNumber, null, isSuccessful)
        {
        }

        public OrgSupplementaryDataServiceResult(string companyRegNumber, string charityNumber, bool isSuccessful)
        {
            CompanyRegNumber = companyRegNumber;
            CharityNumber = charityNumber;
            IsSuccessful = isSuccessful;
            LegalAddress = new Address();
        }

        public string CompanyRegNumber { get; }

        public string CharityNumber { get;  }

        public bool IsSuccessful { get; }

        public Address LegalAddress { get; set; }

        public class Address
        {
            public string Line1 { get; set; }

            public string Line2 { get; set; }

            public string Line3 { get; set; }

            public string Line4 { get; set; }

            public string Town { get; set; }

            public string County { get; set; }

            public string Postcode { get; set; }
        }
    }
}
