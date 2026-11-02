namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Adapters
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using ClosedCollection = AllocationDelivery.Messages.DTOs.ClosedCollection;

    public interface IDcAdapter
    {
        Task<IReadOnlyCollection<ClosedCollection>> GetClosedCollectionsSince(DateTime dateFrom);

        Task<IReadOnlyCollection<SummarisedActual>> GetClosedCollectionsPage(string collectionType, string collectionReturnCode, int pageNumber, int pageSize);
    }
}
