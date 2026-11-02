namespace OrganisationDomain.Integration.Entities
{
    public class OrgSupplementaryData
    {
        public OrgSupplementaryData(int ukprn, string companyNumber, string charityNumber, OrgSupplementaryAddress address)
        {
            Ukprn = ukprn;
            CompanyNumber = companyNumber;
            CharityNumber = charityNumber;
            LegalAddress = address;
        }

        public int Ukprn { get; }

        public string CompanyNumber { get; }

        public string CharityNumber { get; }

        public OrgSupplementaryAddress LegalAddress { get; set; }

        public override bool Equals(object obj)
        {
            OrgSupplementaryData other = obj as OrgSupplementaryData;

            return Ukprn == other?.Ukprn;
        }

        public override int GetHashCode()
        {
            return Ukprn;
        }

        public override string ToString()
        {
            return $"Ukprn: {Ukprn}, CompanyNumber: {CompanyNumber}, CharityNumber: {CharityNumber}";
        }
    }
}