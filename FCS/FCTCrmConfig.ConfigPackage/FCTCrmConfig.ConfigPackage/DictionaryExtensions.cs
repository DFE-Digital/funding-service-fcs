namespace FCTCrmConfig.ConfigPackage
{
    using System;
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;

    public static class DictionaryExtensions
    {
        public static TValue GetValueOrDefault<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key)
        {
            TValue value;
            return dictionary.TryGetValue(key, out value) ? value : default(TValue);
        }

        public static TValue GetValueOrDefault<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, TValue defaultValue)
        {
            TValue value;
            return dictionary.TryGetValue(key, out value) ? value : defaultValue;
        }

        public static TValue GetValueOrDefault<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, Func<TValue> defaultValueProvider)
        {
            TValue value;
            return dictionary.TryGetValue(key, out value) ? value : defaultValueProvider();
        }

        public static EntityReference GetEntityReferenceOrDefault<TKey, TValue>(
            this IDictionary<TKey, TValue> dictionary, TKey key, string entityName, Func<string, TValue, EntityReference> formatProvider)
        {
            TValue value;
            return dictionary.TryGetValue(key, out value) ? formatProvider(entityName, value) : null;
        }
    }
}