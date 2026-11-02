namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System.Collections.Generic;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISubnominalAggregationRepository
    {
        IReadOnlyCollection<SubnominalAggregationDto> GetSubnominalAggregationsForPaymentByFspAndPeriod(string fspCode, string period, ConnectionInfo connectionInfo);

        bool HasOutstandingPaymentsForAllocation(string allocationNumber, ConnectionInfo connectionInfo);
    }
}