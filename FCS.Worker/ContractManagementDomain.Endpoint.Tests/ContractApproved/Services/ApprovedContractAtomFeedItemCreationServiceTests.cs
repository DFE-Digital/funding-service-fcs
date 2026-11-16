namespace ContractManagementDomain.Endpoint.Tests.ContractApproved.Services
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using Endpoint.ContractApproved.Repositories;
    using Endpoint.ContractApproved.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class ApprovedContractAtomFeedItemCreationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAtomFeedItemCreationService_AddApprovedContract_ShouldAddAtomFeedItem()
        {
            // arrange
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);
            Mock<IApprovedContractAtomItemRepository> repositoryMock = new Mock<IApprovedContractAtomItemRepository>();
            ApprovedContractAtomFeedItemCreationService approvedContractAtomFeedItemCreationService =
                new ApprovedContractAtomFeedItemCreationService(Mock.Of<ILogger>(), repositoryMock.Object, new ContractTransformer(), contractXmlValidatorMock.Object);

            // act
            approvedContractAtomFeedItemCreationService.AddApprovedContract(new ContractApprovedEvent
            {
                CorporateContract = new Contract
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
                                status = "Approved"
                            }
                        }
                    },
                    contractStatus = new contractStatusType
                    {
                        parentStatus = "Approved",
                        status = "Approved"
                    }
                }
            }.CorporateContract, Guid.NewGuid(), ConnectionInfo.CreateDefault()).Wait();

            // assert
            repositoryMock.Verify(
                m => m.Add(It.IsAny<AtomFeedItem>(), It.IsAny<ConnectionInfo>()),
                Times.Once,
                "ContractApprovedEventHandler did not add to the Atom Feed Item repository.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAtomFeedItemCreationService_AddApprovedContract_ForAnEsfContract_ShouldAddAtomEntryWithEsfFieldsCorrectlyPopulated()
        {
            // arrange
            Mock<IApprovedContractAtomItemRepository> repositoryMock = new Mock<IApprovedContractAtomItemRepository>();
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);
            ApprovedContractAtomFeedItemCreationService approvedContractAtomFeedItemCreationService =
                new ApprovedContractAtomFeedItemCreationService(Mock.Of<ILogger>(), repositoryMock.Object, new ContractTransformer(), contractXmlValidatorMock.Object);

            // act
            approvedContractAtomFeedItemCreationService.AddApprovedContract(
                new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Contract-001",
                            contractVersionNumber = 1,

                            contractAllocations = new List<contractAllocationsContractAllocation>
                            {
                                new contractAllocationsContractAllocation
                                {
                                    //TODO: realistic values??

                                    LEPCode = "LEPCode",
                                    LEPName = "LEPName",
                                    tenderSpecificationReference = "tenderSpecificationReference",
                                    lotReference = "lotReference",
                                    tenderAwardReference = "tenderAwardRef",
                                    ActivityDescription = "ActivityDescription",
                                    InvestmentPriority = "InvestmentPriority",
                                    AgreementNumber = "AgreementNumber",
                                    SpecificationTitle = "SpecificationTitle",
                                    RegionType = "RegionType",
                                    LearningRatePremium = "12.3",    // ""
                                    description = "description",

                                    contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                    {
                                        new contractDeliverablesTypeContractDeliverable
                                        {
                                            unitCost = 97m,
                                            plannedVolume = 100
                                        }
                                    }
                                }
                            },
                            contractStatus = new contractStatusType
                            {
                                parentStatus = "Approved",
                                status = "Approved"
                            }
                        }
                    },
                    contractStatus = new contractStatusType
                    {
                        parentStatus = "Approved",
                        status = "Approved"
                    }
                }, Guid.NewGuid(), ConnectionInfo.CreateDefault()).Wait();

            // assert
            repositoryMock.Verify(
                m => m.Add(It.IsAny<AtomFeedItem>(), It.IsAny<ConnectionInfo>()),
                Times.Once,
                "ContractApprovedEventHandler did not add to the Atom Feed Item repository.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAtomFeedItemCreationService_AddApprovedContract_ShouldHandleDuplicateKeyStorageException()
        {
            // arrange
            Mock<IApprovedContractAtomItemRepository> _repositoryMock = new Mock<IApprovedContractAtomItemRepository>();
            _repositoryMock
                .Setup(m => m.Add(It.IsAny<AtomFeedItem>(), It.IsAny<ConnectionInfo>()))
                .Throws(new SqlDuplicateKeyStorageException(new Exception()));
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            ApprovedContractAtomFeedItemCreationService _approvedContractAtomFeedItemCreationService =
                new ApprovedContractAtomFeedItemCreationService(Mock.Of<ILogger>(), _repositoryMock.Object, new ContractTransformer(), contractXmlValidatorMock.Object);
            
            // act
            _approvedContractAtomFeedItemCreationService.AddApprovedContract(new ContractApprovedEvent
            {
                CorporateContract = new Contract
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
                                status = "Approved"
                            }
                        }
                    },
                    contractStatus = new contractStatusType
                    {
                        parentStatus = "Approved",
                        status = "Approved"
                    }
                }
            }.CorporateContract, Guid.NewGuid(), ConnectionInfo.CreateDefault()).Wait();

            // should not exception
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAtomFeedItemCreationService_AddApprovedContract_ShouldSetResultToAddedWhenCalledOnceAndThereIsNoException()
        {
            // Arrange
            Guid? feedItemId = Guid.NewGuid();

            Mock<IApprovedContractAtomItemRepository> _repositoryMock = new Mock<IApprovedContractAtomItemRepository>();
            _repositoryMock
                .Setup(m => m.GetIdentifierForBusinessKey(It.IsAny<string>(), AtomItemType.ApprovedContract, It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(feedItemId));
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            ApprovedContractAtomFeedItemCreationService _approvedContractAtomFeedItemCreationService =
                new ApprovedContractAtomFeedItemCreationService(Mock.Of<ILogger>(), _repositoryMock.Object, new ContractTransformer(), contractXmlValidatorMock.Object);
            
            Contract contractApprovedEvent = new ContractApprovedEvent
            {
                CorporateContract = new Contract
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
                                 status = "Approved"
                             }
                         }
                     },
                    contractStatus = new contractStatusType
                    {
                        parentStatus = "Approved",
                        status = "Approved"
                    }
                }
            }.CorporateContract;

            // Act
            AtomItemCreationResult atomItemCreationResult = _approvedContractAtomFeedItemCreationService.AddApprovedContract(
                contractApprovedEvent,
                feedItemId.Value,
                ConnectionInfo.CreateDefault()).Result;

            // Assert
            Assert.AreEqual(AtomItemCreationResult.Added, atomItemCreationResult);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAtomFeedItemCreationService_AddApprovedContract_ShouldSetResultToAlreadyPresentWithSameFeedItemIdWhenCalledWithTheSameFeedItemIdAndThereIsADuplicateException()
        {
            // Arrange
            Guid? feedItemId = Guid.NewGuid();

            Mock<IApprovedContractAtomItemRepository> _repositoryMock = new Mock<IApprovedContractAtomItemRepository>();
            _repositoryMock
                .Setup(m => m.Add(It.IsAny<AtomFeedItem>(), It.IsAny<ConnectionInfo>()))
                .Throws(new SqlDuplicateKeyStorageException(new Exception()));
            _repositoryMock
                .Setup(m => m.GetIdentifierForBusinessKey(It.IsAny<string>(), AtomItemType.ApprovedContract, It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(feedItemId));
            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            ApprovedContractAtomFeedItemCreationService _approvedContractAtomFeedItemCreationService =
                new ApprovedContractAtomFeedItemCreationService(Mock.Of<ILogger>(), _repositoryMock.Object, new ContractTransformer(), contractXmlValidatorMock.Object);
            
            Contract contractApprovedEvent = new ContractApprovedEvent
            {
                CorporateContract = new Contract
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
                                 status = "Approved"
                             }
                         }
                     },
                    contractStatus = new contractStatusType
                    {
                        parentStatus = "Approved",
                        status = "Approved"
                    }
                }
            }.CorporateContract;

            // Act
            AtomItemCreationResult atomItemCreationResult2Nd = _approvedContractAtomFeedItemCreationService.AddApprovedContract(
                contractApprovedEvent,
                feedItemId.Value,
                ConnectionInfo.CreateDefault()).Result;

            // Assert
            Assert.AreEqual(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, atomItemCreationResult2Nd);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAtomFeedItemCreationService_AddApprovedContract_ShouldSetResultToAlreadyPresentWhenCalledWithDifferentFeedItemIdAndThereIsADuplicateException()
        {
            // Arrange
            Guid feedItemId = Guid.NewGuid();

            Mock<IApprovedContractAtomItemRepository> _repositoryMock = new Mock<IApprovedContractAtomItemRepository>();
            _repositoryMock
                .Setup(m => m.Add(It.Is<AtomFeedItem>(i => i.Identifier.Equals(feedItemId)), It.IsAny<ConnectionInfo>()))
                .Throws(new SqlDuplicateKeyStorageException(new Exception()));
            _repositoryMock
                .Setup(m => m.GetIdentifierForBusinessKey(It.IsAny<string>(), AtomItemType.ApprovedContract, It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(Guid.NewGuid() as Guid?));

            Mock<IContractXmlValidator> contractXmlValidatorMock = new Mock<IContractXmlValidator>();
            contractXmlValidatorMock.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            ApprovedContractAtomFeedItemCreationService _approvedContractAtomFeedItemCreationService =
                new ApprovedContractAtomFeedItemCreationService(Mock.Of<ILogger>(), _repositoryMock.Object, new ContractTransformer(), contractXmlValidatorMock.Object);

            Contract contractApprovedEvent = new ContractApprovedEvent
            {
                CorporateContract = new Contract
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
                                 status = "Approved"
                             }
                         }
                     },
                    contractStatus = new contractStatusType
                    {
                        parentStatus = "Approved",
                        status = "Approved"
                    }
                }
            }.CorporateContract;

            // Act
            AtomItemCreationResult atomItemCreationResult2Nd = _approvedContractAtomFeedItemCreationService.AddApprovedContract(
                contractApprovedEvent,
                feedItemId,
                ConnectionInfo.CreateDefault()).Result;

            // Assert
            Assert.AreEqual(AtomItemCreationResult.AlreadyPresent, atomItemCreationResult2Nd);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAtomFeedItemCreationService_AddApprovedContract_ShouldReturnAlreadyPresentResultWhenCalledWithExistingFeedItemId()
        {
            Guid feedItemId = Guid.NewGuid();
            const string businessKey = "MAIN-1234:1.0";

            // pre-cleanup
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.RemoveWhere(i => i.Identifier == feedItemId || i.BusinessKey == businessKey);
                context.SaveChanges();
            }

            // arrange
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.Add(AtomFeedItem.CreateAtomFeedItem(new Contract(), businessKey, AtomItemType.ApprovedContract, feedItemId, xml => true));
                context.SaveChanges();
            }

            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractManagementDomain.Endpoint.ContractApproved.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped().IsDefault())
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).LifestyleScoped().IsDefault());
            container.BeginScope();
            Mock<IContractXmlValidator> contractXmlValidator = new Mock<IContractXmlValidator>();
            contractXmlValidator.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            IApprovedContractAtomFeedItemCreationService approvedContractAtomFeedItemCreationService = new ApprovedContractAtomFeedItemCreationService(
                Mock.Of<ILogger>(),
                new ApprovedContractAtomItemRepository(), new ContractTransformer(), contractXmlValidator.Object);
            ContractManagementDbContext dbContext = new ContractManagementDbContext();

            // act
            AtomItemCreationResult atomItemCreationResult = approvedContractAtomFeedItemCreationService.AddApprovedContract(new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "MAIN-1234",
                        contractVersionNumber = 1,
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            }, feedItemId, new ConnectionInfo(null, dbContext.Database.Connection)).Result;

            // assert
            Assert.AreEqual(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, atomItemCreationResult);
        }
    }
}
