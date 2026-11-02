namespace FCT.Operations.PaymentSummary.Services
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPaymentSummaryReportService
    {
        Task<bool> ShouldGeneratePaymentSummaryReport(DateTime currentTime, ConnectionInfo connectionInfo);

        IReadOnlyCollection<PaymentSummaryLine> FilterOutUnnecessaryLines(IReadOnlyCollection<PaymentSummaryLine> lines);

        IReadOnlyCollection<PaymentSummaryLine> FilterOutUnnecessaryLines1619(IReadOnlyCollection<PaymentSummaryLine> lines);
    }
}