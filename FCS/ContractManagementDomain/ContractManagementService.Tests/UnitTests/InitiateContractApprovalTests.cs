namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using Common;
    using Common.Commands;
    using Controllers;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NSB;
    using System;

    [TestClass]
    public class InitiateContractApprovalTests
    {
        public ILogger Logger { get; set; }

        [TestMethod, TestCategory("UnitTest")]
        public void Controller_InitiateApprovalInternally_SendsCommandAndLogs()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            var mockLogger = new Mock<ILogger>();

            var contractInformation = new ContractInformation()
            {
                ContractNumber = "MAIN-123",
                MasterContractNumber = "SFA-123",
                ContractVersionNumber = 2
            };

            var controller = new ContractManagementController(mockLogger.Object);

            var response = controller.InitiateApprovalInternally(contractInformation);

            mockBus.Verify(x => x.Send(
                "ContractManagementDomain.InitiateContractApproval"
                , It.Is<InitiateContractApprovalCommand>(c =>
                                    c.MasterContractNumber == contractInformation.MasterContractNumber &&
                                    c.ContractNumber == contractInformation.ContractNumber &&
                                    c.ContractVersionNumber == contractInformation.ContractVersionNumber &&
                                    c.RequestSource == ApprovalRequestSource.Fcs)),
                Times.Once);

            mockLogger.Verify(x => x.LogInformation(ContractManagementLoggingEvents.InitiateContractApprovalCommandSent,
             $"{nameof(InitiateContractApprovalCommand)} sent for {contractInformation.ContractNumber} requested by client - {ApprovalRequestSource.Fcs.ToString()}"),
             Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Controller_InitiateApprovalByExternalSystem_SendsCommandAndLogs()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            var mockLogger = new Mock<ILogger>();
          
            ServiceBus.Bus = mockBus.Object;
          

            var contractInformation = new ContractInformation
            {
                ContractNumber = "MAIN-123",
                MasterContractNumber = "SFA-123",
                ContractVersionNumber = 2
            };

            var controller = new ContractManagementController(mockLogger.Object);
            var response = controller.InitiateApprovalByExternalSystem(contractInformation);

            mockBus.Verify(x => x.Send(
                "ContractManagementDomain.InitiateContractApproval"
                , It.Is<InitiateContractApprovalCommand>(c =>
                                    c.MasterContractNumber == contractInformation.MasterContractNumber &&
                                    c.ContractNumber == contractInformation.ContractNumber &&
                                    c.ContractVersionNumber == contractInformation.ContractVersionNumber &&
                                    c.RequestSource == ApprovalRequestSource.External)),
                Times.Once);

            mockLogger.Verify(x => x.LogInformation(ContractManagementLoggingEvents.InitiateContractApprovalCommandSent,
                    $"{nameof(InitiateContractApprovalCommand)} sent for {contractInformation.ContractNumber} requested by client - {ApprovalRequestSource.External.ToString()}"),
                Times.Once);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void Controller_InitiateContractApproval_ReturnsBadRequestForInvalidParameters()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;
            
            var controller = new ContractManagementController(Mock.Of<ILogger>());


            var response = controller.InitiateApprovalInternally(null) ;

            var response1 = controller.InitiateApprovalInternally(new ContractInformation()
            {
                ContractNumber = string.Empty,
                MasterContractNumber = string.Empty
            });

            var response2 = controller.InitiateApprovalInternally(new ContractInformation()
            {
                ContractNumber = string.Empty,
                MasterContractNumber = "SFA-123"
            } );
            var response3 = controller.InitiateApprovalInternally(new ContractInformation()
            {
                ContractNumber = "Main-123",
                MasterContractNumber = string.Empty
            });

            var responseForVersionNotSet = controller.InitiateApprovalInternally(new ContractInformation()
            {
                ContractNumber = "Main-123",
                MasterContractNumber = "SFA-12"
            });

            mockBus.Verify(x => x.Send("ContractManagementDomain.InitiateContractApproval", It.IsAny<Action<InitiateContractApprovalCommand>>()),
                Times.Never);
        }
    }
}
