using Microsoft.Extensions.Configuration;
using System;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public static class XrmTestConfiguration
    {
        private static IConfiguration _configuration;

        public static IConfiguration Configuration
        {
            get
            {
                if (_configuration == null)
                {
                    var environment =
                        Environment.GetEnvironmentVariable("Environment") ?? "DAT";

                    _configuration = new ConfigurationBuilder()
                        .SetBasePath(AppContext.BaseDirectory)
                        .AddJsonFile("appsettings.json", false)
                        .AddJsonFile($"appsettings.{environment}.json", true)
                        .Build();
                }

                return _configuration;
            }
        }
    }
}
