namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    public class CappingGroup
    {
        public int? CappingGroupId { get; set; }

        public bool? CapGroupOffsetFrom { get; set; }

        public bool? CapGroupOffsetTo { get; set; }
    }
}
