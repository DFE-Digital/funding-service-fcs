namespace AllocationDeliveryDomain.Endpoint.Infrastructure
{
    using System.Collections.Concurrent;
    using System.Configuration;

    /// <summary>
    /// This class has the responsibility of getting configuration information. It was created to deal with a production issue where
    ///  ConfigurationManager.AppSettings sometimes returned a empty string after being called many times
    /// </summary>
    public static class ConfigurationRetriever
    {
        private static readonly ConcurrentDictionary<string, string> AppSettings = new ConcurrentDictionary<string, string>(); 

        public static string GetAppSetting(string key)
        {
            return AppSettings.GetOrAdd(key, ConfigurationManager.AppSettings[key]);
        }
    }
}
