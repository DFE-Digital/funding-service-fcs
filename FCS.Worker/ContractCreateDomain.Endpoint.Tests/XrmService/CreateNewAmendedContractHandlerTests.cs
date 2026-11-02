namespace ContractCreateDomain.Endpoint.Tests.XrmService
{
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

    [TestClass]
    public class CreateNewAmendedContractHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task CreateNewAmendedContractHandler_ShouldCallCreateNewAmendedContract_WhenContractNotAlreadyInSystem()
        {
            // arrange
            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            CreateNewAmendedContractHandler handler =
                new CreateNewAmendedContractHandler(Mock.Of<ILogger>(), contractsManagerMock.Object, processedMessageRepositoryMock.Object, Mock.Of<ISessionConnectionFactory>());

            var context = new TestableMessageHandlerContext();

            CreateNewAmendedContractCommand createNewAmendedContractCommand = new CreateNewAmendedContractCommand
            {
                CorporateContract = new ExtendedContract
                {
                    contracts = new List<ExtendedContractType>
                    {
                        new ExtendedContractType()
                    }
                }
            };

            // act
            await handler.Handle(createNewAmendedContractCommand, context);

            // assert
            contractsManagerMock.Verify(
                cm => cm.CreateNewAmendedContract(It.IsAny<ExtendedContractType>(), It.IsAny<string>()), Times.Once);
        }
    }
}
