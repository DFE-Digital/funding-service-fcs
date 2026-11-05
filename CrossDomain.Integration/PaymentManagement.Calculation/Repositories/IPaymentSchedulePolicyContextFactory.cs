namespace PaymentManagement.Calculation.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public interface IPaymentSchedulePolicyContextFactory
    {
        IPaymentSchedulePolicyContext Create(ConnectionInfo connectionInfo);
    }
}
