namespace Operations.Worker.Audit
{
    using System.Collections.Generic;

    public static class DictionaryExtensions
    {
        public static string GetStringValueOrDefault(this IReadOnlyDictionary<string, object> dictionary, string key, string defaultValue)
        {
            if (dictionary.ContainsKey(key))
            {
                return dictionary[key].ToString();
            }

            return defaultValue;
        }
    }
}
