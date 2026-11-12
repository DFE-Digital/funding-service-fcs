namespace ContractManagementDomain.Termination.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ApprovalOnwardsContractAtomFeedServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddTerminationInitiatedContract_ShouldReturnAlreadyPresentWithSameFeedItemIdWhenMessageIdPresent()
        {
            // arrange
            contract contract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "Test",
                        contractVersionNumber = 5,
                        contractSubVersionNumber = 5,
                        contractStatus = new contractStatusType
                        {
                            status = "Under Termination"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                }
            };
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            _ = contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            contractType childContract = contract.contracts.First();
            string businessKey = $"{childContract.contractNumber}:{childContract.contractVersionNumber}.{childContract.contractSubVersionNumber}";
            Guid messageId = Guid.NewGuid();

            DeleteContract(businessKey);

            using (var context = new ContractManagementDbContext())
            {
                ApprovalOnwardsContractAtomFeedService service = new ApprovalOnwardsContractAtomFeedService(Mock.Of<ILogger>(), new ApprovalOnwardsContractAtomItemRepository(context), new ContractTransformer(), contractXmlValidatorMock.Object);

                _ = service.AddContractToFeed(new ConnectionInfo(null, context.Database.Connection), contract, messageId, AtomItemType.ContractTerminationInitiated);
            }

            using (var context = new ContractManagementDbContext())
            {
                ApprovalOnwardsContractAtomFeedService service = new ApprovalOnwardsContractAtomFeedService(Mock.Of<ILogger>(), new ApprovalOnwardsContractAtomItemRepository(context), new ContractTransformer(), contractXmlValidatorMock.Object);

                // act
                AtomItemCreationResult atomItemCreationResult = service.AddContractToFeed(new ConnectionInfo(null, context.Database.Connection), contract, messageId, AtomItemType.ContractTerminationInitiated);

                // assert
                Assert.AreEqual(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, atomItemCreationResult);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovalOnwardsContractAtomFeedService_AddTerminationInitiatedContract_ShouldAddToFeedWhenContractTerminationInitiatedEventPresentForSameContractButWithDifferentFeedId()
        {
            // arrange
            contract contract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "Test",
                        contractVersionNumber = 6,
                        contractSubVersionNumber = 6,
                        contractStatus = new contractStatusType
                        {
                            status = "Under Termination"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                }
            };

            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            _ = contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            contractType childContract = contract.contracts.First();
            string businessKey = $"{childContract.contractNumber}:{childContract.contractVersionNumber}.{childContract.contractSubVersionNumber}";

            DeleteContract(businessKey);

            using (var context = new ContractManagementDbContext())
            {
                ApprovalOnwardsContractAtomFeedService service = new ApprovalOnwardsContractAtomFeedService(Mock.Of<ILogger>(), new ApprovalOnwardsContractAtomItemRepository(context), new ContractTransformer(), contractXmlValidatorMock.Object);

                _ = service.AddContractToFeed(ConnectionInfo.CreateDefault(), contract, Guid.NewGuid(), AtomItemType.ContractTerminationInitiated);
            }

            using (var context = new ContractManagementDbContext())
            {
                ApprovalOnwardsContractAtomFeedService service = new ApprovalOnwardsContractAtomFeedService(Mock.Of<ILogger>(), new ApprovalOnwardsContractAtomItemRepository(context), new ContractTransformer(), contractXmlValidatorMock.Object);

                // act
                AtomItemCreationResult atomItemCreationResult = service.AddContractToFeed(ConnectionInfo.CreateDefault(), contract, Guid.NewGuid(), AtomItemType.ContractTerminationInitiated);

                // assert
                Assert.AreEqual(AtomItemCreationResult.Added, atomItemCreationResult);
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ApprovalOnwardsContractAtomFeedService_AddTerminationInitiatedContract_ShouldAddToFeedWithCorrectAtomItemType()
        {
            // arrange
            contract contract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "Test",
                        contractVersionNumber = 6,
                        contractSubVersionNumber = 6,
                        contractStatus = new contractStatusType
                        {
                            status = "Under Termination"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                }
            };

            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            _ = contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            contractType childContract = contract.contracts.First();
            string businessKey = $"{childContract.contractNumber}:{childContract.contractVersionNumber}.{childContract.contractSubVersionNumber}";

            DeleteContract(businessKey);

            using (var context = new ContractManagementDbContext())
            {
                ApprovalOnwardsContractAtomFeedService service = new ApprovalOnwardsContractAtomFeedService(Mock.Of<ILogger>(), new ApprovalOnwardsContractAtomItemRepository(context), new ContractTransformer(), contractXmlValidatorMock.Object);

                // act
                _ = service.AddContractToFeed(ConnectionInfo.CreateDefault(), contract, Guid.NewGuid(), AtomItemType.ContractTerminationDetailsUpdated);
            }


            using (var context = new ContractManagementDbContext())
            {
                var atomFeedItems = context.AtomFeedItems.Where(a => a.BusinessKey == businessKey);

                // assert
                Assert.IsNotNull(atomFeedItems, "AtomFeedItem was not added");
                Assert.AreEqual(AtomItemType.ContractTerminationDetailsUpdated, atomFeedItems.First().ItemType, "Incorrect AtomItemType was added");
            }
        }

        private void DeleteContract(string businessKey)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.Where(a => a.BusinessKey == businessKey)
                    .ForEach(a => context.AtomFeedItems.Remove(a));

                _ = context.SaveChanges();
            }
        }
    }
}
