namespace ContractManagement.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class IntegrityCheck
    {
        public static class StatusOptions
        {
            public const string Running = "Running";
            public const string Completed = "Completed";
            public const string Error = "Error";
        }

        public static class OutcomeOptions
        {
            public const string Success = "Success";
            public const string Failed = "Failed";
        }

        private IntegrityCheck()
        { 
        }

        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string CheckerType { get; private set; }

        [Required]
        public DateTime StartDate { get; set; }

        public DateTime? FinishDate { get; set; }

        [Required]
        [StringLength(20)]
        public string Status { get; set; }

        [StringLength(20)]
        public string Outcome { get; set; }

        [StringLength(250)]
        public string Link { get; set; }

        public static IntegrityCheck CreateIntegrityCheck(string checkerType, string status, DateTime startDate)
        {
            return new IntegrityCheck
            {
                CheckerType = checkerType,
                Status = status,
                StartDate = startDate
            };
        }
    }   
}
