namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.PaymentSchedule;

    public class PaymentScheduleEvent : IDeferrableEvent
    {
        public Allocation PaymentScheduleAllocation { get; set; }

        public PaymentEventOrigin PaymentEventOrigin { get; set; }

        public int TimesMessageDeferred { get; set; }

        public override string ToString()
        {
            return $"PaymentScheduleEvent - Contract: {PaymentScheduleAllocation.ContractNumber}, Version: {PaymentScheduleAllocation.VersionNumber}, " +
                   $"PaymentEventOrigin: {PaymentEventOrigin}, ContractAllocationNumber: {PaymentScheduleAllocation.AllocationNumber}";
        }
    }
}
