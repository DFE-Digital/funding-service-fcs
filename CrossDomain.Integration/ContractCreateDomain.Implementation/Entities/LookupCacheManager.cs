namespace ContractCreateDomain.Implementation.Entities
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Caching;
    using Microsoft.Xrm.Sdk;

    public class LookupCacheManager
    {
        // Expiration time of the cache in minutes.
        private const double CacheExpiration = 30;
        private static readonly object CacheLock = new object();
        private static ObjectCache cache = MemoryCache.Default;

        public IDictionary<int, EntityCollection> GetCachedData(string batchId)
        {
            IDictionary<int, EntityCollection> cacheData = cache[batchId] as IDictionary<int, EntityCollection>;

            if (cacheData == null)
            {
                SetCacheData(batchId, new Dictionary<int, EntityCollection>());
                cacheData = cache[batchId] as IDictionary<int, EntityCollection>;
            }

            return cacheData;
        }

        public void SetCacheData(string batchId, Dictionary<int, EntityCollection> data, double cacheTimeout = CacheExpiration)
        {
            lock (CacheLock)
            {
                cache.Set(batchId, data, new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(cacheTimeout) });
            }
        }
    }
}