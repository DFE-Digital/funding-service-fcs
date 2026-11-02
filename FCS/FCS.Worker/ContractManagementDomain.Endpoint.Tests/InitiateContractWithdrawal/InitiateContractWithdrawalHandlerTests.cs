namespace ContractManagementDomain.Endpoint.Tests.InitiateContractWithdrawal
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.InitiateContractWithdrawal;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractWithdrawal;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class InitiateContractWithdrawalHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<InitiateContractWithdrawalHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<InitiateContractWithdrawalHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_RequestSourceFcs_GetCorporateContractForSpecificVersion_SendsMessageOnBus()
        {
            // arrange
            contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            InitiateContractWithdrawalCommand testMessage = new InitiateContractWithdrawalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                ContractVersionNumber = 1,
                ContractWithdrawalType = ContractWithdrawalType.Agency
            };

            InitiateContractWithdrawalHandler handler = new InitiateContractWithdrawalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IXrmManager>(),
                contractsManagerMock.Object,
                Mock.Of<IDateProvider>());

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            Assert.AreEqual(1, context.PublishedMessages
                .Select(m => m.Message)
                .OfType<ContractWithdrawnEvent>()
                .Count(e => e.CorporateContract == corpContract && e.ContractWithdrawalType == testMessage.ContractWithdrawalType));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_ShouldPublishContractWithdrawnEventWithIncrementContractVersionNumberSetToTrueWhenRequiredByCommand()
        {
            // arrange
            const string masterContractNumber = "11";
            const string contractNumber = "1";
            const int contractVersionNumber = 1;

            contract corpContract = ReturnPopulatedCorporateContract(masterContractNumber, contractNumber, CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion(contractNumber, masterContractNumber, contractVersionNumber))
                .Returns(corpContract);

            InitiateContractWithdrawalCommand testMessage = new InitiateContractWithdrawalCommand
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber,
                ContractVersionNumber = contractVersionNumber,
                ContractWithdrawalType = ContractWithdrawalType.BulkWithdrawalByAgency,
                IncrementContractVersionNumber = true,
                Ukprn = "10021107"
            };

            InitiateContractWithdrawalHandler handler = new InitiateContractWithdrawalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IXrmManager>(),
                contractsManagerMock.Object,
                Mock.Of<IDateProvider>());

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            ContractWithdrawnEvent sentEvent = context.PublishedMessages.Select(m => m.Message).OfType<ContractWithdrawnEvent>().SingleOrDefault();

            Assert.IsNotNull(sentEvent, "We have not published an event");
            Assert.AreEqual(corpContract, sentEvent.CorporateContract, "We have not received the correct CorporateContract");
            Assert.AreEqual(ContractWithdrawalType.BulkWithdrawalByAgency, sentEvent.ContractWithdrawalType, "We have not received the correct ContractWithdrawalType");
            Assert.AreEqual(testMessage.Ukprn, sentEvent.Ukprn, "We have not received the correct Ukprn");
            Assert.AreEqual(testMessage.IncrementContractVersionNumber, sentEvent.IncrementContractVersionNumber, "We have not received the correct IncrementContractVersionNumber");
            Assert.AreEqual(CorporateSchema.contractStatusTypeStatus.WithdrawnByAgency.ToString(), sentEvent.CorporateContract.contracts[0].contractStatus.status, "We have not received the correct Corporate Contract Status");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_ShouldPublishContractWithdrawnEventWithIncrementContractVersionNumberSetToFalseWhenNotRequiredByCommand()
        {
            // arrange
            const string masterContractNumber = "11";
            const string contractNumber = "1";
            const int contractVersionNumber = 1;

            contract corpContract = ReturnPopulatedCorporateContract(masterContractNumber, contractNumber, CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion(contractNumber, masterContractNumber, contractVersionNumber))
                .Returns(corpContract);

            InitiateContractWithdrawalCommand testMessage = new InitiateContractWithdrawalCommand
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber,
                ContractVersionNumber = contractVersionNumber,
                ContractWithdrawalType = ContractWithdrawalType.BulkWithdrawalByAgency,
                IncrementContractVersionNumber = false,
                Ukprn = "10021107"
            };

            InitiateContractWithdrawalHandler handler = new InitiateContractWithdrawalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IXrmManager>(),
                contractsManagerMock.Object,
                Mock.Of<IDateProvider>());

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            Assert.AreEqual(1, context.PublishedMessages
                .Select(m => m.Message)
                .OfType<ContractWithdrawnEvent>()
                .Count(e => e.IncrementContractVersionNumber == false));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_RequestSourceFcs_PopulatesWithdrawnDate_AndSetsStatusAndUpdateCRMToWirthdrawnByAgency()
        {
            // arrange
            DateTime testDate = new DateTime(2016, 1, 1);

            contract corpContract = ReturnPopulatedCorporateContract("11", "1",
                CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            Mock<IDateProvider> dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(d => d.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(testDate);

            Mock<IXrmManager> xrmManagerMock = new Mock<IXrmManager>();
               
            InitiateContractWithdrawalCommand testMessage = new InitiateContractWithdrawalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                ContractVersionNumber = 1,
                ContractWithdrawalType = ContractWithdrawalType.Agency
            };

            InitiateContractWithdrawalHandler handler = new InitiateContractWithdrawalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                xrmManagerMock.Object,
                contractsManagerMock.Object,
                dateProviderMock.Object);

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            xrmManagerMock.Verify(
                m => m.UpdateContractForWithdrawalSuccessful(It.Is<contractType>(c => c.contractNumber == "1")),
                Times.Once,
                $"Update for Agency Withdrawal was not called on {nameof(IXrmManager)}");

            ContractWithdrawnEvent publishedEvent = context.PublishedMessages.Select(m => m.Message).OfType<ContractWithdrawnEvent>().SingleOrDefault();

            Assert.IsNotNull(publishedEvent, "ContractWithdrawnEvent was not published");

            contractType contract = publishedEvent.CorporateContract.contracts.Single();
            Assert.AreEqual(CorporateSchema.contractStatusTypeParentStatus.Withdrawn.ToString(), contract.contractStatus.parentStatus);
            Assert.AreEqual(CorporateSchema.contractStatusTypeStatus.WithdrawnByAgency.ToString(), contract.contractStatus.status);

            DateTime? withdrawalDate = contract.StatusLastUpdatedDate;
            Assert.IsNotNull(withdrawalDate);
            Assert.AreEqual(testDate, withdrawalDate.Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_RequestSourceFcs_SetsStatusAndUpdateCRMToOnBehalfOfProvider()
        {
            // arrange
            contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            Mock<IXrmManager> xrmManagerMock = new Mock<IXrmManager>();

            InitiateContractWithdrawalCommand testMessage = new InitiateContractWithdrawalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                ContractVersionNumber = 1,
                ContractWithdrawalType = ContractWithdrawalType.OnBehalfOfProvider
            };

            InitiateContractWithdrawalHandler handler = new InitiateContractWithdrawalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                xrmManagerMock.Object,
                contractsManagerMock.Object,
                Mock.Of<IDateProvider>());

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            xrmManagerMock.Verify(
                m => m.UpdateContractForWithdrawalByProviderSuccessful(It.Is<contractType>(c => c.contractNumber == "1")),
                Times.Once,
                $"Update for Agency Withdrawal was not called on {nameof(IXrmManager)}");

            ContractWithdrawnEvent publishedEvent = context.PublishedMessages.Select(m => m.Message).OfType<ContractWithdrawnEvent>().SingleOrDefault();
            Assert.IsNotNull(publishedEvent, "ContractWithdrawnEvent was not published");

            contractType contract = publishedEvent.CorporateContract.contracts.Single();
            Assert.AreEqual(CorporateSchema.contractStatusTypeParentStatus.Withdrawn.ToString(), contract.contractStatus.parentStatus);
            Assert.AreEqual(CorporateSchema.contractStatusTypeStatus.WithdrawnByProvider.ToString(), contract.contractStatus.status);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_RequestSourceExternal_SetsStatusAutoWithdrawnAndEnsureCrmUpdatedToAutowithdrawn()
        {
            // arrange
            contract corpContract = ReturnPopulatedCorporateContract("11", "1", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            Mock<IXrmManager> xrmManagerMock = new Mock<IXrmManager>();

            InitiateContractWithdrawalCommand testMessage = new InitiateContractWithdrawalCommand
            {
                ContractNumber = "1",
                MasterContractNumber = "11",
                ContractVersionNumber = 1,
                RequestSource = WithdrawalRequestSource.Fcs,
                ContractWithdrawalType = ContractWithdrawalType.AutoWithdrawal
            };

            InitiateContractWithdrawalHandler handler = new InitiateContractWithdrawalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                xrmManagerMock.Object,
                contractsManagerMock.Object,
                Mock.Of<IDateProvider>());

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(testMessage, context).Wait();

            // assert
            xrmManagerMock.Verify(
                m => m.UpdateContractForAutoWithdrawalSuccessful(It.Is<contractType>(c => c.contractNumber == "1")),
                Times.Once,
                $"Update for Agency Withdrawal was not called on {nameof(IXrmManager)}");

            ContractWithdrawnEvent publishedEvent = context.PublishedMessages.Select(m => m.Message).OfType<ContractWithdrawnEvent>().SingleOrDefault();
            Assert.IsNotNull(publishedEvent, "ContractWithdrawnEvent was not published");

            contractType contract = publishedEvent.CorporateContract.contracts.Single();

            Assert.AreEqual(CorporateSchema.contractStatusTypeParentStatus.Withdrawn.ToString(), contract.contractStatus.parentStatus);
            Assert.AreEqual(CorporateSchema.contractStatusTypeStatus.AutoWithdrawn.ToString(), contract.contractStatus.status);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_ShouldPublishContractWithdrawnEventWithShouldShouldAddPayableNonLevyAllocationCorrectlySet()
        {
            // arrange
            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(m => m.GetCorporateContractForSpecificVersion(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>()))
                .Returns(new contract
                {
                    hierarchyType = hierarchyType.MASTERCONTRACT,
                    contracts = new List<contractType>
                    {
                        new contract
                        {
                            contractStatus = new contractStatusType
                            {
                                parentStatus = "Draft",
                                status = "Published to Provider"
                            }
                        }
                    }
                });

            InitiateContractWithdrawalHandler handler = new InitiateContractWithdrawalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IXrmManager>(),
                contractsManagerMock.Object,
                Mock.Of<IDateProvider>());

            InitiateContractWithdrawalCommand command = new InitiateContractWithdrawalCommand
            {
                MasterContractNumber = "ESFA-1234",
                ContractNumber = "LEVY-1234",
                ContractVersionNumber = 1,
                ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment = true
            };

            TestableInvokeHandlerContext context = new TestableInvokeHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            ContractWithdrawnEvent publishedEvent = context.PublishedMessages.Select(pm => pm.Message).OfType<ContractWithdrawnEvent>().Single();

            Assert.AreEqual(true, publishedEvent.ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment);
        }

        private static contract ReturnPopulatedCorporateContract(string masterContractNumber, string contractNumber, string contractParentStatus, string contractSubStatus = "Published To Provider")
        {
            return new contract
            {
                contractNumber = masterContractNumber,
                contracts =
                    {
                        new contract
                        {
                            contractNumber = contractNumber,
                            contractStatus = new contractStatusType
                            {
                                parentStatus = contractParentStatus,
                                status = contractSubStatus
                            }
                        }
                    }
            };
        }
    }
}
