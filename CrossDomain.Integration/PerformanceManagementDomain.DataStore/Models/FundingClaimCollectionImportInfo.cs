namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class FundingClaimCollectionImportInfo
    {
        private FundingClaimCollectionImportInfo()
        {
        }

        public FundingClaimCollectionImportInfo(string periodClaimType)
        {
            PeriodClaimType = periodClaimType;
        }

        /// <summary>
        /// This gets the PeriodClaimType - e.g. 1617-Final
        /// </summary>
        [Key]
        [MaxLength(50)]
        public string PeriodClaimType { get; private set; }

        public DateTime? ImportCompletedDate { get; set; }

        public int TotalRowsToImport { get; set; }
    }
}
