namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos
{
    using System;

    public class CrmContractStatusInfo
    {
        public CrmContractStatusInfo(string number, string status, string subStatus, bool latestVersion, int version, int subVersion, DateTime createdDate, string crmEntityId, string masterContractNumber, string fundingPeriod, string fundingType, bool lastApprovedVersion, string amendmentType)
        {
            Number = number;
            Status = status;
            SubStatus = subStatus;
            LatestVersion = latestVersion;
            Version = version;
            SubVersion = subVersion;
            CreatedDate = createdDate;
            CrmEntityId = crmEntityId;
            MasterContractNumber = masterContractNumber;
            FundingPeriod = fundingPeriod;
            FundingType = fundingType;
            LastApprovedVersion = lastApprovedVersion;
            AmendmentType = amendmentType;
        }

        public string Number { get; }
        public string Status { get; set; }
        public string SubStatus { get; set; }
        public bool LatestVersion { get; }
        public int Version { get; }
        public int SubVersion { get; }
        public DateTime CreatedDate { get; }
        public string CrmEntityId { get; }
        public string MasterContractNumber { get; }
        public string FundingPeriod { get; }
        public string FundingType { get; }
        public bool LastApprovedVersion { get; }

        public string AmendmentType { get; }

        public bool IsDraft => Status == "Draft";
        public bool IsApproved => Status == "Approved";

        public override string ToString()
        {
            return $"{{Number: {Number}, Status: {Status}, SubStatus: {SubStatus}, LatestVersion: {LatestVersion}, Version: {Version}, SubVersion: {SubVersion}, CreatedDate: {CreatedDate}, CrmEntityId: {CrmEntityId}, Master: {MasterContractNumber}, Amendment Type: {AmendmentType}}}";
        }
    }
}