namespace FCT.Operations.Tests.FundingConfirmationReport
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Operations.FundingConfirmationReport;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CreateFundingConfirmationReportHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateFundingConfirmationReportHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<CreateFundingConfirmationReportHandler>());

            container.BeginScope();

            // act
            container.Resolve<CreateFundingConfirmationReportHandler>();
        }
    }
}
