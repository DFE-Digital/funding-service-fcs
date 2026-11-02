namespace FCT.Operations.Tests.PaymentSummary.Handlers
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Dapper;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using Operations.PaymentSummary;
    using Operations.PaymentSummary.Handlers;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;

    [TestClass]
    public class CreatePaymentSummaryReportHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreatePaymentSummaryReportHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<CreatePaymentSummaryReportHandler>());

            container.BeginScope();

            // act
            container.Resolve<CreatePaymentSummaryReportHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CreatePaymentSummaryReportHandler_ShouldHandleCommand()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "true";
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PaymentSchedulePolicyContext"].ConnectionString);

            connection.Execute("DELETE FROM OverrideDate.OverrideDate");

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<CreatePaymentSummaryReportHandler>().LifestyleScoped())
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault())
                .Register(Component.For<ISessionConnectionFactory>().UsingFactoryMethod(() =>
                {
                    var mock = new Mock<ISessionConnectionFactory>();
                    mock
                        .Setup(m => m.GetReplicaConnection())
                        .Returns(ConnectionInfo.CreateFrom(connection));
                    return mock.Object;
                }).IsDefault());

            container.BeginScope();

            // act
            var handler = container.Resolve<CreatePaymentSummaryReportHandler>();

            handler.Handle(new CreatePaymentSummaryReportCommand(), new TestableMessageHandlerContext()).Wait();
        }
    }
}
