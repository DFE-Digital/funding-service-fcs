namespace ContractRequestDomain.Tests.BulkUpload.FundingAllocationRelease
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Handlers;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class FundingAllocationReleasedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleasedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<FundingAllocationReleaseGroupGroupReleasedHandler>());
            container.BeginScope();

            // act
            container.Resolve<FundingAllocationReleaseGroupGroupReleasedHandler>();
        }
    }
}
