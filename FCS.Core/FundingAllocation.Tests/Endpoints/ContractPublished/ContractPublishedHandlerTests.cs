namespace FundingAllocation.Tests.Endpoints.ContractPublished
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.ContractPublished;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractPublishedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractPublishedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<ContractPublishedHandler>());

            container.BeginScope();

            // act
            container.Resolve<ContractPublishedHandler>();
        }
    }
}
