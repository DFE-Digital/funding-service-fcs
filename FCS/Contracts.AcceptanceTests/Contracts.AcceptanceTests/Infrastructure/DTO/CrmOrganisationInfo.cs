namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class CrmOrganisationInfo
    {
        public string Ukprn { get; set; }

        public string Upin { get; set; }

        public string Name { get; set; }

        public string Status { get; set; }

        public string CompanyNumber { get; set; }

        public string CharityNumber { get; set; }

        public AddressInfo Address { get; set; } = new AddressInfo();

        public class AddressInfo
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
