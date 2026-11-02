namespace ContractManagementDomain.Endpoint.Tests.ContractClosure.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.ContractClosure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ApprovalOnwardsContractFeedServIntTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddClosedContract_ShouldReturnAlreadyPresentWithSameFeedItemIdWhenMessageIdPresent()
        {
            // arrange
            contract contract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "Test",
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 1,
                        contractStatus = new contractStatusType
                        {
                            status = "Closed"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                }
            };

            contractType childContract = contract.contracts.First();
            string businessKey = $"{childContract.contractNumber}:{childContract.contractVersionNumber}.{childContract.contractSubVersionNumber}";
            Guid messageId = Guid.NewGuid();
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            DeleteContract(businessKey);

            using (var context = new ContractManagementDbContext())
            {
                ApprovalOnwardsContractAtomFeedService service = new ApprovalOnwardsContractAtomFeedService(new ApprovalOnwardsContractAtomItemRepository(context), new ContractTransformer(), contractXmlValidatorMock.Object, Mock.Of<ILogger>());

                service.AddClosedContract(contract, messageId, new ConnectionInfo(null, context.Database.Connection));
            }

            using (var context = new ContractManagementDbContext())
            {
                ApprovalOnwardsContractAtomFeedService service = new ApprovalOnwardsContractAtomFeedService(new ApprovalOnwardsContractAtomItemRepository(context), new ContractTransformer(), contractXmlValidatorMock.Object, Mock.Of<ILogger>());

                // act
                AtomItemCreationResult atomItemCreationResult = service.AddClosedContract(contract, messageId, new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.AreEqual(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, atomItemCreationResult);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddClosedContract_AddClosedContractThatDoesNotExist_ShouldReturnCorrectResult()
        {
            // Arrange
            var mockRepo = new Mock<IApprovalOnwardsContractAtomItemRepository>();
            
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
                            parentStatus = "Closed",
                            status = "Closed"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Closed",
                    status = "Closed"
                }
            };
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            // Act
            var closedContractAtomFeedItemCreationService = new ApprovalOnwardsContractAtomFeedService(mockRepo.Object, new ContractTransformer(), contractXmlValidatorMock.Object, Mock.Of<ILogger>());
            AtomItemCreationResult atomItemCreationResult = closedContractAtomFeedItemCreationService.AddClosedContract(corpContract, new Guid(), ConnectionInfo.CreateDefault());

            // Assert
            Assert.AreEqual(AtomItemCreationResult.Added, atomItemCreationResult);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddClosedContract_WhenBusinessKeyExistsInANewMEssage_ShouldReturnCorrectResult()
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
                            parentStatus = "Closed",
                            status = "Closed"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Closed",
                    status = "Closed"
                }
            };

            // Act
            var closedContractAtomFeedItemCreationService = new ApprovalOnwardsContractAtomFeedService(mockRepo.Object, new ContractTransformer(), contractXmlValidatorMock.Object, Mock.Of<ILogger>());
            AtomItemCreationResult atomItemCreationResult = closedContractAtomFeedItemCreationService.AddClosedContract(corpContract, Guid.NewGuid(), ConnectionInfo.CreateDefault());

            // Assert
            Assert.AreEqual(AtomItemCreationResult.AlreadyPresent, atomItemCreationResult);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddClosedContract_WhenBusinessKeyExistsInARetryMessage_ShouldReturnCorrectResult()
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
                            parentStatus = "Closed",
                            status = "Closed"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Closed",
                    status = "Closed"
                }
            };

            // Act
            var closedContractAtomFeedItemCreationService = new ApprovalOnwardsContractAtomFeedService(mockRepo.Object, new ContractTransformer(), contractXmlValidatorMock.Object, Mock.Of<ILogger>());
            AtomItemCreationResult atomItemCreationResult = closedContractAtomFeedItemCreationService.AddClosedContract(corpContract, identifier, ConnectionInfo.CreateDefault());

            // Assert
            Assert.AreEqual(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, atomItemCreationResult);
        }

        private static void DeleteContract(string businessKey)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.Where(a => a.BusinessKey == businessKey)
                    .ForEach(a => context.AtomFeedItems.Remove(a));

                context.SaveChanges();
            }
        }
    }
}
