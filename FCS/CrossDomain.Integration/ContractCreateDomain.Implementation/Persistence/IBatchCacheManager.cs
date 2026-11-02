namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;
    using Implementation.Entities;

    public interface IBatchCacheManager
    {
        EntityCollection GetEntities(string batchId, CrmLookupType lookupType, IEnumerable<object> values, Func<EntityCollection> getDataFromCrm);
    }
}