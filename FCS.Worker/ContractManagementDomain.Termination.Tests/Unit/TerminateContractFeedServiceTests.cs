namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.Repositories;
    using ContractManagementDomain.Termination.Services;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using Termination.Extensions;

    [TestClass]
    public class TerminateContractFeedServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractFeedService_UpdateSubStatusAndAddContractToFeed_UpdatesSubStatusAndReturnsAtomItemCreationResultAdded()
        {
            // Arrange
            const string assertSubStatus = "Under TerminationADD";
            const AtomItemCreationResult assertAtomItemCreationResult = AtomItemCreationResult.Added;
            const string contractNumber = "Contract-001";
            const int versiontNumber = 1;
            const int subVersiontNumber = 0;
            var messageId = new Guid().ToString();
            var contractIdentifier = new ContractIdentifier(contractNumber, versiontNumber, subVersiontNumber);

            var mockApprovalOnwardsContractAtomFeedService = new Mock<IApprovalOnwardsContractAtomFeedService>();
            mockApprovalOnwardsContractAtomFeedService.Setup((m => m.AddContractToFeed(
                It.IsAny<ConnectionInfo>(),
                It.IsAny<Contract>(), 
                It.IsAny<Guid>(), 
                It.IsAny<AtomItemType>())))
                    .Returns(assertAtomItemCreationResult);

            Contract corpContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = contractNumber,
                        contractVersionNumber = versiontNumber,
                        contractSubVersionNumber = subVersiontNumber,
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "BeforeValue"
                        }
                    }
                }
            };
            
            Mock<ICorporateContractService> corporateContractServiceMock = new Mock<ICorporateContractService>();
            corporateContractServiceMock.Setup(ccs => ccs.GetContract(It.IsAny<ConnectionInfo>(),
                It.IsAny<ICrmContractRepository>(),
                It.IsAny<IContractsManager>(), It.IsAny<ILegalDeliverableService>(),
                It.IsAny<ContractIdentifier>())).Returns(corpContract);

            var terminateContractFeedServicekMock = new TerminateContractFeedService(
                It.IsAny<ICrmContractRepository>(),
                Mock.Of<IContractsManager>(), Mock.Of<ILegalDeliverableService>(), 
                Mock.Of<IApprovalOnwardsContractAtomFeedService>(),
                corporateContractServiceMock.Object);

            // Act
            var updateSubStatusAndAddContractToFeedResult = terminateContractFeedServicekMock.UpdateContractAndAddToFeed(
                ConnectionInfo.CreateDefault(), contractIdentifier, c => c.SetChildContractsSubStatus(assertSubStatus), messageId, AtomItemType.ApprovedContract);

            // Assert
            Assert.AreEqual(assertSubStatus, updateSubStatusAndAddContractToFeedResult.CorporateContract.contracts[0].contractStatus.status, 
                "Contract SubStatus was incorrectly set");
            Assert.AreEqual(assertAtomItemCreationResult, updateSubStatusAndAddContractToFeedResult.AtomItemCreationResult, 
                "Incorrect AtomItemCreationResult was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractFeedService_UpdateSubStatusAndAddContractToFeed_UpdatesSubStatusAndReturnsAtomItemCreationResultAlreadyPresent()
        {
            // Arrange
            const string assertSubStatus = "Under TerminationAlreadyPresent";
            const AtomItemCreationResult assertAtomItemCreationResult = AtomItemCreationResult.AlreadyPresent;
            const string contractNumber = "Contract-001";
            const int versiontNumber = 1;
            const int subVersiontNumber = 0;
            var messageId = new Guid().ToString();
            var contractIdentifier = new ContractIdentifier(contractNumber, versiontNumber, subVersiontNumber);

            var mockApprovalOnwardsContractAtomFeedService = new Mock<IApprovalOnwardsContractAtomFeedService>();
            mockApprovalOnwardsContractAtomFeedService.Setup((m => m.AddContractToFeed(
                It.IsAny<ConnectionInfo>(),
                It.IsAny<Contract>(),
                It.IsAny<Guid>(),
                It.IsAny<AtomItemType>())))
                    .Returns(assertAtomItemCreationResult);

            Contract corpContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = contractNumber,
                        contractVersionNumber = versiontNumber,
                        contractSubVersionNumber = subVersiontNumber,
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "BeforeValue"
                        }
                    }
                }
            };

            Mock<ICorporateContractService> corporateContractServiceMock = new Mock<ICorporateContractService>();
            corporateContractServiceMock.Setup(ccs => ccs.GetContract(It.IsAny<ConnectionInfo>(),
                It.IsAny<ICrmContractRepository>(),
                It.IsAny<IContractsManager>(), It.IsAny<ILegalDeliverableService>(),
                It.IsAny<ContractIdentifier>())).Returns(corpContract);

            var terminateContractFeedServicekMock = new TerminateContractFeedService(
                It.IsAny<ICrmContractRepository>(),
                Mock.Of<IContractsManager>(), Mock.Of<ILegalDeliverableService>(),
                mockApprovalOnwardsContractAtomFeedService.Object,
                corporateContractServiceMock.Object);

            // Act
            var updateSubStatusAndAddContractToFeedResult = terminateContractFeedServicekMock.UpdateContractAndAddToFeed(
                ConnectionInfo.CreateDefault(), contractIdentifier, c => c.SetChildContractsSubStatus(assertSubStatus), messageId, AtomItemType.CancelledContractTermination);

            // Assert
            Assert.AreEqual(assertSubStatus, updateSubStatusAndAddContractToFeedResult.CorporateContract.contracts[0].contractStatus.status,
                "Contract SubStatus was incorrectly set");
            Assert.AreEqual(assertAtomItemCreationResult, updateSubStatusAndAddContractToFeedResult.AtomItemCreationResult,
                "Incorrect AtomItemCreationResult was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractFeedService_UpdateSubStatusAndAddContractToFeed_UpdatesSubStatusAndReturnsAtomItemCreationResultAlreadyPresentWithSameFeedItemId()
        {
            // Arrange
            const string assertSubStatus = "Under TerminationAlreadyPresentWithSameFeedItemId";
            const AtomItemCreationResult assertAtomItemCreationResult = AtomItemCreationResult.AlreadyPresentWithSameFeedItemId;
            const string contractNumber = "Contract-001";
            const int versiontNumber = 1;
            const int subVersiontNumber = 0;
            var messageId = new Guid().ToString();
            var contractIdentifier = new ContractIdentifier(contractNumber, versiontNumber, subVersiontNumber);

            var mockApprovalOnwardsContractAtomFeedService = new Mock<IApprovalOnwardsContractAtomFeedService>();
            mockApprovalOnwardsContractAtomFeedService.Setup((m => m.AddContractToFeed(
                It.IsAny<ConnectionInfo>(),
                It.IsAny<Contract>(),
                It.IsAny<Guid>(),
                It.IsAny<AtomItemType>())))
                    .Returns(assertAtomItemCreationResult);

            Contract corpContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = contractNumber,
                        contractVersionNumber = versiontNumber,
                        contractSubVersionNumber = subVersiontNumber,
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "BeforeValue"
                        }
                    }
                }
            };

            Mock<ICorporateContractService> corporateContractServiceMock = new Mock<ICorporateContractService>();
            corporateContractServiceMock.Setup(ccs => ccs.GetContract(It.IsAny<ConnectionInfo>(),
                It.IsAny<ICrmContractRepository>(),
                It.IsAny<IContractsManager>(), It.IsAny<ILegalDeliverableService>(),
                It.IsAny<ContractIdentifier>())).Returns(corpContract);

            var terminateContractFeedServicek = new TerminateContractFeedService(
                It.IsAny<ICrmContractRepository>(),
                Mock.Of<IContractsManager>(), Mock.Of<ILegalDeliverableService>(),
                mockApprovalOnwardsContractAtomFeedService.Object,
                corporateContractServiceMock.Object);

            // Act
            var updateSubStatusAndAddContractToFeedResult = terminateContractFeedServicek.UpdateContractAndAddToFeed(
                ConnectionInfo.CreateDefault(), contractIdentifier, c => c.SetChildContractsSubStatus(assertSubStatus), messageId, AtomItemType.ApprovedContract);

            // Assert
            Assert.AreEqual(assertSubStatus, updateSubStatusAndAddContractToFeedResult.CorporateContract.contracts[0].contractStatus.status,
                "Contract SubStatus was incorrectly set");
            Assert.AreEqual(assertAtomItemCreationResult, updateSubStatusAndAddContractToFeedResult.AtomItemCreationResult,
                "Incorrect AtomItemCreationResult was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminationContractFeedService_UpdateContractValuesAndAddContractToFeed_ShouldUseParameterSuppliedActionToUpdateCorporateContract()
        {
            // arrange
            Contract inputCorporateContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        StopNewStartsDate = DateTime.UtcNow
                    }
                }
            };
            Contract updatedCorporateContract = null;

            void UpdateCorporateContract(Contract contract) => contract.contracts.Single().StopNewStartsDate = null;

            var corporateContractServiceMock = new Mock<ICorporateContractService>();
            corporateContractServiceMock
                .Setup(m => m.GetContract(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ICrmContractRepository>(),
                    It.IsAny<IContractsManager>(),
                    It.IsAny<ILegalDeliverableService>(),
                    It.IsAny<ContractIdentifier>()))
                .Returns(inputCorporateContract);

            var approvalOnwardsContractAtomFeedServiceMock = new Mock<IApprovalOnwardsContractAtomFeedService>();
            approvalOnwardsContractAtomFeedServiceMock
                .Setup(m => m.AddContractToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<Contract>(),
                    It.IsAny<Guid>(),
                    It.IsAny<AtomItemType>()))
                .Callback<ConnectionInfo, Contract, Guid, AtomItemType>((ci, c, g, a) => { updatedCorporateContract = c; });

            var terminateContractFeedService = new TerminateContractFeedService(
                Mock.Of<ICrmContractRepository>(),
                Mock.Of<IContractsManager>(),
                Mock.Of<ILegalDeliverableService>(),
                approvalOnwardsContractAtomFeedServiceMock.Object,
                corporateContractServiceMock.Object);

            // act
            terminateContractFeedService.UpdateContractAndAddToFeed(
                ConnectionInfo.CreateDefault(),
                new ContractIdentifier("TEST-1234", 1, 0),
                UpdateCorporateContract,
                Guid.NewGuid().ToString(),
                AtomItemType.ContractModificationCancelled);

            // assert
            updatedCorporateContract.Should().NotBeNull("the test should have set the variable");
            updatedCorporateContract.contracts.Single().StopNewStartsDate.Should().BeNull("the paramaterised action should have been invoked");
        }
    }
}