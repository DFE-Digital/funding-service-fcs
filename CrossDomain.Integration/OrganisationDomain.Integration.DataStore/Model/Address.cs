namespace OrganisationDomain.Integration.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [ComplexType]
    public class Address
    {
        [MaxLength(100)]
        public string Line1 { get; set; }

        [MaxLength(100)]
        public string Line2 { get; set; }

        [MaxLength(100)]
        public string Line3 { get; set; }

        [MaxLength(100)]
        public string Line4 { get; set; }

        [MaxLength(100)]
        public string Town { get; set; }

        [MaxLength(100)]
        public string County { get; set; }

        [MaxLength(8)]
        public string Postcode { get; set; }

        public bool HasValue => (Line1 ?? Line2 ?? Line3 ?? Line4 ?? Town ?? County ?? Postcode) != null;

        public override bool Equals(object obj)
        {
            return obj is Address address &&
                   Line1 == address.Line1 &&
                   Line2 == address.Line2 &&
                   Line3 == address.Line3 &&
                   Line4 == address.Line4 &&
                   Town == address.Town &&
                   County == address.County &&
                   Postcode == address.Postcode;
        }
    }
}
