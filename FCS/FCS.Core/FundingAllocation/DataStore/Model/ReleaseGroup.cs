namespace FundingAllocation.DataStore.Model
{
    using System;
    using System.Collections.Generic;

    public enum ReleaseGroupStatus
    {
        AwaitingRelease,
        ReleaseInProgress,
        Released
    }

    public class ReleaseGroup
    {
        private ReleaseGroup()
        {
        }

        public ReleaseGroup(string fundingTypeCode, string fundingPeriodCode, string fspGroupCode, 
            string contractType, Guid crmEntityId, string releaseGroupName)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            FSPGroupCode = fspGroupCode;
            ContractType = contractType;
            CrmEntityId = crmEntityId;
            ReleaseGroupName = releaseGroupName;
            ReleaseGroupStatus = ReleaseGroupStatus.AwaitingRelease;
        }

        public int Id { get; private set; }

        public string FundingTypeCode { get; private set; }

        public string FundingPeriodCode { get; private set; }

        public string FSPGroupCode { get; private set; }

        public string ContractType { get; private set; }

        public Guid CrmEntityId { get; private set; }

        public string ReleaseGroupName { get; private set; }

        public string Status { get; set; }

        public ReleaseGroupStatus ReleaseGroupStatus
        {
            get => (ReleaseGroupStatus) Enum.Parse(typeof(ReleaseGroupStatus), Status);
            set => Status = value.ToString();
        }

        public DateTime? ReleasedDate { get; set; }

        public List<FundingAllocation> FundingAllocations { get; private set; } = new List<FundingAllocation>();
    }
}