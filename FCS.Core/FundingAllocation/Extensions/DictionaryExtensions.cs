namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public static class DictionaryExtensions
    {
        public static TValue GetOrAdd<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, Func<TValue> getValue)
        {
            if (!dictionary.ContainsKey(key))
            {
                dictionary[key] = getValue();
            }

            return dictionary[key];
        }

        public static async Task AddIfNotPresent<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, Func<TKey, Task<TValue>> getValue)
        {
            if (!dictionary.ContainsKey(key))
            {
                dictionary[key] = await getValue(key);
            }
        }
    }
}
