namespace PaymentGenerationDomain.BusinessLogic
{
    using System.Collections.Generic;
    using Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAggregatedPaymentMapper
    {
        List<SubnominalAggregation> MapAggregatedPaymentCorporateSchemaToDbEntities(Allocation subnominalAggregationInCorporateSchema);

        List<Allocation> MapDbEntitiesToAggregatedPaymentCorporateSchema(List<SubnominalAggregation> subnominalAggregations, ConnectionInfo connectionInfo);
    }
}
