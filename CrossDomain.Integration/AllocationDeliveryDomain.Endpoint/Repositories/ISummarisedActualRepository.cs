namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Collections.Generic;
    using AllocationDelivery.Messages.DTOs;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISummarisedActualRepository
    {
        IReadOnlyCollection<SummarisedActual> GetSummarisedActuals(SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo connectionInfo);
    }
}
