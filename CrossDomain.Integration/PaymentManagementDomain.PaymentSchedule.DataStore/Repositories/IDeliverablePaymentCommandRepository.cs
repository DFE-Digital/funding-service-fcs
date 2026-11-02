namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System.Threading.Tasks;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IDeliverablePaymentCommandRepository
    {
        Task AddDeliverablePeriodIfNotPresent(string allocationNumber, int version, int deliverableCode,
            string period, ConnectionInfo connectionInfo, PeriodTypeCode periodTypeCode = PeriodTypeCode.CM);
    }
}