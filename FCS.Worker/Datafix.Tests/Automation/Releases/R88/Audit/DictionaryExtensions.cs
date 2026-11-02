namespace Datafix.Tests.Automation.Releases.R88.Audit
{
    using System.Collections.Generic;
    public static class DictionaryExtensions
    {
        public static string GetStringValueOrDefault(this IDictionary<string, object> dictionary, string key, string defaultValue)
        {
            if (dictionary.ContainsKey(key))
            {
                return dictionary[key].ToString();
            }

            return defaultValue;
        }
    }
}