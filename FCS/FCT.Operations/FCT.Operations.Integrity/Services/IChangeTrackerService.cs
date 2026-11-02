namespace SFA.FCT.Operations.Integrity.Services
{
    using DTOs;

    public interface IChangeTrackerService
    {
        ChangeTrackedDeliverablePayments GetDeliverablePaymentChanges(long? changeTrackingCurrentVersionOverride);
    }
}