namespace SFA.FCT.ContractManagementService.Test.UnitTests.CommandControllers
{
    using System;
    using System.Threading.Tasks;
    using Common;
    using Common.Commands;
    using Controllers;
    using CrossDomain.Integration.Messages.Commands;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass, TestCategory("UnitTest")]
    public class ContractManagementControllerSendTests : BusControllerTestBase
    {
        private static ContractInformation Info() => new ContractInformation { ContractNumber = "C1", MasterContractNumber = "M1", ContractVersionNumber = 2 };

        [TestMethod]
        public void ConfirmPublicationToProvider_Valid_BuildsCommandAndAccepts()
        {
            ConfirmPublicationToProviderCommand built = null;
            Bus.Setup(b => b.Send(It.IsAny<string>(), It.IsAny<Action<ConfirmPublicationToProviderCommand>>()))
                .Callback<string, Action<ConfirmPublicationToProviderCommand>>((d, a) => { built = new ConfirmPublicationToProviderCommand(); a(built); });

            var result = new ContractManagementController(Logger.Object).ConfirmPublicationToProvider(Info());

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Assert.AreEqual("C1", built.ContractNumber);
            Assert.AreEqual("M1", built.MasterContractNumber);
        }

        [TestMethod]
        public void ReleaseForReview_Valid_BuildsCommandAndAccepts()
        {
            ReleaseForReviewCommand built = null;
            Bus.Setup(b => b.Send(It.IsAny<string>(), It.IsAny<Action<ReleaseForReviewCommand>>()))
                .Callback<string, Action<ReleaseForReviewCommand>>((d, a) => { built = new ReleaseForReviewCommand(); a(built); });

            var result = new ContractManagementController(Logger.Object).ReleaseForReview(Info());

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Assert.AreEqual("C1", built.ContractNumber);
            Assert.AreEqual("M1", built.MasterContractNumber);
        }

        [TestMethod]
        public async Task DeleteDraftContract_Valid_SendsCommandAndAccepts()
        {
            var result = await new ContractManagementController(Logger.Object).DeleteDraftContract(Info());

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.Is<DeleteDraftContractItemsCommand>(c => c.ContractNumber == "C1" && c.VersionNumber == 2)), Times.Once);
        }

        [TestMethod]
        public async Task DeleteDraftContract_MissingNumberOrVersion_ReturnsBadRequest()
        {
            var controller = new ContractManagementController(Logger.Object);

            Assert.IsInstanceOfType(await controller.DeleteDraftContract(null), typeof(BadRequestResult));
            Assert.IsInstanceOfType(await controller.DeleteDraftContract(new ContractInformation { ContractNumber = "C1" }), typeof(BadRequestResult));
            Assert.IsInstanceOfType(await controller.DeleteDraftContract(new ContractInformation { ContractVersionNumber = 1 }), typeof(BadRequestResult));
        }
    }
}
