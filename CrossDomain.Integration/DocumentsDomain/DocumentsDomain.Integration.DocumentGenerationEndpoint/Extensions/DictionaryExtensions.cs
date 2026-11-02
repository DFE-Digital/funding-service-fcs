namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.Extensions
{
    using System.Collections.Generic;

    public static class DictionaryExtensions
    {
        public static TVal GetValueOrDefault<TKey, TVal>(this IReadOnlyDictionary<TKey, TVal> dict, TKey key, TVal defaultVal)
        {
            if (dict.ContainsKey(key))
            {
                return dict[key];
            }

            return defaultVal;
        }
    }
}
