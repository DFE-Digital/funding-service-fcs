namespace ContractManagementDomain.Endpoint.Tests.LevyAmendmentEndpoint.Services
{
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using Endpoint.LevyAmendmentEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;
    using Endpoint.LevyAmendmentEndpoint.DTOs;
    using SFA.FCT.ContractManagementService.Common;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    [TestClass]
    public class AmendLevyContractServiceTests
    {
        private const string ClosureNotificationText = "contract closure has been initiated";
        private const string TerminationNotificationText = "contract is awaiting approval of termination initiation";
        private const string AwaitingModificationApprovalNotificationText = "contract is awaiting approval of modification";

        // BULK
        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenApprovedApprovedAndOnRoatp()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation("contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);


            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenApprovedUnderTerminationAndOnRoatp()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation("contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.UnderTermination);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenApprovedModifiedAndOnRoatp()
        {
            // arrange
            var roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var contractInformation = new ContractInformation("contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Modified);

            using (var context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateNotToSendIncrementContractVersionCommand_WhenApprovedApprovedButNotOnRoatp()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
                Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Bulk component: Approved contract was not on Roatp. No action taken - "), 
                    "Expected message was not logged");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateNotToSendIncrementContractVersionCommand_WhenApprovedUnderTerminationButNotOnRoatp()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.UnderTermination);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
                Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Bulk component: Approved contract was not on Roatp. No action taken - "),
                    "Expected message was not logged");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateNotToSendIncrementContractVersionCommand_WhenApprovedModifiedButNotOnRoatp()
        {
            // arrange
            string loggedErrorMessage = null;

            var loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            var roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            var contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Modified);

            using (var context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
                Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Bulk component: Approved contract was not on Roatp. No action taken - "),
                    "Expected message was not logged");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendPreIncrementWithdrawalCommand_WhenDraftPublishedtoProviderAndOnRoatp()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });
            
            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Draft,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNotNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should be sent was incorrectly NOT returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(loggedErrorMessage, "Unexpected message was logged");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateNotToSendInitiateContractWithdrawalCommand_WhenDraftAndPublishedAndNotOnRoatp()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Draft,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should be sent was incorrectly NOT returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
                Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract: Draft PublishedtoProvider contract was not on Roatp. No action taken - "),
                 "Expected message was not logged");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateNotToSendAnyCommand_WhenContractStatusIsOther()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Other,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                    "IsProviderOnRoatp method was called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
                Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Bulk component: No action taken - "),
                    "Expected message was not logged");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendNotificationCommand_WithClosureNotificationText_WhenContractStatusApprovedAndSubStatusAwaitingClosureApproval()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.AwaitingClosureApproval);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                    "IsProviderOnRoatp method was called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNotNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should be sent was incorrectly NOT returned");
                Assert.AreEqual(ClosureNotificationText, componentLevyContractResult.NotificationInformationInfo.NotificationText, "Notification text was incorrect");
                Assert.AreEqual(NotificationInformationDto.NotificationReason.ContractClosureFound,
                    componentLevyContractResult.NotificationInformationInfo.ReasonForNotification,
                    "ReasonForNotification was incorrect");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendNotificationCommand_WithClosureNotificationText_WhenContractStatusApprovedAndSubStatusClosureInitiationinProgress()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.ClosureInitiationinProgress);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                    "IsProviderOnRoatp method was called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNotNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should be sent was incorrectly NOT returned");
                Assert.AreEqual(ClosureNotificationText, componentLevyContractResult.NotificationInformationInfo.NotificationText, "Notification text was incorrect");
                Assert.AreEqual(NotificationInformationDto.NotificationReason.ContractClosureFound,
                    componentLevyContractResult.NotificationInformationInfo.ReasonForNotification,
                    "ReasonForNotification was incorrect");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendNotificationCommand_WithTerminationNotificationText_WhenContractStatusApprovedAndSubStatusAwaitingTerminationInitiationApproval()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.AwaitingTerminationInitiationApproval);

            // act
            var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                new ConnectionInfo(null, null));

            // assert
            roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                "IsProviderOnRoatp method was called");
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNotNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should be sent was incorrectly NOT returned");
            Assert.AreEqual(TerminationNotificationText, componentLevyContractResult.NotificationInformationInfo.NotificationText, "Notification text was incorrect");
            Assert.AreEqual(NotificationInformationDto.NotificationReason.InitiateContractTerminationFound,
                componentLevyContractResult.NotificationInformationInfo.ReasonForNotification,
                "ReasonForNotification was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendNotificationCommand_CorrectNotificationText_WhenContractStatusApprovedAndSubStatusAwaitingModificationApproval()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.AwaitingModificationApproval);

            // act
            var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Variation, false, true,
                new ConnectionInfo(null, null));

            // assert
            roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                "IsProviderOnRoatp method was called");
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNotNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should be sent was incorrectly NOT returned");
            Assert.AreEqual(AwaitingModificationApprovalNotificationText, componentLevyContractResult.NotificationInformationInfo.NotificationText, "Notification text was incorrect");
            Assert.AreEqual(NotificationInformationDto.NotificationReason.AwaitingModificationApprovalFound,
                componentLevyContractResult.NotificationInformationInfo.ReasonForNotification,
                "ReasonForNotification was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateNotToSendAnyCommand_WhenAmendmentTypeIsNotificationAndStatusIsNotApproved()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Other,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Notification, false, true,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                    "IsProviderOnRoatp method was called");
                Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
                Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Bulk: AmendmentType Notification & Status not approved. No action taken - "),
                    "Expected message was not logged");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateToSendAnyCommand_WhenContractAlreadyHasNONLEVY2019AllocationAndShouldAddPayableNonLevyAllocationIsTrue()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });
           
            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);
            contractInformation.SimpleAllocationInfos = new List<SimpleAllocationInfo>
            {
                new SimpleAllocationInfo("NONLEVY2019")
            };

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                AmendBulkComponentLevyContractResult componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Notification,
                    true, true, new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendBulkComponentLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenContractAlreadyHasNONLEVY2019AllocationAndShouldAddPayableNonLevyAllocationIsFalse()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<IRoatpProviderRepository> roatpServiceMock = new Mock<IRoatpProviderRepository>();
            roatpServiceMock.Setup(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            var service = new AmendLevyContractService(roatpServiceMock.Object, Mock.Of<ICrmContractRepository>(), loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                AmendBulkComponentLevyContractResult componentLevyContractResult = service.AmendBulkComponentLevyContract(contractInformation, AmendmentType.Notification,
                    false, true, new ConnectionInfo(null, context.Database.Connection));

                // assert
                roatpServiceMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once,
                    "IsProviderOnRoatp method was not called");
                Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                    "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
                Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                    "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
                Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                    "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            }
        }
        
        // SINGLE
        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenApprovedApproved()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            // assert
            Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenApprovedUnderTermination()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.UnderTermination);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            // assert
            Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenApprovedModified()
        {
            // arrange
            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Modified);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            // assert
            Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateNotToIncrementContractVersionCommand_WhenContractStatusHasChangedOnCrm()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });
            
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns((ContractStatusInfo)null);

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Single: Contract is not latest. No action taken - "),
                "Expected message was not logged");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateSendPreIncrementWithdrawalCommand_WhenDraftAndPublishedtoProvider()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();

            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Draft,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                    .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            // assert
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNotNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should be sent was incorrectly NOT returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateSendNotificationCommand_WithClosureNotificationText_WhenContractStatusApprovedAndAwaitingClosureApproval()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();

            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.AwaitingClosureApproval);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            // assert
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNotNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should be sent was incorrectly NOT returned");
            Assert.AreEqual(ClosureNotificationText, componentLevyContractResult.NotificationInformationInfo.NotificationText, "Notification text was incorrect");
            Assert.AreEqual(NotificationInformationDto.NotificationReason.ContractClosureFound,
                componentLevyContractResult.NotificationInformationInfo.ReasonForNotification,
                "ReasonForNotification was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateSendNotificationCommand_WithClosureNotificationText_WhenContractStatusApprovedAndClosureInitiationinProgress()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();

            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.ClosureInitiationinProgress);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            // assert
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNotNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should be sent was incorrectly NOT returned");
            Assert.AreEqual(ClosureNotificationText, componentLevyContractResult.NotificationInformationInfo.NotificationText, "Notification text was incorrect");
            Assert.AreEqual(NotificationInformationDto.NotificationReason.ContractClosureFound,
                componentLevyContractResult.NotificationInformationInfo.ReasonForNotification,
                "ReasonForNotification was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateIssueNotification_WithTerminationNotificationText_WhenContractStatusIsApprovedAndAwaitingTerminationInitiationApproval()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.AwaitingTerminationInitiationApproval);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);

            // assert
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNotNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should be sent was incorrectly NOT returned");
            Assert.AreEqual(TerminationNotificationText, componentLevyContractResult.NotificationInformationInfo.NotificationText, "Notification text was incorrect");
            Assert.AreEqual(NotificationInformationDto.NotificationReason.InitiateContractTerminationFound,
                componentLevyContractResult.NotificationInformationInfo.ReasonForNotification,
                "ReasonForNotification was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateNotToInvokeAnyCommands_WhenContractStatusIsOther()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Other,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Variation, false, true);
 
            // assert
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Single: No action taken - "),
                "Expected message was not logged");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateNotToInvokeAnyCommands_WhenAmendmentTypeIsNotificationAndStatusIsNotApproved()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Other,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Notification, false, true);

            // assert
            Assert.IsNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
            Assert.IsTrue(loggedErrorMessage.Contains("AmendLevyContract - Single: AmendmentType Notification & Status not approved. No action taken - "),
                "Expected message was not logged");
        }
        

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateToSendAnyCommand_WhenContractAlreadyHasNONLEVY2019AllocationAndShouldAddPayableNonLevyAllocationIsTrue()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);

            contractInformation.SimpleAllocationInfos = new List<SimpleAllocationInfo>
            {
                new SimpleAllocationInfo("NONLEVY2019")
            };

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Notification, true, true);

            // assert
            Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_AmendSingleLevyContract_ShouldIndicateSendIncrementContractVersionCommand_WhenContractAlreadyHasNONLEVY2019AllocationAndShouldAddPayableNonLevyAllocationIsFalse()
        {
            // arrange
            string loggedErrorMessage = null;

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogInformation(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string message, object[] parameters) => { loggedErrorMessage = message; });

            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            var service = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, loggerMock.Object);

            ContractInformation contractInformation = new ContractInformation(contractNumber: "contractNumber",
                masterContractNumber: "23",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "ukprn",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            // act
            var componentLevyContractResult = service.AmendSingleLevyContract(contractInformation, AmendmentType.Notification, false, true);

            // assert
            Assert.IsNotNull(componentLevyContractResult.IncrementContractVersionInfo,
                "contractInformation indicating IncrementContractVersionCommand should be sent was incorrectly NOT returned");
            Assert.IsNull(componentLevyContractResult.PreIncrementContractVersionInfo,
                "contractInformation indicating PreIncrementWithdrawalCommand should NOT be sent was incorrectly returned");
            Assert.IsNull(componentLevyContractResult.NotificationInformationInfo,
                "NotificationInformationDto indicating IssueCrmNotificationCommand should NOT be sent was incorrectly returned");
        }

        // MISC 
        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractService_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());
            container.Register(Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped().IsDefault());
            container.BeginScope();

            // act, assert
            var service = container.Resolve<IAmendLevyContractService>();
            Assert.IsNotNull(service);
        }
    }
}