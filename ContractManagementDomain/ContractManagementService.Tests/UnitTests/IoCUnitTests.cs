using System;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;

namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ContractManagementModel = ContractManagement.DataStore.Model;
    using PerformanceManagementModel = SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Microsoft.Extensions.DependencyInjection;

    [TestClass]
    public class IoCUnitTests
    {
        private IServiceProvider _container;

        [TestMethod, TestCategory("UnitTest")]
        public void IoC_TestGenericsResolvesCorrectlyForAtomFeedGenerator()
        {
            // Arrange
            SetupIoC();

            // Act
            var performanceManagementAtomFeedGenerator = _container.GetService<AtomFeed.IAtomFeedGenerator<PerformanceManagementModel.AtomFeedItem>>();
            var contractManagementAtomFeedGenerator = _container.GetService<AtomFeed.IAtomFeedGenerator<ContractManagementModel.AtomFeedItem>>();
            var corpContractSchemaAtomFeedGenerator = _container.GetService<AtomFeed.IAtomFeedGenerator<contract>>();

            // Assert
            Assert.IsNotNull(performanceManagementAtomFeedGenerator, "AtomFeedGenerator Container for Performance Management AtomFeedItem did not resolve");
            Assert.IsNotNull(contractManagementAtomFeedGenerator, "AtomFeedGenerator Container for Contract Management AtomFeedItem did not resolve");
            Assert.IsNotNull(corpContractSchemaAtomFeedGenerator, "AtomFeedGenerator Container for Corporate Contract Schema did not resolve");

            Assert.IsTrue(corpContractSchemaAtomFeedGenerator is AtomFeed.AtomFeedGenerator<contract>, "AtomFeedGenerator was resolved with incorrect generic Type");

            Assert.IsTrue(performanceManagementAtomFeedGenerator is AtomFeed.AtomFeedGenerator<PerformanceManagementModel.AtomFeedItem>, "AtomFeedGenerator was resolved with incorrect generic Type");
            Assert.IsTrue(contractManagementAtomFeedGenerator is AtomFeed.AtomFeedGenerator<ContractManagementModel.AtomFeedItem>, "AtomFeedGenerator was resolved with incorrect generic Type");

            Assert.IsFalse(ReferenceEquals(performanceManagementAtomFeedGenerator, contractManagementAtomFeedGenerator), "performanceManagementAtomFeedGenerator and contractManagementAtomFeedGenerator Object references are the same");
            Assert.IsFalse(ReferenceEquals(contractManagementAtomFeedGenerator, corpContractSchemaAtomFeedGenerator), "contractManagementAtomFeedGenerator and corpContractSchemaAtomFeedGenerator Object references are the same");
        }

        protected void SetupIoC()
        {
            var server = new TestServer(
                WebHost.CreateDefaultBuilder()
                    .UseStartup<Startup>()
            );
            _container = server.Host.Services;
        }
    }
}
