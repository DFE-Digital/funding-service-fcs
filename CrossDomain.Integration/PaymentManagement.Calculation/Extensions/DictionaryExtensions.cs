namespace PaymentManagement.Calculation.Extensions
{
    using System;
    using System.Collections.Generic;
    using Optional;

    public static class DictionaryExtensions
    {
        public static TValue GetValueOrNull<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key) where TValue : class
        {
            if (dictionary.ContainsKey(key))
            {
                return dictionary[key];
            }

            return null;
        }

        public static TValue GetValueOrDefault<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key) where TValue : new() 
        {
            if (dictionary.ContainsKey(key))
            {
                return dictionary[key];
            }

            return new TValue();
        }

        public static Option<TValue> GetValueOrNone<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key) where TValue : class
        {
            if (dictionary.ContainsKey(key))
            {
                return dictionary[key].Some();
            }

            return new Option<TValue>();
        }

        public static void AddOrUpdate<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, TValue value)
        {
            if (dictionary.ContainsKey(key))
            {
                dictionary[key] = value;
            }
            else
            {
                dictionary.Add(key, value);
            }
        }

        public static void AddValueToExistingValue<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, TValue value, Func<TValue, TValue, TValue> addValues)
        {
            if (dictionary.ContainsKey(key))
            {
                TValue existing = dictionary[key];
                dictionary[key] = addValues(existing, value);
            }
            else
            {
                dictionary.Add(key, value);
            }
        }
    }
}
