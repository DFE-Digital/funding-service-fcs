namespace FCT.Operations.Tests
{
    using System;
    using System.IO;
    using Microsoft.Extensions.Configuration;

    public class AppConfiguration
    {
        private static readonly IConfigurationRoot ConfigurationRoot;
        
        static AppConfiguration()
        {
            ConfigurationRoot = new ConfigurationBuilder()
                .SetBasePath(Directory.GetParent(AppContext.BaseDirectory).FullName)
                .AddJsonFile("appsettings.json", false)
#if CI
                .AddJsonFile("appsettings.CI.json", optional: false)
#endif
#if DCI
                .AddJsonFile("appsettings.DCI.json", optional: false)
#endif
                .Build();
        }
        
        public static IConfigurationRoot Configuration() => ConfigurationRoot;
    }
}
