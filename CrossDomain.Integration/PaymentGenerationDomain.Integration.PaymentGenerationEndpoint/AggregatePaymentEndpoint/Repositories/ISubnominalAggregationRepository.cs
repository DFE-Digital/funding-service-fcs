namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories
{
    extern alias Entities;
    using System.Collections.Generic;
    using DataStore.Model;
    using DTOs;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISubnominalAggregationRepository
    {
        IReadOnlyCollection<SimpleSubnominalAggregation> GetSubnominalAggregations(
            string allocationNumber,
            string period,
            ConnectionInfo connectionInfo);

        void Update(SimpleSubnominalAggregation subnominalAggregation, ConnectionInfo connectionInfo);

        void Insert(SubnominalAggregation subnominalAggregation, ConnectionInfo connectionInfo);
    }
}