namespace FundingAllocation.Tests.Endpoints.DocumentGenerationComplete
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.DocumentGenerationComplete;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CrmContractCreatedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractCreatedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CrmContractCreatedHandler>());

            container.BeginScope();

            // act
            container.Resolve<CrmContractCreatedHandler>();
        }
    }
}
