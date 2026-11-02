namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.DTOs;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SummarisedActualRepository : ISummarisedActualRepository
    {
        public IReadOnlyCollection<SummarisedActual> GetSummarisedActuals(SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.SummarisedActuals
                    .Where(sa =>
                        sa.CollectionType == groupKey.CollectionType &&
                        sa.CollectionReturnCode == groupKey.CollectionReturnCode &&
                        sa.OrganisationId == groupKey.OrganisationId &&
                        sa.FundingStreamPeriodCode == groupKey.FundingStreamPeriodCode &&
                        sa.UopCode == groupKey.UopCode)
                    .ToList();
            }
        }
    }
}