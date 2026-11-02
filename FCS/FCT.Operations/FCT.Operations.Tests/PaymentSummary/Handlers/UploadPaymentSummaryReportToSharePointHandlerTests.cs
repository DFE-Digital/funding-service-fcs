namespace FCT.Operations.Tests.PaymentSummary.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Operations.PaymentSummary;
    using Operations.PaymentSummary.Handlers;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UploadPaymentSummaryReportToSharePointHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UploadPaymentSummaryReportToSharePointHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<UploadPaymentSummaryReportToSharePointHandler>());

            container.BeginScope();

            // act
            container.Resolve<UploadPaymentSummaryReportToSharePointHandler>();
        }
    }
}
