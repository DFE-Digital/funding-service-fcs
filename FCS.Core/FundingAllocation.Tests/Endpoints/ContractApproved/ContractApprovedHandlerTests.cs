namespace FundingAllocation.Tests.Endpoints.ContractApproved
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.ContractApproved;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractApprovedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<ContractApprovedHandler>());

            container.BeginScope();

            // act
            container.Resolve<ContractApprovedHandler>();
        }
    }
}