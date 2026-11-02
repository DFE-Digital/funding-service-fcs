namespace FundingAllocation.Tests.Endpoints.CreateFundingAllocationInCrm
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.CreateFundingAllocationInCrm;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CreateFundingAllocationInCrmHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetFundingAllocationsPageHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CreateFundingAllocationInCrmHandler>());

            // act
            container.Resolve<CreateFundingAllocationInCrmHandler>();
        }
    }
}
