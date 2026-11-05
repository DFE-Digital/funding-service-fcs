namespace ContractCreateDomain.Endpoint.Tests.XrmService
{
    using Microsoft.Xrm.Sdk;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Endpoint.Infrastructure;
    using Endpoint.XrmService;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.XrmService;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

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
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;

    [TestClass]
    public class UpdateContractHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IOrganizationService>().Instance(Mock.Of<IOrganizationService>()).Named("OrganizationServiceMock").IsDefault())
                .Register(Component.For<UpdateContractHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<UpdateContractHandler>();
        }


        [TestMethod, TestCategory("TechnicalExploration")]
        public void UpdateContractHandler_SendMessage()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<UpdateContractHandler>());
            container.BeginScope();

            
            var handler = container.Resolve<UpdateContractHandler>();


            UpdateContractCommand message = FromJson<UpdateContractCommand>(
                "ContractCreateDomain.Endpoint.Tests",
                "Resources.UpdateContractCommand.json");


            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(message, context).Wait();

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