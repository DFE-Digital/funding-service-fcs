namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache
{
    using System;
    using System.Runtime.Caching;

    public class FundingStreamPeriodCache : IFundingStreamPeriodCache
    {
        private static readonly object Sync = new object();
        private readonly MemoryCache _fspCache = new MemoryCache("FSP");
        private readonly CacheItemPolicy _cacheItemPolicy = new CacheItemPolicy();

        public object Add(string key, object value, TimeSpan expiration = default(TimeSpan))
        {
            lock (Sync)
            {
                _cacheItemPolicy.SlidingExpiration = expiration;
                return _fspCache.AddOrGetExisting(key, value, _cacheItemPolicy);  
            }          
        }

        public object Get(string key)
        {
            return _fspCache.GetCacheItem(key);
        }
    }
}
