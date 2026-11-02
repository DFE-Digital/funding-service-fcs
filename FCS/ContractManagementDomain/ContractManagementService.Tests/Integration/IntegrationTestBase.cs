namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System;
    using Microsoft.AspNetCore;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.TestHost;
    using Microsoft.Extensions.Configuration;

    public abstract class IntegrationTestBase
    {
        protected IntegrationTestBase()
        {
            SetupIoC();
        }

        protected IServiceProvider Container { get; private set; }

        private void SetupIoC()
        {
            var server = new TestServer(
                WebHost.CreateDefaultBuilder()
                    .ConfigureAppConfiguration((context, conf) =>
                    {
                        conf.AddJsonFile("appsettings.json", false);
#if CI
                        conf.AddJsonFile("appsettings.CI.json", optional: false);
#endif
#if DCI
                        conf.AddJsonFile("appsettings.DCI.json", optional: false);
#endif
                    })
                    .UseStartup<Startup>()
            );
            Container = server.Host.Services;
        }
    }
}
