namespace SFA.FCT.CrossDomain.Integration.Events
{
    public interface IAllocationPaymentsChangedEvent
    {
        string AllocationNumber { get; set; }

        bool HasOutstandingPayments { get; set; }
    }
}
