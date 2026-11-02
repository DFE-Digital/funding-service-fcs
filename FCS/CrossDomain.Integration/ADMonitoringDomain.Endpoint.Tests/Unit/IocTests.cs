namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging;
    using Ioc;

    [TestClass]
    public class IocTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractAllocationApprovedHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<ContractAllocationApprovedHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationsAtomFeedGenerationHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractAllocationsAtomFeedGenerationHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<ContractAllocationsAtomFeedGenerationHandler>();
        }
    }
}
