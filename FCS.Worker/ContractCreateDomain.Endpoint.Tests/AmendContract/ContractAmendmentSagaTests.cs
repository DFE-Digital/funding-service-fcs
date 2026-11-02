namespace ContractCreateDomain.Endpoint.Tests.AmendContract
{
    using System.Configuration;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.AmendContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;
    using System.IO;
    using System.Reflection;
    using ContractManagement.DataStore;
    using Endpoint.Infrastructure;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class ContractAmendmentSagaTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAmendmentSaga_ShouldResolve()
        {
           // arrange
           IWindsorContainer container = new WindsorContainer()
               .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
               .Register(Component.For<ContractAmendmentSaga>());

            container.BeginScope();
            ConfigurationManager.AppSettings["ContractOperationSagaTimeoutInMinutes"] = "1";

            // act, assert
            container.Resolve<ContractAmendmentSaga>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractAmendmentSaga_InvestigateDeliverablePeriodForEachMonthRule()
        {
            // arrange
            Mock<ISessionConnectionFactory> sessionFactoryMock = new Mock<ISessionConnectionFactory>();
            var context = new ContractManagementDbContext();
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

            IWindsorContainer container = new WindsorContainer()
            .Install(new WindsorInstallerForSagas(new LoggerFactory()))
            .Register(Component.For<ISessionConnectionFactory>().Instance(sessionFactoryMock.Object).IsDefault())
            .Register(Component.For<ContractAmendmentSaga>());

            container.BeginScope();
            ConfigurationManager.AppSettings["ContractOperationSagaTimeoutInMinutes"] = "1";

            ContractAmendmentRequestCommand message = FromJson<ContractAmendmentRequestCommand>(
                "ContractCreateDomain.Endpoint.Tests",
                "AmendContract.Resources.ModifyContractRequestCommand_254.json");

            TestableMessageHandlerContext handlerContext = new TestableMessageHandlerContext();
            ContractAmendmentSaga saga = container.Resolve<ContractAmendmentSaga>();

            // act
            saga.Handle(message, handlerContext).Wait();
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
