using System;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

namespace SFA.FCT.Contracts.AcceptanceTests
{
    public static class TestConfiguration
    {
        private static IConfiguration _configuration;

        private static readonly Dictionary<string, string> Overrides =
            new Dictionary<string, string>();

        public static IConfiguration Configuration
        {
            get
            {
                if (_configuration == null)
                {
                    Reload();
                }

                return _configuration;
            }
        }

        public static void ForceConnectionStringValue(string name, string value)
        {
            Overrides[$"ConnectionStrings:{name}"] = value;
            Reload();
        }
        public static void ForceAppSettingValue(string key, string value)
        {
            Overrides[key] = value;
            Reload();
        }

        public static string GetConnectionString(string name)
        {
            return Configuration.GetConnectionString(name);
        }

        private static void Reload()
        {
            var environment =
                Environment.GetEnvironmentVariable("Environment") ??
                Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT") ??
                "DAT";

            _configuration = new ConfigurationBuilder()
                .SetBasePath(AppContext.BaseDirectory)
                .AddJsonFile("appsettings.json", false)
                .AddJsonFile($"appsettings.{environment}.json", true)
                .AddInMemoryCollection(Overrides)
                .Build();
        }
    }
}