namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Services
{
    using CrossDomain.Integration.Entities.Data;
    using paymentsAggregation = CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using paymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public interface IPaymentAggregationService
    {
        paymentsAggregation.Allocation CalculateAggregatedPayments(paymentSchedule.Allocation paymentSchedule, ConnectionInfo connectionInfo);
    }
}
