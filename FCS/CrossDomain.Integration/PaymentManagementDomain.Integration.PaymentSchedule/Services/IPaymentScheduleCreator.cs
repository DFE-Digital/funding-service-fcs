namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using CrossDomain.Integration.Entities.AllocationActuals;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.DeliveryAllocation;

    public interface IPaymentScheduleCreator
    {
        PaymentScheduleWithPayments CreatePaymentScheduleFromAllocation(allocationType deliveryAllocation, ConnectionInfo connectionInfo);

        PaymentScheduleWithPayments CreatePaymentScheduleFromActuals(ContractAllocationActualsType allocationActuals, ConnectionInfo connectionInfo);
    }
}