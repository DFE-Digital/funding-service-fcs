namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using System.Collections.Generic;
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Moq;
    using ContractManagementService.Common;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Common.Extensions;
    using CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using CrossDomain.Integration.Entities.ContractWithdrawal;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using NServiceBus;
    using NServiceBus.Testing;
    using PublishContractWithdrawalEndpoint;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class PublishContractWithdrawalHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractWithdrawalHandler_Handle_ShouldCallRepository_ToAddAtomItem()
        {
            // arrange 
            Mock<IWithdrawnContractAtomItemRepository> repositoryMock  = new Mock<IWithdrawnContractAtomItemRepository>();
            Mock<IContractTransformer> contractTransformerMock = new Mock<IContractTransformer>();
            Mock<IContractXmlValidator> mockContractXmlValidator = new Mock<IContractXmlValidator>();
            mockContractXmlValidator.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            contractTransformerMock.Setup(
                m => m.TransformToCorporateSchemaContract(It.IsAny<contract>())).Returns(new CorporateSchema.contract());

            PublishContractWithdrawalHandler handler = new PublishContractWithdrawalHandler(Mock.Of<ILogger>(), repositoryMock.Object, 
                                                                                            contractTransformerMock.Object, mockContractXmlValidator.Object, Mock.Of<ISessionConnectionFactory>());

            // act
            handler.Handle(new ContractWithdrawnEvent
            {
                CorporateContract = new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Contract-001",
                            contractVersionNumber = 1
                        }
                    }
                },
                IncrementContractVersionNumber = false
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            repositoryMock.Verify(
                m => m.Add(It.IsAny<AtomFeedItem>(), It.IsAny<ConnectionInfo>()),
                Times.Once,
                "PublishContractWidthdrawalHandler did not add to the Atom Feed Item repository.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractWithdrawalHandler_Handle_Should_Handle_Duplicate_Key_Storage_Exception()
        {
            // arrange 
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IWithdrawnContractAtomItemRepository> repositoryMock = new Mock<IWithdrawnContractAtomItemRepository>();
            Mock<IContractTransformer> contractTransformerMock = new Mock<IContractTransformer>();
            Mock<IContractXmlValidator> mockContractXmlValidator = new Mock<IContractXmlValidator>();
            mockContractXmlValidator.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            PublishContractWithdrawalHandler handler = new PublishContractWithdrawalHandler(loggerMock.Object, repositoryMock.Object, 
                                                                                            contractTransformerMock.Object,
                                                                                            mockContractXmlValidator.Object, Mock.Of<ISessionConnectionFactory>());

            contractTransformerMock.Setup(
                m => m.TransformToCorporateSchemaContract(It.IsAny<contract>())).Returns(new CorporateSchema.contract());

            repositoryMock
                .Setup(m => m.Add(It.IsAny<AtomFeedItem>(), It.IsAny<ConnectionInfo>()))
                .Throws(new DuplicateKeyStorageException(new Exception()));

            // act
            handler.Handle(new ContractWithdrawnEvent
            {
                CorporateContract = new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Contract-001",
                            contractVersionNumber = 1
                        }
                    }
                },
                IncrementContractVersionNumber = false
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            loggerMock.Verify(c=>c.LogError(ContractManagementLoggingEvents.PublishContractReadyToWithdrawEventFailed, It.IsAny<DuplicateKeyStorageException>(), It.IsAny<string>()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractWithdrawalHandler_Handle_ShouldSendIncrementContractVersionCommandWhenIncrementContractVersionNumberSetToTrue()
        {
            // arrange
            Mock<IWithdrawnContractAtomItemRepository> repositoryMock = new Mock<IWithdrawnContractAtomItemRepository>();
            Mock<IContractTransformer> contractTransformerMock = new Mock<IContractTransformer>();
            Mock<IContractXmlValidator> mockContractXmlValidator = new Mock<IContractXmlValidator>();
            mockContractXmlValidator.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            contractTransformerMock.Setup(
                m => m.TransformToCorporateSchemaContract(It.IsAny<contract>())).Returns(new CorporateSchema.contract());

            PublishContractWithdrawalHandler handler = new PublishContractWithdrawalHandler(Mock.Of<ILogger>(), repositoryMock.Object, 
                                                                                            contractTransformerMock.Object,
                                                                                            mockContractXmlValidator.Object, Mock.Of<ISessionConnectionFactory>());

            const string masterContractNumber = "11";
            const string contractNumber = "1";
            const int contractVersionNumber = 1;

            var corpContract = ReturnPopulatedCorporateContract(masterContractNumber, contractNumber, contractVersionNumber,
                               CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            ContractWithdrawnEvent contractWithdrawnEvent = new ContractWithdrawnEvent
            {
                CorporateContract = corpContract,
                ContractWithdrawalType = ContractWithdrawalType.BulkWithdrawalByAgency,
                IncrementContractVersionNumber = true,
                Ukprn = "10021107",
                ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment = true
            };
            var messageHandlerContext = new TestableMessageHandlerContext();
            // act
            handler.Handle(contractWithdrawnEvent, messageHandlerContext).Wait();

            // assert
            IncrementContractVersionCommand sentCommand =
                messageHandlerContext.SentMessages.FirstOrDefault()?.Message as IncrementContractVersionCommand;

            Assert.IsNotNull(sentCommand, "We have not sent a command");
            Assert.AreEqual(contractNumber, sentCommand.ContractNumber, "We have not set ContractNumber");
            Assert.AreEqual(corpContract.contracts.Single().contractVersionNumber, sentCommand.VersionNumber, "We have not set ContractVersionNumber");
            Assert.AreEqual(corpContract.contracts.Single().contractSubVersionNumber, sentCommand.SubVersionNumber, "We have not set SubVersionNumber");
            Assert.AreEqual(ContractManagementService.Common.AmendmentType.Variation, sentCommand.AmendmentType, "AmendmentType is incorrect on the sent command");
            Assert.AreEqual(true, sentCommand.ShouldAddPayableNonLevyAllocation, "We have not set ShouldAddPayableNonLevyAllocation");
            Assert.IsFalse(sentCommand.IsNonFinancialAmendment, "IsNonFinancialAmendment should be false for incrementing contract version from PublishContractWithdrawalHandler");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractWidthdrawalHandler_Handle_ContractWithdrawnEvent_ShouldNotSendIncrementContractVersionCommandWhenIncrementContractVersionNumberSetToFalse()
        {
            // arrange
            Mock<IWithdrawnContractAtomItemRepository> repositoryMock = new Mock<IWithdrawnContractAtomItemRepository>();
            Mock<IContractTransformer> contractTransformerMock = new Mock<IContractTransformer>();
            Mock<IContractXmlValidator> mockContractXmlValidator = new Mock<IContractXmlValidator>();
            mockContractXmlValidator.Setup(v => v.IsValid(It.IsAny<string>())).Returns(true);

            contractTransformerMock.Setup(
                m => m.TransformToCorporateSchemaContract(It.IsAny<contract>())).Returns(new CorporateSchema.contract());

            PublishContractWithdrawalHandler handler = new PublishContractWithdrawalHandler(Mock.Of<ILogger>(), repositoryMock.Object,
                                                                                            contractTransformerMock.Object, mockContractXmlValidator.Object, Mock.Of<ISessionConnectionFactory>());

            const string masterContractNumber = "11";
            const string contractNumber = "1";
            const int contractVersionNumber = 1;

            var corpContract = ReturnPopulatedCorporateContract(masterContractNumber, contractNumber, contractVersionNumber,
                CorporateSchema.contractStatusTypeParentStatus.Draft.ToString());

            ContractWithdrawnEvent contractWithdrawnEvent = new ContractWithdrawnEvent
            {
                CorporateContract = corpContract,
                ContractWithdrawalType = ContractWithdrawalType.BulkWithdrawalByAgency,
                IncrementContractVersionNumber = false,
                Ukprn = "10021107"
            };

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(contractWithdrawnEvent, context).Wait();
            // assert

            Assert.IsTrue(context.SentMessages.Empty(), "IncrementContractVersionCommand incorrectly called");
        }

        private static contract ReturnPopulatedCorporateContract(string masterContractNumber,
            string contractNumber, int contractVersionNumber,
            string contractParentStatus, string contractSubStatus = "Published To Provider")
        {
            return new contract
            {
                contractNumber = masterContractNumber,
                contracts =
                {
                    new contract
                    {
                        contractNumber = contractNumber,
                        contractVersionNumber = contractVersionNumber,
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

