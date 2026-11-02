namespace OrganisationDomain.Integration.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class Organisation
    {
        public const string OrganisationPrefix = "ORG";

        [Key]
        public int OrganisationId { get; set; }

        [NotMapped]
        public string FormattedOrganisationId => $"{OrganisationPrefix}{OrganisationId:0000000}";

        [Index("IX_Organisation_Ukprn", 1, IsUnique = true)]
        public int Ukprn { get; set; }

        [Index("IX_Organisation_Upin", 1, IsUnique = true)]
        public int Upin { get; set; }

        public int SequenceNumber { get; set; }

        [Required, MaxLength(255)]
        public string TradingName { get; set; }

        [MaxLength(30)]
        public string CompanyRegistrationNumber { get; set; }

        [MaxLength(10)]
        public string CharityNumber { get; set; }

        [Required]
        public bool HasUkrlpBeenCalledSuccessfully { get; set; }

        [MaxLength(50)]
        public string Status { get; set; }

        [MaxLength(100)]
        public string Type { get; set; }

        public Address Address { get; set; } = new Address();

        public static int? ParseOrganisationId(string formattedOrganisationId)
        {
            // make sure format is correct
            if (false == formattedOrganisationId.StartsWith(OrganisationPrefix, StringComparison.CurrentCultureIgnoreCase))
            {
                return null;
            }

            // check that at least one digit is present
            if (formattedOrganisationId.Length == OrganisationPrefix.Length)
            {
                return null;
            }

            int organisationId;

            if (false == int.TryParse(formattedOrganisationId.Substring(OrganisationPrefix.Length), out organisationId))
            {
                return null;
            }

            return organisationId;
        }
    }
}
