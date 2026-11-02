namespace PaymentManagement.Calculation.Services
{
    using System.Collections.Generic;
    using Dtos;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IActualEnrichmentService
    {
        Option<IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo>>
            GetPreviousVersionActualsAndPaymentValuesIfPresent(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);
    }
}