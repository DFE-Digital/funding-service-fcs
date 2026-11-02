namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint
{
    using System.Collections.Generic;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IUpSertSubmoninalAggregationService
    {
        void UpSert(IReadOnlyCollection<AllocationPeriodWithExistingData> allocationPeriodsWithExistingData,
            Allocation allocation, ConnectionInfo connectionInfo);
    }
}