namespace PaymentManagement.Calculation.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class PaymentSchedulePolicyContextFactory : IPaymentSchedulePolicyContextFactory
    {
        public IPaymentSchedulePolicyContext Create(ConnectionInfo connectionInfo)
        {
            return new PaymentSchedulePolicyContext(connectionInfo);
        }
    }
}
