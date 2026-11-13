
namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Services
{
    extern alias Entities;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using paymentsAggregation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using paymentSchedule = Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    
    public interface IPaymentAggregationService
    {
        paymentsAggregation.Allocation CalculateAggregatedPayments(
            paymentSchedule.Allocation paymentSchedule,
            ConnectionInfo connectionInfo);
    }
}
