namespace PaymentManagement.Calculation
{
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public interface IPaymentValuesCalculationService
    {
        Allocation ProducePaymentScheduleOnApproval(allocationType allocation, ConnectionInfo connectionInfo);
        
        Allocation ProducePaymentScheduleOnActualsReceived(ContractAllocationActualsType allocation, ConnectionInfo connectionInfo);
    }
}