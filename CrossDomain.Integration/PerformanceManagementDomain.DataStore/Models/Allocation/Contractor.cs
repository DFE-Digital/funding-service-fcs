namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation
{
    using System.ComponentModel.DataAnnotations;

    public class Contractor
    {
        [Required]
        [MaxLength(20)]
        public string OrganisationIdentifier { get; set; }

        [Required]
        public int UKPRN { get; set; }

        [Required]
        [MaxLength(100)]
        public string LegalName { get; set; }
    }
}
