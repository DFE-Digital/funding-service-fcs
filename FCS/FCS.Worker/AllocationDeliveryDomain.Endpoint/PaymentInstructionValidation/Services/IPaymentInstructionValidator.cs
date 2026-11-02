namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    public interface IPaymentInstructionValidator
    {
        void Validate(EnrichedReportedActual paymentInstruction);
    }
}