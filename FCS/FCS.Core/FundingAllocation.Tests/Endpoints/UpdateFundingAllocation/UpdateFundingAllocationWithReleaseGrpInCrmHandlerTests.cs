namespace FundingAllocation.Tests.Endpoints.UpdateFundingAllocation
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using FundingAllocation.Endpoints.UpdateFundingAllocation;
    using FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UpdateFundingAllocationWithReleaseGrpInCrmHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateFundingAllocationWithReleaseGrpInCrmHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<UpdateFundingAllocationWithReleaseGrpInCrmHandler>());

            // act
            container.Resolve<UpdateFundingAllocationWithReleaseGrpInCrmHandler>();
        }
    }
}
