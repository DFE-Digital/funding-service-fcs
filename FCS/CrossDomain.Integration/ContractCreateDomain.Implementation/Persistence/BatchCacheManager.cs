namespace SFA.FCT.ContractCreateDomain.Implementation
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Caching;
    using Microsoft.Xrm.Sdk;
    using Entities;
    using Persistence;

    public class BatchCacheManager : IBatchCacheManager
    {
        // Expiration time of the cache in minutes.
        private const double CacheExpiration = 30;
        private readonly MemoryCache _objectCache = MemoryCache.Default;

        public EntityCollection GetEntities(string batchId, CrmLookupType lookupType, IEnumerable<object> values, Func<EntityCollection> getDataFromCrm)
        {
            EntityCollection entityCollection;
            if (!string.IsNullOrEmpty(batchId))
            {
                IDictionary<LookupCacheCriteria, EntityCollection> cachedData = GetCachedData<LookupCacheCriteria>(batchId);
                LookupCacheCriteria lookupCacheCriteria = new LookupCacheCriteria
                {
                    LookupType = lookupType,
                    LookupValues = values
                };

                if (cachedData.ContainsKey(lookupCacheCriteria))
                {
                    entityCollection = cachedData[lookupCacheCriteria];
                }
                else
                {
                    entityCollection = getDataFromCrm();
                    cachedData[lookupCacheCriteria] = entityCollection;
                }
            }
            else
            {
                entityCollection = getDataFromCrm();
            }

            return entityCollection;
        }

        private IDictionary<TKey, EntityCollection> GetCachedData<TKey>(string batchId)
        {
            var lazyLookupDictionary = new Lazy<IDictionary<TKey, EntityCollection>>(CreateLookupDictionary<TKey>);

            // return the existing item or adds the new value if it doesn't exist
            string key = batchId + typeof(TKey);
            var value = (Lazy<IDictionary<TKey, EntityCollection>>)_objectCache.AddOrGetExisting(key, lazyLookupDictionary, new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(CacheExpiration) });
            return (value ?? lazyLookupDictionary).Value;
        }

        private IDictionary<TKey, EntityCollection> CreateLookupDictionary<TKey>()
        {
            return new Dictionary<TKey, EntityCollection>();
        }
    }
}