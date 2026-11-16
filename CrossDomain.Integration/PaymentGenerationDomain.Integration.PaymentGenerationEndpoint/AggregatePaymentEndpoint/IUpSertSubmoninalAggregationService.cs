namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint
{
    extern alias Entities;
    using System.Collections.Generic;
    using DTOs;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IUpSertSubmoninalAggregationService
    {
        void UpSert(IReadOnlyCollection<AllocationPeriodWithExistingData> allocationPeriodsWithExistingData,
            Allocation allocation, ConnectionInfo connectionInfo);
    }
}