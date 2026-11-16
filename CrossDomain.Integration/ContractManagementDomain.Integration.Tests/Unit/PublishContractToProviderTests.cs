namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common;
    using CrossDomain.Integration.Common.Exceptions;
    using CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using CrossDomain.Integration.Entities.ContractApproval;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PublishContractToProviderEndpoint;

    [TestClass]
    public class PublishContractToProviderTests
    {
        private Mock<ILogger> _loggerMock;
        private Mock<IDraftContractAtomItemRepository> _repositoryMock;
        private Mock<IContractTransformer> _contractTransformerMock;

        private PublishContractToProviderHandler _handler;

        [TestInitialize]
        public void TestInitialize()
        {
            _loggerMock = new Mock<ILogger>();
            _repositoryMock = new Mock<IDraftContractAtomItemRepository>();
            _contractTransformerMock = new Mock<IContractTransformer>();

            _contractTransformerMock.Setup(
                m => m.TransformToCorporateSchemaContract(It.IsAny<Contract>())).Returns(new CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract());

            _handler = new PublishContractToProviderHandler(_loggerMock.Object, _repositoryMock.Object, _contractTransformerMock.Object, Mock.Of<ISessionConnectionFactory>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Calling_ContractApprovedEvent_Handler_Should_Handle_Duplicate_Key_Storage_Exception()
        {
            _repositoryMock
                .Setup(m => m.Add(It.IsAny<AtomFeedItem>()))
                .Throws(new DuplicateKeyStorageException(new Exception()));

            _handler.Handle(new ContractReadyToPublishEvent
            {
                CorporateContract = new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Contract-001",
                            contractVersionNumber = 1
                        }
                    }
                }
            }, new TestableMessageHandlerContext());

            // should not exception
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractToProvider_Handler_ShouldThrowContractValidationException_Catch_Absorb_Log_IfTheContractStatusIsInvalid()
        {
            var corpContract = new Contract
            {
                contractNumber = "11",
                contracts =
                {
                    new contractType
                    {
                        contractNumber = "22",
                        contractStatus = new contractStatusType()
                        {
                            status = "Approval in Progress"
                        }
                    }
                }
            };

            //Arrange
            var testMessage = new ContractReadyToPublishEvent
            {
                CorporateContract = corpContract,
                ContractApprovalType = ContractApprovalType.Electronic
            };


            //Act
           
            _handler.Handle(testMessage, new TestableMessageHandlerContext()).Wait();
            
            //Assert
            _loggerMock.Verify(x => x.LogError(ContractManagementLoggingEvents.PublishContractToProviderFailed, It.IsAny<ContractValidationException>(), It.IsAny<string>()));
            
        }
    }
}
