namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    public interface IActualValueNullResetService
    {
        Allocation ConditionallyResetActualValuesToNullOnApproval(Allocation allocation, ConnectionInfo connectionInfo);
    }
}