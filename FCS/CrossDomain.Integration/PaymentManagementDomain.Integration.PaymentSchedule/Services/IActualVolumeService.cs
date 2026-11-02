namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using CrossDomain.Integration.Entities.Data;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;


    public interface IActualVolumeService
    {
        void UpdatePaymentScheduleWithPreviousVersionVolume(Allocation paymentScheduleForAllocation, ConnectionInfo connectionInfo);
    }
}