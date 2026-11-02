namespace FCT.Operations.Tests.FundingAllocationExtract
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FCT.Operations.FundingAllocationExtract;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CreateFundingAllocationExtractsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateFundingAllocationExtractsHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<CreateFundingAllocationExtractsHandler>());

            container.BeginScope();

            // act
            container.Resolve<CreateFundingAllocationExtractsHandler>();
        }
    }
}