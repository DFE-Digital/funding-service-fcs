namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Endpoint.XrmService.DTOs;
    using Endpoint.XrmService.Repositories;
    using Endpoint.XrmService.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using Optional;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class ContractDeDuplicationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeDuplicationService_IsAllocationPresent_ShouldReturnFalse_WhenAllocationNotPresent()
        {
            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            var command = FromJson<ContractRequestProcessedCommand>("ContractCreateDomain.Endpoint.Tests",
                "Resources.ContractRequestProcessedCommand.json");

            ExtendedContractType extendedContractType = transformer.TransformToCorpContractType(command.ContractRequest);

            Mock<IContractQueryRepository> contractQueryRepMock = new Mock<IContractQueryRepository>();
            contractQueryRepMock.Setup(r => r.GetContractInfo(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new CrmContractInfo(Guid.Empty, string.Empty, new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo("A1")
                }).Some());

            ContractDeDuplicationService service = new ContractDeDuplicationService(contractQueryRepMock.Object, Mock.Of<IContractAllocationCommandRepository>());

            // act
            bool result = service.IsAllocationPresent(extendedContractType, "A2");

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeDuplicationService_IsContractPresent_ShouldReturnTrue_WhenAllocationPresent()
        {
            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            var command = FromJson<ContractRequestProcessedCommand>("ContractCreateDomain.Endpoint.Tests",
                "Resources.ContractRequestProcessedCommand.json");

            ExtendedContractType extendedContractType = transformer.TransformToCorpContractType(command.ContractRequest);

            Mock<IContractQueryRepository> contractQueryRepMock = new Mock<IContractQueryRepository>();
            contractQueryRepMock.Setup(r => r.GetContractInfo(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new CrmContractInfo(Guid.Empty, string.Empty, new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo("A1")
                }).Some());

            ContractDeDuplicationService service = new ContractDeDuplicationService(contractQueryRepMock.Object, Mock.Of<IContractAllocationCommandRepository>());

            // act
            bool result = service.IsAllocationPresent(extendedContractType, "A1");

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeDuplicationService_InsertAllocationWithoutDuplication_ShouldNotInsertIfAlreadyPresent()
        {
            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            var command = FromJson<ContractRequestProcessedCommand>("ContractCreateDomain.Endpoint.Tests",
                "Resources.ContractRequestProcessedCommand.json");

            ExtendedContractType extendedContractType = transformer.TransformToCorpContractType(command.ContractRequest);

            Mock<IContractQueryRepository> contractQueryRepMock = new Mock<IContractQueryRepository>();
            contractQueryRepMock.Setup(r => r.GetContractInfo(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new CrmContractInfo(Guid.Empty, string.Empty, new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo("A1")
                }).Some());

            ContractDeDuplicationService service = new ContractDeDuplicationService(contractQueryRepMock.Object, Mock.Of<IContractAllocationCommandRepository>());
            bool inserted = false;
            Action insert = () => inserted = true;

            // act
            service.InsertAllocationWithoutDuplication(extendedContractType, "A1", insert);

            // assert
            Assert.IsFalse(inserted);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeDuplicationService_InsertAllocationWithoutDuplication_ShouldInsertIfNotAlreadyPresent()
        {
            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            var command = FromJson<ContractRequestProcessedCommand>("ContractCreateDomain.Endpoint.Tests",
                "Resources.ContractRequestProcessedCommand.json");

            ExtendedContractType extendedContractType = transformer.TransformToCorpContractType(command.ContractRequest);

            Mock<IContractQueryRepository> contractQueryRepMock = new Mock<IContractQueryRepository>();
            contractQueryRepMock.Setup(r => r.GetContractInfo(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new CrmContractInfo(Guid.Empty, string.Empty, new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo("A1")
                }).Some());

            contractQueryRepMock.Setup(r =>
                    r.GetAllocationIds(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>()))
                .Returns(new List<Guid>());

            ContractDeDuplicationService service = new ContractDeDuplicationService(contractQueryRepMock.Object, Mock.Of<IContractAllocationCommandRepository>());
            bool inserted = false;
            Action insert = () => inserted = true;

            // act
            service.InsertAllocationWithoutDuplication(extendedContractType, "A2", insert);

            // assert
            Assert.IsTrue(inserted);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeDuplicationService_InsertAllocationWithoutDuplication_ShouldDelete_WhenThereIsMoreThanOneAfterInserting()
        {
            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            var command = FromJson<ContractRequestProcessedCommand>("ContractCreateDomain.Endpoint.Tests",
                "Resources.ContractRequestProcessedCommand.json");

            ExtendedContractType extendedContractType = transformer.TransformToCorpContractType(command.ContractRequest);

            Mock<IContractQueryRepository> contractQueryRepMock = new Mock<IContractQueryRepository>();
            contractQueryRepMock.Setup(r => r.GetContractInfo(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new CrmContractInfo(Guid.Empty, string.Empty, new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo("A1")
                }).Some());

            contractQueryRepMock.Setup(r =>
                    r.GetAllocationIds(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>()))
                .Returns(new List<Guid>
                {
                    Guid.Empty,
                    Guid.Empty
                });

            Mock<IContractAllocationCommandRepository> contractAllocationCommandRepositoryMock = new Mock<IContractAllocationCommandRepository>();

            ContractDeDuplicationService service = new ContractDeDuplicationService(contractQueryRepMock.Object, contractAllocationCommandRepositoryMock.Object);
            bool inserted = false;
            Action insert = () => inserted = true;

            // act
            service.InsertAllocationWithoutDuplication(extendedContractType, "A2", insert);

            // assert
            Assert.IsTrue(inserted, "we have not inserted");
            contractAllocationCommandRepositoryMock.Verify(r => r.DeleteAllocation(It.IsAny<Guid>()), Times.Once, "we have not called delete");
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
