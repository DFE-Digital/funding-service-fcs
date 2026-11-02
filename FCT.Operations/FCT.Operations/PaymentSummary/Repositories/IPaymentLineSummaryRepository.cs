namespace FCT.Operations.PaymentSummary.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPaymentLineSummaryRepository
    {
        Task<IReadOnlyCollection<PaymentSummaryLine>> GetPaymentSummaryLines(ReportingPeriod reportingPeriod, ConnectionInfo connectionInfo);
        Task<IReadOnlyCollection<PaymentSummaryLine>> Get1619PaymentSummaryLines(ReportingPeriod reportingPeriod, ConnectionInfo connectionInfo);

    }
}