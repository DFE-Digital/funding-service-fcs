namespace Operations.Worker.Extensions
{
    using System.Collections.Generic;

    public static class DictionaryExtensions
    {
        public static TValue GetValueIfPresentOtherwiseNull<TKey, TValue>(this IReadOnlyDictionary<TKey, TValue> dictionary, TKey key) where TValue : class
        {
            if (dictionary.ContainsKey(key))
            {
                return dictionary[key];
            }

            return null;
        }
    }
}