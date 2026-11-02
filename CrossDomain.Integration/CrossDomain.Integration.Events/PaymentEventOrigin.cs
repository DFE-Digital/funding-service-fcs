namespace SFA.FCT.CrossDomain.Integration.Events
{
    public enum PaymentEventOrigin
    {
        NotSet,
        AllocationDeliveryCommenced,
        AllocationActualsVerified,
        FundingClaimReconciliationPublished,
        PaymentInstructionReceived,
        AllocationActualsUpdated
    }
}