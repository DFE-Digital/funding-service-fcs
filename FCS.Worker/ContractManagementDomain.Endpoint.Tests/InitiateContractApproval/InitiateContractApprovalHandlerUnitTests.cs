namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.InitiateContractApproval;
    using Endpoint.InitiateContractApproval.Dtos;
    using Endpoint.InitiateContractApproval.Repositories;
    using Endpoint.InitiateContractApproval.Services;
    using Endpoint.Repositories;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class InitiateContractApprovalHandlerUnitTests
    {
        private Mock<IMonthEndHistoryRepository> _monthEndHistoryRepository;
        private Mock<IContractCheckerService> _contractCheckerServiceMock;
        private Mock<IDateProvider> _dateProviderMock;
        private Mock<ICrmContractDeliverablePeriodRepository> _crmContractDeliverablePeriodRepositoryMock;
        private Mock<ICrmContractRepository> _crmContractRepositoryMock;
        private Mock<ICrmContractAllocationRepository> _crmContractAllocationRepositoryMock;
        private Mock<IFundingTypeFundingPeriodService> _fundingTypeFundingPeriodServiceMock;
        private Mock<IXrmManager> _xrmManagerMock;
        private Mock<IContractsManager> _contractsManagerMock;
        private InitiateContractApprovalHandler _handler;
        private TestableMessageHandlerContext _messageHandlerContext;

        [TestInitialize]
        public void TestInitialize()
        {
            _monthEndHistoryRepository = new Mock<IMonthEndHistoryRepository>();
            _contractCheckerServiceMock = new Mock<IContractCheckerService>();
            _dateProviderMock = new Mock<IDateProvider>();
            _crmContractDeliverablePeriodRepositoryMock = new Mock<ICrmContractDeliverablePeriodRepository>();
            _crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            _crmContractAllocationRepositoryMock = new Mock<ICrmContractAllocationRepository>();
            _fundingTypeFundingPeriodServiceMock = new Mock<IFundingTypeFundingPeriodService>();
            _xrmManagerMock = new Mock<IXrmManager>();
            _contractsManagerMock = new Mock<IContractsManager>();
            _messageHandlerContext = new TestableMessageHandlerContext();
            _handler = new InitiateContractApprovalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                _monthEndHistoryRepository.Object,
                _contractCheckerServiceMock.Object,
                _dateProviderMock.Object,
                _crmContractDeliverablePeriodRepositoryMock.Object,
                _crmContractRepositoryMock.Object,
                _crmContractAllocationRepositoryMock.Object,
                _fundingTypeFundingPeriodServiceMock.Object,
                _xrmManagerMock.Object,
                _contractsManagerMock.Object);

            ConfigurationManager.AppSettings["ContractManagement.DeferMinutes"] = "10";
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<InitiateContractApprovalHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<InitiateContractApprovalHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_DoesNotInitiateApprovalWhen_ContractStatusIsNotInCorrectState()
        {
            // arrange
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.Fcs,
                ContractVersionNumber = 1
            };

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeStatus.Approved.ToString(), CorporateSchema.contractStatusTypeParentStatus.Approved.ToString(), 1);

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(s => s.UpdateContractForManualApproval(It.IsAny<contractType>()), Times.Never);
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<PublishApprovedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_DoesNotInitiateApprovalWhen_ContractSubStatusIsNotInCorrectState()
        {
            // arrange
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.Fcs,
                ContractVersionNumber = 1
            };

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeStatus.Approved.ToString(), CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);

            _contractsManagerMock.Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1)).Returns(corpContract);

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(s => s.UpdateContractForManualApproval(It.IsAny<contractType>()), Times.Never);
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<PublishApprovedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_DoesNotInitiateApprovalAndDoesWriteInCRMWhen_ContractApprovalAfterContractActivityCloseDate()
        {
            // arrange
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.Fcs,
                ContractVersionNumber = 1
            };

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeStatus.PublishedToProvider.ToString(), CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);
            
            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);


            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(s => s.UpdateContractForManualFailure(It.IsAny<contractType>(), It.IsAny<string>()), Times.Once);
            _xrmManagerMock.Verify(s => s.UpdateContractForManualApproval(It.IsAny<contractType>()), Times.Never);
            Assert.AreEqual(0, _messageHandlerContext.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_DoesInitiateApprovalWhen_ContractApprovalBeforeContractActivityCloseDate()
        {
            // arrange
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.Fcs,
                ContractVersionNumber = 1
            };

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(s => s.UpdateContractForManualApproval(It.IsAny<contractType>()), Times.Once);
            _xrmManagerMock.Verify(s => s.UpdateContractForManualFailure(It.IsAny<contractType>(), It.IsAny<string>()), Times.Never);
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<PublishApprovedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_DoesNotInitiateApprovalAndNotUpdateCRMWhen_ContractApprovalAfterContractActivityCloseDateForExternalApproval()
        {
            // arrange
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.External,
                ContractVersionNumber = 1
            };

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeStatus.PublishedToProvider.ToString(), CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(s => s.UpdateContractForManualFailure(It.IsAny<contractType>(), It.IsAny<string>()), Times.Never);
            _xrmManagerMock.Verify(s => s.UpdateContractForManualApproval(It.IsAny<contractType>()), Times.Never);
            Assert.AreEqual(0, _messageHandlerContext.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_CalledWithValidMasterAndContractNumber_CallsGetCorporateContractForSpecificVersiontWhenVersionNumberIsLessThan1()
        {
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                ContractVersionNumber = 1
            };

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeStatus.PublishedToProvider.ToString(), CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);


            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _contractsManagerMock.Verify(x => x.GetCorporateContractForSpecificVersion(testMessage.ContractNumber, testMessage.MasterContractNumber, testMessage.ContractVersionNumber));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_RequestSourceExternal_GetCorporateContractReturnsContract_SendsMessageOnBus()
        {
            // arrange
            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.External,
                ContractVersionNumber = 1
            };

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(x => x.UpdateContractForElectronicApproval(corpContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_RequestSourceFcs_GetCorporateContractReturnsContract_SendsMessageOnBus()
        {
            // arrange
            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.Fcs,
                ContractVersionNumber = 1
            };

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(x => x.UpdateContractForManualApproval(corpContract.contracts.First()));
            Assert.AreEqual(1, _messageHandlerContext.SentMessages
                .Select(sm => sm.Message)
                .OfType<PublishApprovedContractCommand>()
                .Count(p => p.MasterContractNumber == corpContract.contractNumber && p.ContractNumber == corpContract.contracts.First().contractNumber));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_MonthEndIsNotRunning_ShouldNot_DeferSend()
        {
            // arrange
            _monthEndHistoryRepository
                .Setup(m => m.IsMonthEndInProgress(It.IsAny<ConnectionInfo>()))
                .Returns(false);

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.External,
                ContractVersionNumber = 1
            };

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(0, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<InitiateContractApprovalCommand>().Count());
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<PublishApprovedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_ShouldDeferWhenContractVersionGreaterThan1AndMonthEndInProgress()
        {
            // arrange
            _monthEndHistoryRepository
                .Setup(m => m.IsMonthEndInProgress(It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);
            corpContract.contracts.First().contractVersionNumber = 2;

            _contractsManagerMock.Setup(x => x.GetCorporateContract("1", "11", false)).Returns(corpContract);

            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.External,
                ContractVersionNumber = 2
            };

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<InitiateContractApprovalCommand>().Count());
            Assert.AreEqual(0, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<PublishApprovedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_ShouldNotDeferWhenContractVersionIs1AndMonthEndInProgress()
        {
            // arrange
            _monthEndHistoryRepository
                .Setup(m => m.IsMonthEndInProgress(It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);
            corpContract.contracts.First().contractVersionNumber = 1;

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                RequestSource = ApprovalRequestSource.External,
                ContractVersionNumber = 1
            };

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(0, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<InitiateContractApprovalCommand>().Count());
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<PublishApprovedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_ShouldNotUpdateAgreementStartDateWhenContractWasPreviouslyApproved()
        {
            // arrange 
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                ContractVersionNumber = 1
            };

            _crmContractRepositoryMock
                .Setup(x => x.HasContractBeenApproved(It.IsAny<string>()))
                .Returns(true);

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act 
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _crmContractRepositoryMock.Verify(x => x.UpdateStartDate(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never, "Contract UpdateStartDate was incorrectly called");
            _crmContractAllocationRepositoryMock.Verify(x => x.UpdateStartDate(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never, "Contract Allocation UpdateStartDate was incorrectly called");
            _crmContractDeliverablePeriodRepositoryMock.Verify(x => x.UpdatePeriod(It.IsAny<Guid>(), It.IsAny<int>(), It.IsAny<int>()), Times.Never, "Contract Deliverable Period UpdatePeriod was incorrectly called");
            _crmContractDeliverablePeriodRepositoryMock.Verify(x => x.GetContractDeliverablePeriods(It.IsAny<string>(), It.IsAny<int>()), Times.Never, "Contract Deliverable Period GetContractDeliverablePeriods was incorrectly called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractApprovalHandler_ShouldNotUpdateAgreementStartDateWhenIsContractNotApprovedAndFundingTypeFundingPeriodHasDefaultContractStartDateReturnsFalse()
        {
            // arrange 
            InitiateContractApprovalCommand testMessage = new InitiateContractApprovalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                ContractVersionNumber = 1
            };

            _contractCheckerServiceMock
                .Setup(x => x.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.NotLevy);

            // act 
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _crmContractRepositoryMock.Verify(x => x.UpdateStartDate(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never, "Contract UpdateStartDate was incorrectly called");
            _crmContractAllocationRepositoryMock.Verify(x => x.UpdateStartDate(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never, "Contract Allocation UpdateStartDate was incorrectly called");
            _crmContractDeliverablePeriodRepositoryMock.Verify(x => x.UpdatePeriod(It.IsAny<Guid>(), It.IsAny<int>(), It.IsAny<int>()), Times.Never, "Contract Deliverable Period UpdatePeriod was incorrectly called");
            _crmContractDeliverablePeriodRepositoryMock.Verify(x => x.GetContractDeliverablePeriods(It.IsAny<string>(), It.IsAny<int>()), Times.Never, "Contract Deliverable Period GetContractDeliverablePeriods was incorrectly called");
        }

        private static Contract ReturnPopulatedCorporateContract(string masterContractNumber, string contractNumber, string contractStatus, string contractParentStatus, int version)
        {
            return new Contract
            {
                contractNumber = masterContractNumber,
                contracts =
                {
                    new Contract
                    {
                        contractNumber = contractNumber,
                        contractStatus = new contractStatusType
                        {
                            status =contractStatus,
                            parentStatus = contractParentStatus
                        },
                        contractVersionNumber = version
                    }
                }
            };
        }
    }
}
