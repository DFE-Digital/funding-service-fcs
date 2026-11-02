namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation
{
    using System.ComponentModel.DataAnnotations;

    public class Period
    {
        [Required]
        public string PeriodTypeName { get; set; }
    }
}
