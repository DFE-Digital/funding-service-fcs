namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using Endpoint.Services;

    [TestClass]
    public class ContractValidationLookupDataTests : IntegrationTestBase
    {
        [TestInitialize, TestCleanup]
        public void TestCleanUp()
        {
            try
            {
                CorporateContract.contract corporateContract = GetCorpContract();
                DeleteContractsWithContractNumber(corporateContract.contracts.Single().contractNumber);
                DeleteContractsWithContractNumber(corporateContract.contractNumber);
            }
            catch (FaultException fe)
            {
                if (fe.Message.Contains("Does Not Exist") || fe.Message.Contains("No object matched the query"))
                {
                   // don't do anything
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateContractWithDraftStatusAndAwaitingDocumentSubStatus_And_InitiateDocMergeTaskIsAssignedToDocMgmtTeam()
        {
            // arrange
            var container = GetEndpointContainer();

            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();
            masterContract.contracts.First().DocumentationRequired = true;

            var contractsManager = container.Resolve<IContractsManager>();
            contractsManager.BatchId = batchId;
            Guid masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.AreNotSame(Guid.Empty, masterContractGuid);

            ContractRequest.contractType draftContractType = contractsManager.GetLatestContract(
                masterContract.contractNumber, masterContract.contracts.Select(c => c.contractNumber));
            draftContractType.contracts[0].PreviousVersionId = draftContractType.contracts[0].Id;

            ContractRequest.contractRequestType draftContractRequestType = new ContractRequest.contractRequestType
            {
                contract = draftContractType
            };

            // act
            ContractMustBeInCorrectStateRule rule = new ContractMustBeInCorrectStateRule();

            // assert
            Assert.IsFalse(rule.GetFailuresForItem(draftContractRequestType).Any(), "The rule {0} fails for Update Draft", rule.RuleNumber);
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void CreateLookupDataAndSetContractPresence_RevisedNewContract_NotAllPreviousContractsWithdrawn_ShouldSetIsNonWithdrawnContractWithContractNumberPresentInCrmPropertyTrue()
        {
            Assert.IsTrue(IsNonWithdrawnContractwithContractNumberPresentInCrmFollowingContractCreate(sfa_contractstatus.Approved),
                "IsNonWithdrawnContractWithContractNumberPresentInCrm was not set to true.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreateLookupDataAndSetContractPresence_RevisedNewContract_AllPreviousContractsWithdrawn_ShouldSetIsNonWithdrawnContractWithContractNumberPresentInCrmPropertyFalse()
        {
            Assert.IsFalse(IsNonWithdrawnContractwithContractNumberPresentInCrmFollowingContractCreate(sfa_contractstatus.Withdrawn),
                "IsNonWithdrawnContractWithContractNumberPresentInCrm was not set to false.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreateLookupDataAndSetContractPresence_RevisedNewContract_AllPreviousContractsWithdrawnOrSupersededDraft_ShouldSetIsNonWithdrawnContractWithContractNumberPresentInCrmPropertyFalse()
        {
            Assert.IsFalse(IsNonWithdrawnContractwithContractNumberPresentInCrmFollowingContractCreate(sfa_contractstatus.SupersededDraft, sfa_contractstatus.Withdrawn),
                "IsNonWithdrawnContractWithContractNumberPresentInCrm was not set to false.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreateLookupDataAndSetContractPresence_NewLevyContract_PreviousApprovedLevyContractExists_ShouldSetIsDraftOrApprovedContractForUkprnPresentInCrmToTrue()
        {
            Assert.IsTrue(IsDraftOrApprovedLevyContractForUkprnPresentInCrmFollowingContractCreate(status: sfa_contractstatus.Approved, shouldCreateContract: true));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreateLookupDataAndSetContractPresence_NewLevyContract_PreviousDraftLevyContractExists_ShouldSetIsDraftOrApprovedContractForUkprnPresentInCrmToTrue()
        {
            Assert.IsTrue(IsDraftOrApprovedLevyContractForUkprnPresentInCrmFollowingContractCreate(status: sfa_contractstatus.Draft, shouldCreateContract: true));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreateLookupDataAndSetContractPresence_NewLevyContract_WithdrawnLevyContractExists_ShouldSetIsDraftOrApprovedContractForUkprnPresentInCrmToFalse()
        {
            Assert.IsFalse(IsDraftOrApprovedLevyContractForUkprnPresentInCrmFollowingContractCreate(status: sfa_contractstatus.Withdrawn, shouldCreateContract: true));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreateLookupDataAndSetContractPresence_NewLevyContract_NoLevyContractExists_ShouldSetIsDraftOrApprovedContractForUkprnPresentInCrmToFalse()
        {
            Assert.IsFalse(IsDraftOrApprovedLevyContractForUkprnPresentInCrmFollowingContractCreate(status: sfa_contractstatus.Withdrawn, shouldCreateContract: false));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractValidationLookupCreator_CreateLookupDataAndSetContractPresence_ShouldPopulateUnitOfProcurementReferenceData()
        {
            // arrange
            var container = GetEndpointContainer();

            Mock<IFundingStreamConfigService> fscServiceMock = new Mock<IFundingStreamConfigService>();
            fscServiceMock
                .Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });
            Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository> mockFtpFspRepository = 
                new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();

            mockFtpFspRepository.Setup(m => m.GetByFundingType(It.IsAny<string>()))
                                .Returns(new List<FundingTypePeriodFundingStreamPeriod>
                                {
                                    new FundingTypePeriodFundingStreamPeriod("24+LOANS", "AY1516", "24+ALLB")
                                });
            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var contractValidationLookupDataCreator = new Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());


            ContractRequest.contractRequestType contract = GetContractRequest();
            contract.contract.contractNumber = null;
            contract.contract.contractAllocations.ForEach(a => a.contractAllocationNumber = null);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contract, connectionInfo);

                // assert
                Assert.IsNotNull(lookupData.UnitsOfProcurement, "Returned reference data was null.");
                Assert.IsTrue(lookupData.UnitsOfProcurement.Any(), "Returned reference data was empty.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractValidationLookupCreator_CreateLookupDataAndSetContractPresence_ShouldPopulateFtpFspLookupData()
        {
            var container = GetEndpointContainer();

            // arrange
            Mock<IFundingStreamConfigService> fscServiceMock = new Mock<IFundingStreamConfigService>();
            fscServiceMock
                .Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var contractValidationLookupDataCreator = new Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                container.Resolve<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());

            ContractRequest.contractRequestType contract = GetContractRequest();
            contract.contract.contractNumber = null;
            contract.contract.contractAllocations.ForEach(a => a.contractAllocationNumber = null);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contract, connectionInfo);

                // assert
                Assert.IsNotNull(lookupData.FundingTypePeriodFundingStreamPeriods, "Returned reference data was null.");
                Assert.IsTrue(lookupData.FundingTypePeriodFundingStreamPeriods.Any(), "Returned reference data was empty.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractValidationLookupCreator_ShouldSetIsApprovedContractWithContractNumberPresentInCrmTrueIfContractIsApprovedApproved()
        {
            // arrange
            var master = GetContractRequest();
            master.contract.CRMIntent = ContractRequest.intent.Amendment;
            master.contract.contractNumber = "MLDC-T1";
            var contract = master.contract.contracts.First();
            contract.CRMIntent = ContractRequest.intent.Amendment;
            contract.contractNumber = "LDC-T1";

            RemoveContractsFromCrm(contract.contractNumber);
            CreateContractInCrmWithStatusAndSubStatus(contract, sfa_contractstatus.Approved, "Approved");

            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var container = GetEndpointContainer();

            var contractValidationLookupDataCreator = new Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(master, connectionInfo);
            }

            // assert
            Assert.IsTrue(contract.IsApprovedContractWithContractNumberPresentInCrm, "IsApprovedContractWithContractNumberPresentInCrm was not set to true");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractValidationLookupCreator_ShouldSetIsApprovedContractWithContractNumberPresentInCrmTrueIfContractIsApprovedUnderTermination()
        {
            // arrange
            var master = GetContractRequest();
            master.contract.CRMIntent = ContractRequest.intent.Amendment;
            master.contract.contractNumber = "MLDC-T2";
            var contract = master.contract.contracts.First();
            contract.CRMIntent = ContractRequest.intent.Amendment;
            contract.contractNumber = "LDC-T1";

            RemoveContractsFromCrm(contract.contractNumber);
            CreateContractInCrmWithStatusAndSubStatus(contract, sfa_contractstatus.Approved, "Under Termination");

            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var container = GetEndpointContainer();

            var contractValidationLookupDataCreator = new Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(master, connectionInfo);
            }

            // assert
            Assert.IsTrue(contract.IsApprovedContractWithContractNumberPresentInCrm, "IsApprovedContractWithContractNumberPresentInCrm was not set to true");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractValidationLookupCreator_ShouldSetIsApprovedContractWithContractNumberPresentInCrmTrueIfContractIsApprovedModified()
        {
            // arrange
            var master = GetContractRequest();
            master.contract.CRMIntent = ContractRequest.intent.Amendment;
            master.contract.contractNumber = "MLDC-T2";
            var contract = master.contract.contracts.First();
            contract.CRMIntent = ContractRequest.intent.Amendment;
            contract.contractNumber = "LDC-T1";

            RemoveContractsFromCrm(contract.contractNumber);
            CreateContractInCrmWithStatusAndSubStatus(contract, sfa_contractstatus.Approved, "Modified");

            var mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var container = GetEndpointContainer();

            var contractValidationLookupDataCreator = new Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());

            using (var context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                var lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(master, connectionInfo);
            }

            // assert
            Assert.IsTrue(contract.IsApprovedContractWithContractNumberPresentInCrm, "IsApprovedContractWithContractNumberPresentInCrm was not set to true");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractValidationLookupCreator_ShouldSetIsApprovedContractWithContractNumberPresentInCrmFalseIfStatusNotApproved()
        {
            // arrange
            var master = GetContractRequest();
            master.contract.CRMIntent = ContractRequest.intent.Amendment;
            master.contract.contractNumber = "MLDC-T1";
            var contract = master.contract.contracts.First();
            contract.CRMIntent = ContractRequest.intent.Amendment;
            contract.contractNumber = "LDC-T1";

            RemoveContractsFromCrm(contract.contractNumber);
            CreateContractInCrmWithStatusAndSubStatus(contract, sfa_contractstatus.Draft, "Awaiting Documentation");

            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var container = GetEndpointContainer();

            var contractValidationLookupDataCreator = new Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(master, connectionInfo);
            }

            // assert
            Assert.IsFalse(contract.IsApprovedContractWithContractNumberPresentInCrm, "IsApprovedContractWithContractNumberPresentInCrm was wrongly set to true");
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractValidationLookupCreator_ShouldSetIsApprovedContractWithContractNumberPresentInCrmFalseIfSubStatusNotApproved()
        {
            // arrange
            var master = GetContractRequest();
            master.contract.CRMIntent = ContractRequest.intent.Amendment;
            master.contract.contractNumber = "MLDC-T1";
            var contract = master.contract.contracts.First();
            contract.CRMIntent = ContractRequest.intent.Amendment;
            contract.contractNumber = "LDC-T1";

            RemoveContractsFromCrm(contract.contractNumber);
            CreateContractInCrmWithStatusAndSubStatus(contract, sfa_contractstatus.Approved, "Closure Initiation in Progress");

            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var container = GetEndpointContainer();

            var contractValidationLookupDataCreator = new Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(master, connectionInfo);
            }

            // assert
            Assert.IsFalse(contract.IsApprovedContractWithContractNumberPresentInCrm, "IsApprovedContractWithContractNumberPresentInCrm was wrongly set to true");
        }

        private bool IsNonWithdrawnContractwithContractNumberPresentInCrmFollowingContractCreate(sfa_contractstatus previousContractStatus, sfa_contractstatus? secondPreviousStatus = null)
        {
            var container = GetEndpointContainer();

            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };


            var manager = new ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());

            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            IContractsManager contractsManager = container.Resolve<IContractsManager>();
            contractsManager.BatchId = batchId;
            Guid masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            UpdateStatusOnContract(masterContract.contracts[0].contractNumber, 1, 0, previousContractStatus);

            if (secondPreviousStatus.HasValue)
            {
                masterContract.contractSubVersionNumber++;
                masterContract.contracts.Single().contractSubVersionNumber++;
                Guid amendedMasterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
                UpdateStatusOnContract(masterContract.contracts[0].contractNumber, 1, 1, secondPreviousStatus.Value);
            }

            ContractRequest.contractType revisedNewContractType = contractsManager.GetLatestContract(
                masterContract.contractNumber, masterContract.contracts.Select(c => c.contractNumber));
            revisedNewContractType.contracts[0].PreviousVersionId = revisedNewContractType.contracts[0].Id;
            revisedNewContractType.CRMIntent = ContractRequest.intent.RevisedNew;

            ContractRequest.contractRequestType revisedNewContractRequestType = new ContractRequest.contractRequestType
            {
                contract = revisedNewContractType
            };

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = manager.CreateLookupDataAndSetContractPresence(revisedNewContractRequestType, connectionInfo);
            }

            return revisedNewContractType.contracts[0].IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm;
        }

        private bool IsDraftOrApprovedLevyContractForUkprnPresentInCrmFollowingContractCreate(sfa_contractstatus status, bool shouldCreateContract)
        {
            var container = GetEndpointContainer();

            Mock<IFundingStreamConfigService> mockFscService = new Mock<IFundingStreamConfigService>();
            mockFscService.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            var lookupManager = new LookupManager
            {
                OrganizationService = CrmOrganizationService,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            var manager = new ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                container.Resolve<IPolicyConfigRepository>(),
                mockFscService.Object,
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManager,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                Mock.Of<ISiblingContractCheckService>());


            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();
            masterContract.fundingType = new CorporateContract.fundingType
            {
                fundingTypeCode = "LEVY",
                fundingTypeName = "Apprenticeship Levy"
            };

            masterContract.contracts[0].fundingType = new CorporateContract.fundingType
            {
                fundingTypeCode = "LEVY",
                fundingTypeName = "Apprenticeship Levy"
            };

            IContractsManager contractsManager = container.Resolve<IContractsManager>();
            contractsManager.BatchId = batchId;
            if (shouldCreateContract)
            {
                Guid masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
                UpdateStatusOnContract(masterContract.contracts[0].contractNumber, 1, 0, status);
                UpdateStatusOnContract(masterContract.contractNumber, 1, 0, status);
            }

            ContractRequest.contractType newLevyContractType = new ContractRequest.contractType()
            {
                fundingTypeCode = "LEVY",
                contractor = new ContractRequest.contractor
                {
                    ukprn = masterContract.contracts[0].contractor.ukprn
                },
                contracts = new List<ContractRequest.contractType>
                {
                    new ContractRequest.contractType
                    {
                        fundingTypeCode = "LEVY",
                        contractor = new ContractRequest.contractor
                        {
                            ukprn = masterContract.contracts[0].contractor.ukprn
                        },
                    }
                }
            };
            ContractRequest.contractRequestType newLevyRequestType = new ContractRequest.contractRequestType
            {
                contract = newLevyContractType
            };

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                ContractValidationLookupData lookupData = manager.CreateLookupDataAndSetContractPresence(newLevyRequestType, connectionInfo);
            }

            return newLevyContractType.contracts[0].IsDraftOrApprovedContractForUkprnPresentInCrm;
        }

        public ContractRequest.contractRequestType CreateContractRequest(
            string masterContractNumber, string contractNumber, ContractRequest.intent intent, int ukprn)
        {
            ContractRequest.contractRequestType contractRequestType = GetContractRequest();
            contractRequestType.contract.contractNumber = masterContractNumber;
            contractRequestType.contract.contracts.First().contractNumber = contractNumber;
            contractRequestType.contract.contractor.ukprn = ukprn;

            return contractRequestType;
        }

        private void CreateContractInCrmWithStatusAndSubStatus(ContractRequest.contractType contract, sfa_contractstatus status, string subStatus)
        {
            IOrganizationService orgService = CrmOrganizationService;

            sfa_contract newContract = new sfa_contract
            {
                sfa_number = contract.contractNumber,
                sfa_UKPRN = "4321",
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_ProviderName = GetOrgEntityReference()
            };

            Guid contractId = orgService.Create(newContract);

            newContract.Id = contractId;
            newContract.sfa_ContractStatus = new OptionSetValue((int)status);
            newContract.sfa_SubStatus = GetSubStatusEntityReference(subStatus);
            newContract.EntityState = EntityState.Changed;
            orgService.Update(newContract);
        }

        private EntityReference GetOrgEntityReference()
        {
            IOrganizationService orgService = CrmOrganizationService;

            using (XrmServiceContext crmContext = new XrmServiceContext(orgService))
            {
                return crmContext.AccountSet.First().ToEntityReference();
            }
        }

        private EntityReference GetSubStatusEntityReference(string subStatus)
        {
            IOrganizationService orgService = CrmOrganizationService;

            using (var context = new XrmServiceContext(orgService))
            {
                return context.sfa_statusSet.First(s => s.sfa_name == subStatus).ToEntityReference();
            }
        }

        private static void RemoveContractsFromCrm(string contractNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmOrganizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => CrmOrganizationService.Delete(sfa_contract.EntityLogicalName, id));
            }
        }

        private static IWindsorContainer GetEndpointContainer()
        {
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(l => l.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            IWindsorContainer container = new WindsorContainer().Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(loggerFactoryMock.Object));
            container.BeginScope();
            return container;
        }
    }
}