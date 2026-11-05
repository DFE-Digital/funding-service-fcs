namespace ContractCreateDomain.Endpoint.Tests.UpdateContract
{
    using Microsoft.Xrm.Sdk;
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using Endpoint.Infrastructure;
    using Endpoint.UpdateContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class UpdateContractFromFundingHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractFromFundingHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<IOrganizationService>().Instance(Mock.Of<IOrganizationService>()).Named("OrganizationServiceMock").IsDefault())
                .Register(Component.For<UpdateContractFromFundingHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<UpdateContractFromFundingHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void UpdateContractFromFundingHandler_TechnicalExploration()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<UpdateContractFromFundingHandler>());

            container.BeginScope();

            // act, assert
            var handler = container.Resolve<UpdateContractFromFundingHandler>();
            Mock<ISessionConnectionFactory> sessionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionFactoryMock.Setup(r => r.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));
           // handler.SessionConnectionFactory = sessionFactoryMock.Object;
            var command = GetUpdateContractFromFundingCommandFromFile();
            handler.Handle(command, null).Wait();
        }

        private UpdateContractFromFundingCommand GetUpdateContractFromFundingCommandFromFile()
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"ContractCreateDomain.Endpoint.Tests.Resources.UpdateContractFromFundingCommand.json"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<UpdateContractFromFundingCommand>(streamReader.ReadToEnd());
            }
        }
    }
}
