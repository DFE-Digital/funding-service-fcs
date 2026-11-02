namespace ContractCreateDomain.Endpoint.Tests.CreateContractInternal
{
    using System.IO;
    using System.Reflection;
    using ContractManagement.DataStore;
    using Endpoint.CreateContractInternal;
    using Endpoint.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DocumentGenerationCompleteHandlerTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerationCompleteHandler_ShouldProcessUpdate()
        {
            DocumentGenerationComplete documentGenerationComplete = FromJson<DocumentGenerationComplete>("ContractCreateDomain.Endpoint.Tests", "CreateContractInternal.Resources.DocGenComplete.json");

            Mock<ISessionConnectionFactory> sessionFactoryMock = new Mock<ISessionConnectionFactory>();

            using (var context = new ContractManagementDbContext())
            {
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(new SagaDataStorage(), Mock.Of<ILogger>(), new FundingTypeFundingPeriodQueryRepository(), new FundingTypePeriodService(), sessionFactoryMock.Object);

                handler.Handle(documentGenerationComplete, Mock.Of<IMessageHandlerContext>()).Wait();
            }
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
