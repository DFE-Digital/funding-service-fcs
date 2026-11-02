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
    public class ReadyForReviewTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Controller_ReadyForReview_SendsCommandAndReturnsOk()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            var contractInfo = new ContractInformation
            {
                ContractNumber = "MAIN-123",
                MasterContractNumber = "SFA-123"
            };

            var controller = new ContractManagementController(Mock.Of<ILogger>());

            var response = controller.ReleaseForReview(contractInfo);

            mockBus.Verify(x => x.Send<ReleaseForReviewCommand>("ContractManagementDomain.ReleaseForReview", It.IsAny<Action<ReleaseForReviewCommand>>()),
                Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Controller_ReadyForReview_ReturnsBadRequestForInvalidParameters()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            var contractInfoNoMaster = new ContractInformation
            {
                ContractNumber = "MAIN-123",
                MasterContractNumber = string.Empty
            };

            var contractInfoNoConNo = new ContractInformation
            {
                ContractNumber = string.Empty,
                MasterContractNumber = "SFA-123"
            };

            var nullContractInfo = new ContractInformation
            {
                ContractNumber = string.Empty,
                MasterContractNumber = string.Empty
            };

            var controller = new ContractManagementController(Mock.Of<ILogger>());

            var response1 = controller.ReleaseForReview(contractInfoNoConNo) as BadRequestResult;
            var response2 = controller.ReleaseForReview(contractInfoNoMaster) as BadRequestResult;
            var response3 = controller.ReleaseForReview(nullContractInfo) as BadRequestResult;

            mockBus.Verify(x => x.Send<ReleaseForReviewCommand>("ContractManagementDomain.ReleaseForReview", It.IsAny<Action<ReleaseForReviewCommand>>()),
                Times.Never);
        }
    }
}
