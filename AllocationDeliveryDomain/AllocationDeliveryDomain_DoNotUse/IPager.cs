using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
using System.Collections.Generic;

namespace SFA.FCT.AllocationDeliveryDomain
{
    public interface IPager<T>
    {
        int PageSize{get;}

        //void Add(T entity);

        //bool Any();

        StoragePage<T> GetEntitiesForPage(int page);

        StoragePage<T> GetEntitiesForLatestPage(); 
    }
}