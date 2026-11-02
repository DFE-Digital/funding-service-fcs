namespace SFA.FCS.Worker.Common.Slack
{
    using System.Collections.Generic;

    public static class DictionaryExtensions
    {
        public static TValue GetValueIfPresentOtherwiseNull<TKey, TValue>(this IReadOnlyDictionary<TKey, TValue> dictionary, TKey key) where TValue : class
        {
            return dictionary.ContainsKey(key) ? dictionary[key] : null;
        }

        public static TValue GetValueIfPresentOtherwiseNull<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key) where TValue : class
        {
            return dictionary.ContainsKey(key) ? dictionary[key] : null;
        }

        public static string GetTextAndValueIfPresent(this IReadOnlyDictionary<string, string> dictionary, string key)
        {
            var valueText = dictionary.GetValueIfPresentOtherwiseNull(key);
            return valueText != null ? $"{key} : {valueText}" : null;
        }
    }
}
