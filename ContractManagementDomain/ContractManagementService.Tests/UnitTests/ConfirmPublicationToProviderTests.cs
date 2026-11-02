namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using Common;
    using Common.Commands;
    using Controllers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NSB;
    using System;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Mvc;

    [TestClass]
    public class ConfirmPublicationToProviderTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Controller_ConfirmPublicationToProvider_SendsCommandAndReturnsAccepted()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";
            
            var controller = new ContractManagementController(Mock.Of<ILogger>());

            var response = controller.ConfirmPublicationToProvider(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber }) as OkResult;

            mockBus.Verify(x => x.Send("ContractManagementDomain.ConfirmPublicationToProvider", It.IsAny<Action<ConfirmPublicationToProviderCommand>>()),
                Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Controller_ConfirmPublicationToProvider_ReturnsBadRequestForInvalidParameters()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";

            var controller = new ContractManagementController(Mock.Of<ILogger>());

            var response1 = controller.ConfirmPublicationToProvider(new ContractInformation { ContractNumber = null, MasterContractNumber = masterContractNumber }) as BadRequestResult;
            var response2 = controller.ConfirmPublicationToProvider(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = null }) as BadRequestResult;
            var response3 = controller.ConfirmPublicationToProvider(new ContractInformation { ContractNumber = null, MasterContractNumber = null }) as BadRequestResult;

            mockBus.Verify(x => x.Send("ContractManagementDomain.ReleaseForReview", It.IsAny<Action<ConfirmPublicationToProviderCommand>>()),
                Times.Never);
        }
    }
}
