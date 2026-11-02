namespace ContractRequestDomain.Tests
{
    using System.IO;
    using System.Reflection;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class NewDasContractRequestCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NewDasContractRequestCommandHandler_ShouldAlwaysAddNonLevyAllocation()
        {
            // arrange
            contractRequestType contractRequest = FromJson<contractRequestType>("ContractRequestDomain.Tests",
                @"Resources.contract_request_das.json");
            Mock<IContractRequestMutator> contractRequestMutator = new Mock<IContractRequestMutator>();

            NewDasContractRequestCommandHandler handler = new NewDasContractRequestCommandHandler(
                Mock.Of<ILogger>(),
                contractRequestMutator.Object);

            var contextMock = new TestableMessageHandlerContext();
            // act
            handler.Handle(new NewDasContractRequestCommand
            {
                DasRequest = new DasRequest()
            }, contextMock).Wait();

            // assert
            contractRequestMutator.Verify(r => r.AddNonLevyAllocationToContractRequest(It.IsAny<contractRequestType>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewDasContractRequestCommandHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC.WindsorInstaller(new LoggerFactory()));
           
            container.Register(Component.For<NewDasContractRequestCommandHandler>());
            
            // Act
            var handler = container.Resolve<NewDasContractRequestCommandHandler>();

            // Assert
            Assert.IsNotNull(handler);
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream =
                Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
