namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
{
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;

    public class CrmFundingAllocationHistory
    {
        public CrmFundingAllocationHistory(string fundingId, string action, string completedBy, int newStatus, int newSubStatus, int previousStatus, int previousSubStatus, string comments)
        {
            FundingId = fundingId;
            Action = action;
            CompletedBy = completedBy;
            NewStatus = newStatus;
            NewSubStatus = newSubStatus;
            PreviousStatus = previousStatus;
            PreviousSubStatus = previousSubStatus;
            Comments = comments;
        }

        public string FundingId { get; }
        public string Action { get; }
        public string CompletedBy { get; }
        public int NewStatus { get; }
        public int NewSubStatus { get; }
        public int PreviousStatus { get; }
        public int PreviousSubStatus { get; }
        public string Comments { get; }

        public string NewStatusString => ((sfa_FundingAllocationStatus) NewStatus).ToString();
        public string NewSubStatusString => ((sfa_FundingAllocationSubStatus)NewSubStatus).ToString();
        public string PreviousStatusString =>
            PreviousStatus.GetEnumValueAsStringOrDefault<sfa_FundingAllocationStatus>("?");
        public string PreviousSubStatusString =>
            PreviousStatus.GetEnumValueAsStringOrDefault<sfa_FundingAllocationSubStatus>("?");
    }
}
