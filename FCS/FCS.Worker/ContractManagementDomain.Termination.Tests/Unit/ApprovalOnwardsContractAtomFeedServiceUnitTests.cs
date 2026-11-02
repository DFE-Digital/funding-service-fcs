namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementDomain.Termination.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ApprovalOnwardsContractAtomFeedServiceUnitTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddApprovedTerminationInitiationContract_WhenBusinessKeyExistsInANewMEssage_ShouldReturnCorrectResult()
        {
            // Arrange
            var mockRepo = new Mock<IApprovalOnwardsContractAtomItemRepository>();
            mockRepo.Setup(m => m.Add(It.IsAny<ConnectionInfo>(), It.IsAny<AtomFeedItem>())).Throws(new SqlDuplicateKeyStorageException(new Exception()));
            mockRepo.Setup(m => m.GetIdentifierForBusinessKey(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<AtomItemType>())).Returns(Guid.NewGuid());

            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);
            contract corpContract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "Contract-001",
                        contractVersionNumber = 1,
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Under Termination"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    status = "Draft",
                }
            };

            Mock<IContractTransformer> contractTransformerMock = new Mock<IContractTransformer>();


            // Act
            var closedContractAtomFeedItemCreationService = new ApprovalOnwardsContractAtomFeedService(Mock.Of<ILogger>(), mockRepo.Object, new ContractTransformer(), contractXmlValidatorMock.Object);
            AtomItemCreationResult atomItemCreationResult = closedContractAtomFeedItemCreationService.AddContractToFeed(ConnectionInfo.CreateDefault(), corpContract, Guid.NewGuid(), AtomItemType.ContractTerminationInitiated);

            // Assert
            Assert.AreEqual(AtomItemCreationResult.AlreadyPresent, atomItemCreationResult);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddApprovedTerminationInitiationContract_WhenBusinessKeyExistsInARetryMessage_ShouldReturnCorrectResult()
        {
            // Arrange
            Guid identifier = Guid.NewGuid();

            var mockRepo = new Mock<IApprovalOnwardsContractAtomItemRepository>();
            mockRepo.Setup(m => m.Add(It.IsAny<ConnectionInfo>(), It.IsAny<AtomFeedItem>())).Throws(new SqlDuplicateKeyStorageException(new Exception()));
            mockRepo.Setup(m => m.GetIdentifierForBusinessKey(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<AtomItemType>())).Returns(identifier);
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            contract corpContract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "Contract-001",
                        contractVersionNumber = 1,
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Under Termination"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    status = "Draft",
                }
            };

            // Act
            var closedContractAtomFeedItemCreationService = new ApprovalOnwardsContractAtomFeedService(Mock.Of<ILogger>(), mockRepo.Object, new ContractTransformer(), contractXmlValidatorMock.Object);
            AtomItemCreationResult atomItemCreationResult = closedContractAtomFeedItemCreationService.AddContractToFeed(ConnectionInfo.CreateDefault(), corpContract, identifier, AtomItemType.ContractTerminationInitiated);

            // Assert
            Assert.AreEqual(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, atomItemCreationResult);
        }
    }
}
