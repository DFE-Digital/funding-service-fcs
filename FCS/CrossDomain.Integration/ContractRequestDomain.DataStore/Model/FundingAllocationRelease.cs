namespace SFA.FCT.ContractRequestDomain.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using Extensions;

    public enum FundingAllocationReleaseStatus
    {
        NotSet,
        ReleaseInProgress,
        Released
    }

    public class FundingAllocationRelease
    {
        public FundingAllocationRelease()
        {

        }

        public FundingAllocationRelease(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriodName, string releaseStatus)
        {
            ReleaseGroupGroupId = releaseGroupGroupId;
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
            ReleaseStatus = releaseStatus;
        }

        [Key]
        [Column(Order = 1)]
        public int ReleaseGroupGroupId { get; private set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(100)]
        public string FundingTypeCode { get; private set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(100)]
        public string FundingPeriodName { get; private set; }

        [Key]
        [Column(Order = 4)]
        [StringLength(100)]
        public string ReleaseStatus { get; set; }

        [NotMapped]
        public FundingAllocationReleaseStatus FundingTypeFundingPeriodReleaseStatus
        {
            get
            {
                if (ReleaseStatus.HasValue())
                {
                    return (FundingAllocationReleaseStatus)Enum.Parse(typeof(FundingAllocationReleaseStatus), ReleaseStatus);
                }

                return FundingAllocationReleaseStatus.NotSet;
            }
            set => ReleaseStatus = (value != FundingAllocationReleaseStatus.NotSet) ? value.ToString() : null;
        }
    }
}