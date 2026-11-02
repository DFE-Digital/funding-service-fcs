namespace PaymentGenerationDomain.BusinessLogic
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;

    public interface IXrmAllocationManager
    {
        void UpdatePaymentTransmissionStatus(Allocation allocation, bool value);
    }
}
