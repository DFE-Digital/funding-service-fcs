namespace WorkerRole.Tests
{
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class BootstrapperTests
    {

        [TestMethod]
        [TestCategory("TechnicalExploration")]
        public async Task Bootstrapper_ShouldStartEndpoint()
        {
            IReadOnlyCollection<IEndpointInstance> endpoints = null;

            try
            {
                var configuration =
                    new ConfigurationBuilder()
                        .Build();

                endpoints = await Bootstrapper.Start(
                    configuration,
                    Mock.Of<ILogger>());

                Assert.IsNotNull(endpoints);
                Assert.IsTrue(endpoints.Any());
            }
            finally
            {
                if (endpoints != null)
                {
                    foreach (var endpoint in endpoints)
                    {
                        await endpoint.Stop(TimeSpan.FromSeconds(30));
                    }
                }
            }


        }
    }
}
    
