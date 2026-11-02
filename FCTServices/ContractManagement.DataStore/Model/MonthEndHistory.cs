namespace ContractManagement.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class MonthEndHistory
    {
        [Key]
        public int Id { get; set; }

        [Required, DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public DateTime StartTime { get; set; }

        public DateTime? EndTime { get; set; }
    }
}
