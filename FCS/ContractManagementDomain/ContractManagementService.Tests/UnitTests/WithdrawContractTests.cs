namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using System.Net;
    using Common;
    using Common.Commands;
    using Controllers;
    using CrossDomain.Integration.Entities.ContractWithdrawal;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NSB;

    [TestClass]
    public class WithdrawContractTests
    {
        #region Withdrawal

        [TestMethod, TestCategory("UnitTest")]
        public void WithdrawContract_SendsCommandAndReturnsAccepted()
        {
            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";
            int versionNumber = 1;
            var timesCalled = 0;

            var mockBus = new Mock<ISendOnlyBus>();

            mockBus.Setup(b => b.Send(It.IsAny<string>(), It.IsAny<InitiateContractWithdrawalCommand>()))
                .Callback((string destination, object command) =>
                {
                    var icwc = (InitiateContractWithdrawalCommand)command;

                    timesCalled++;
                    Assert.AreEqual(masterContractNumber, icwc.MasterContractNumber);
                    Assert.AreEqual(contractNumber, icwc.ContractNumber);
                    Assert.AreEqual(versionNumber, icwc.ContractVersionNumber);
                    Assert.AreEqual(WithdrawalRequestSource.Fcs, icwc.RequestSource);
                    Assert.AreEqual(ContractWithdrawalType.Agency, icwc.ContractWithdrawalType);
                });

            ServiceBus.Bus = mockBus.Object;

            var response = new ContractManagementController(Mock.Of<ILogger>()).WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = versionNumber});

            Assert.AreEqual(202, ((AcceptedResult)response).StatusCode);
            Assert.AreEqual(1, timesCalled, $"Sending of {nameof(InitiateContractWithdrawalCommand)} was not called once.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WithdrawContract_ReturnsBadRequestForInvalidContractDetails()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";

            var controller = new ContractManagementController(Mock.Of<ILogger>());

            var response1 = controller.WithdrawContract(new ContractInformation { ContractNumber = null, MasterContractNumber = masterContractNumber });
            var response2 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = null });
            var response3 = controller.WithdrawContract(new ContractInformation { ContractNumber = null, MasterContractNumber = null });
            var response4 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber });
            var response5 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = 0});
            var response6 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = -1 });

            Assert.AreEqual(400, ((BadRequestResult)response1).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response2).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response3).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response4).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response5).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response6).StatusCode);

            mockBus.Verify(x => x.Send(It.IsAny<string>(), It.IsAny<Action<InitiateContractWithdrawalCommand>>()),
                Times.Never);
        }
        #endregion

        #region WithdrawContractOnBehalfOfProvider
        [TestMethod, TestCategory("UnitTest")]
        public void WithdrawContractOnBehalfOfProvider_SendsCommandAndReturnsAccepted()
        {
            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";
            int versionNumber = 2;
            var timesCalled = 0;

            var mockBus = new Mock<ISendOnlyBus>();

            mockBus.Setup(b => b.Send(It.IsAny<string>(), It.IsAny<InitiateContractWithdrawalCommand>()))
                .Callback((string destination, object command) =>
                {
                    var icwc = (InitiateContractWithdrawalCommand)command;

                    timesCalled++;
                    Assert.AreEqual(masterContractNumber, icwc.MasterContractNumber);
                    Assert.AreEqual(contractNumber, icwc.ContractNumber);
                    Assert.AreEqual(versionNumber, icwc.ContractVersionNumber);
                    Assert.AreEqual(WithdrawalRequestSource.Fcs, icwc.RequestSource);
                    Assert.AreEqual(ContractWithdrawalType.OnBehalfOfProvider, icwc.ContractWithdrawalType);
                });

            ServiceBus.Bus = mockBus.Object;

            var response = new ContractManagementController(Mock.Of<ILogger>()).WithdrawContractOnBehalfOfProvider(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = versionNumber });

            Assert.AreEqual(202, ((AcceptedResult)response).StatusCode);
            Assert.AreEqual(1, timesCalled, $"Sending of {nameof(InitiateContractWithdrawalCommand)} was not called once.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WithdrawContractOnBehalfOfProvider_ReturnsBadRequestForInvalidContractDetails()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";

            var controller = new ContractManagementController(Mock.Of<ILogger>());

            var response1 = controller.WithdrawContract(new ContractInformation { ContractNumber = null, MasterContractNumber = masterContractNumber });
            var response2 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = null });
            var response3 = controller.WithdrawContract(new ContractInformation { ContractNumber = null, MasterContractNumber = null });
            var response4 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber });
            var response5 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = 0 });
            var response6 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = -1 });

            Assert.AreEqual(400, ((BadRequestResult)response1).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response2).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response3).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response4).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response5).StatusCode);
            Assert.AreEqual(400, ((BadRequestResult)response6).StatusCode);

            mockBus.Verify(x => x.Send(It.IsAny<string>(), It.IsAny<Action<InitiateContractWithdrawalCommand>>()),
                Times.Never);
        }

        #endregion

        #region Auto Withdrawal

        [TestMethod, TestCategory("UnitTest")]
        public void AutoWithdrawContract_SendsCommandAndReturnsAccepted()
        {
            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";
            int versionNumber = 2;
            var timesCalled = 0;

            var mockBus = new Mock<ISendOnlyBus>();

            mockBus.Setup(b => b.Send(It.IsAny<string>(), It.IsAny<InitiateContractWithdrawalCommand>()))
                .Callback((string destination, object command) =>
                {
                    var icwc = (InitiateContractWithdrawalCommand)command;

                    timesCalled++;
                    Assert.AreEqual(masterContractNumber, icwc.MasterContractNumber);
                    Assert.AreEqual(contractNumber, icwc.ContractNumber);
                    Assert.AreEqual(versionNumber, icwc.ContractVersionNumber);
                    Assert.AreEqual(WithdrawalRequestSource.External, icwc.RequestSource);
                    Assert.AreEqual(ContractWithdrawalType.AutoWithdrawal, icwc.ContractWithdrawalType);
                });

            ServiceBus.Bus = mockBus.Object;

            var response = new ContractManagementController(Mock.Of<ILogger>()).AutoWithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = versionNumber });

            Assert.AreEqual(202, ((AcceptedResult)response).StatusCode);
            Assert.AreEqual(1, timesCalled, $"Sending of {nameof(InitiateContractWithdrawalCommand)} was not called once.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AutoWithdrawContract_ReturnsBadRequestForInvalidContractDetails()
        {
            var mockBus = new Mock<ISendOnlyBus>();
            ServiceBus.Bus = mockBus.Object;

            const string contractNumber = "MAIN-123";
            const string masterContractNumber = "SFA-123";

            var controller = new ContractManagementController(Mock.Of<ILogger>());

            var response1 = controller.WithdrawContract(new ContractInformation { ContractNumber = null, MasterContractNumber = masterContractNumber });
            var response2 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = null });
            var response3 = controller.WithdrawContract(new ContractInformation { ContractNumber = null, MasterContractNumber = null });
            var response4 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber });
            var response5 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = 0 });
            var response6 = controller.WithdrawContract(new ContractInformation { ContractNumber = contractNumber, MasterContractNumber = masterContractNumber, ContractVersionNumber = -1 });

            Assert.AreEqual((int)HttpStatusCode.BadRequest, ((StatusCodeResult)response1).StatusCode);
            Assert.AreEqual((int)HttpStatusCode.BadRequest, ((StatusCodeResult)response2).StatusCode);
            Assert.AreEqual((int)HttpStatusCode.BadRequest, ((StatusCodeResult)response3).StatusCode);
            Assert.AreEqual((int)HttpStatusCode.BadRequest, ((StatusCodeResult)response4).StatusCode);
            Assert.AreEqual((int)HttpStatusCode.BadRequest, ((StatusCodeResult)response5).StatusCode);
            Assert.AreEqual((int)HttpStatusCode.BadRequest, ((StatusCodeResult)response6).StatusCode);

            mockBus.Verify(x => x.Send(It.IsAny<string>(), It.IsAny<Action<InitiateContractWithdrawalCommand>>()),
                Times.Never);
        }

        #endregion
    }
}
