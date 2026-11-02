namespace FundingAllocation.Tests.Endpoints.CheckForReadComplete
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.CheckForReadComplete;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class SetBatchToDiscardedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SetBatchToDiscardedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<SetBatchToDiscardedHandler>());

            container.BeginScope();

            // act
            container.Resolve<SetBatchToDiscardedHandler>();
        }
    }
}
