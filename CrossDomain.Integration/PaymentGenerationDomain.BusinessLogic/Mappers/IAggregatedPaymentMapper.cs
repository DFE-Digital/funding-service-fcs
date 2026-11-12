namespace PaymentGenerationDomain.BusinessLogic
{
    extern alias Entities;
    
    using System.Collections.Generic;
    using Integration.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAggregatedPaymentMapper
    {
        List<SubnominalAggregation> MapAggregatedPaymentCorporateSchemaToDbEntities(Allocation subnominalAggregationInCorporateSchema);

        List<Allocation> MapDbEntitiesToAggregatedPaymentCorporateSchema(List<SubnominalAggregation> subnominalAggregations, ConnectionInfo connectionInfo);
    }
}
