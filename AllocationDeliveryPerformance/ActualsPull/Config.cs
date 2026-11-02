namespace AllocationDeliveryPerformance
{
    using Microsoft.Extensions.Configuration;

    public static class Config
    {
        private static readonly IConfigurationRoot ConfigurationRoot;

        static Config()
        {
            ConfigurationRoot = new ConfigurationBuilder()
                 .AddJsonFile("appsettings.json", optional: true)
                 .AddEnvironmentVariables()
                 .Build();
        }

        public static string GetAppSetting(string settingName)
        { 
            var setting = ConfigurationRoot[settingName];

            return setting;
        }
    }
}
