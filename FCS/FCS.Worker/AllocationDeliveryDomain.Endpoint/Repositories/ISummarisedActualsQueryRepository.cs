namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.DTOs;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISummarisedActualsQueryRepository
    {
        Task<int> GetCountForCollectionReturn(string collectionType, string collectionReturnCode,
            ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<ActualOrgFspGroupKeyResult>> GetOrgFspGroups(string collectionType,
            string collectionReturnCode, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<SummarisedActual>> GetSummarisedActuals(SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo connectionInfo);
    }
}
