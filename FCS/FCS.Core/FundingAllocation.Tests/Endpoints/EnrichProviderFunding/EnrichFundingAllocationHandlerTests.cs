namespace FundingAllocation.Tests.Endpoints.EnrichProviderFunding
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using FundingAllocation.Endpoints.EnrichProviderFunding;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class EnrichFundingAllocationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnrichFundingAllocationHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<EnrichFundingAllocationHandler>());

            container.BeginScope();

            // act
            container.Resolve<EnrichFundingAllocationHandler>();
        }
    }
}
