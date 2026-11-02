namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;

    public class PollableProxyCache<T>
    {
        private readonly Dictionary<string, T> _cache = new Dictionary<string, T>();

        public T GetItemIfAvailable(object key, Func<T> getData)
        {
            string keyString = CreateKey(key);

            if (_cache.ContainsKey(keyString))
            {
                return _cache[keyString];
            }

            T data = getData();

            if (data != null)
            {
                _cache.Add(keyString, data);
            }

            return data;
        }

        private static string CreateKey(object keyObject)
        {
            if (keyObject is string)
            {
                return keyObject.ToString();
            }

            PropertyInfo[] propertyInfos = keyObject.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);
            if (propertyInfos.Any())
            {
                IEnumerable<string> keyPropertyValues = propertyInfos.Select(p => p.GetValue(keyObject).ToString());
                return string.Join("_", keyPropertyValues);
            }

            return keyObject.ToString();
        }
    }
}
