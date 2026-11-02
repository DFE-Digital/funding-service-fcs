namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.PaymentInstruction;

    public interface IAllocationPaymentInstructionReceivedEvent
    {
        AllocationPaymentInstruction AllocationPaymentInstruction { get; set; }
    }
}
