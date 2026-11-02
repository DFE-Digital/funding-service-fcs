namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Repositories
{
    using System;
    using System.Collections.Concurrent;

    public abstract class LazyCache<TKey, TValue>
    {
        private static readonly ConcurrentDictionary<TKey, Lazy<TValue>> EntityForKey = new ConcurrentDictionary<TKey, Lazy<TValue>>();

        protected TValue GetLazyValue(TKey key, Func<TKey, TValue> getValue)
        {
            Lazy<TValue> lazy = new Lazy<TValue>(() => getValue(key));

            lazy = EntityForKey.GetOrAdd(key, lazy);

            return lazy.Value;
        }
    }
}