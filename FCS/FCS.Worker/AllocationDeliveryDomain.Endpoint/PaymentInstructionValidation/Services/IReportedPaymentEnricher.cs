namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IReportedPaymentEnricher
    {
        IReadOnlyCollection<EnrichedReportedActual> Enrich(ConnectionInfo connectionInfo, IReadOnlyCollection<ReportedActual> reportedPayments);
    }
}