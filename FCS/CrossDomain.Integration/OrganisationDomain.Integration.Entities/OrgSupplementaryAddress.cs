namespace OrganisationDomain.Integration.Entities
{
    public class OrgSupplementaryAddress
    {
        public string Line1 { get; set; }

        public string Line2 { get; set; }

        public string Line3 { get; set; }

        public string Line4 { get; set; }

        public string Town { get; set; }

        public string County { get; set; }

        public string Postcode { get; set; }

        public bool HasValue => (Line1 ?? Line2 ?? Line3 ?? Line4 ?? Town ?? County ?? Postcode) != null;
    }
}