namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using DataStore.Model;
    using System.Collections.Generic;

    public interface IClosedCollectionRepository
    {
        IReadOnlyCollection<ClosedCollection> GetClosedCollections();
    }
}