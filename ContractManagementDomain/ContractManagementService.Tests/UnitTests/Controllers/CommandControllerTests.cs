namespace SFA.FCT.ContractManagementService.Test.UnitTests.CommandControllers
{
    using System;
    using Common;
    using Common.Commands;
    using Controllers;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NSB;

    public abstract class BusControllerTestBase
    {
        private ISendOnlyBus _originalBus;

        protected Mock<ISendOnlyBus> Bus { get; private set; }

        protected Mock<ILogger> Logger { get; private set; }

        [TestInitialize]
        public void SetUpBus()
        {
            _originalBus = ServiceBus.Bus;
            Bus = new Mock<ISendOnlyBus>();
            Logger = new Mock<ILogger>();
            ServiceBus.Bus = Bus.Object;
        }

        [TestCleanup]
        public void RestoreBus()
        {
            ServiceBus.Bus = _originalBus;
        }
    }

    [TestClass]
    public class ContractClosureControllerUnitTests : BusControllerTestBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractClosure_Valid_SendsCommandAndAccepts()
        {
            var result = new ContractClosureController(Logger.Object).InitiateContractClosure(new ContractIdentifier("C1", 2, 3));

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagementDomain.ContractClosure",
                It.Is<InitiateContractClosureCommand>(c => c.ContractNumber == "C1" && c.VersionNumber == 2 && c.SubVersionNumber == 3)), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractClosure_Invalid_BadRequestAndNothingSent()
        {
            var result = new ContractClosureController(Logger.Object).InitiateContractClosure(new ContractIdentifier("", 0, 0));

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<InitiateContractClosureCommand>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosure_Valid_SendsCommandAndAccepts()
        {
            var result = new ContractClosureController(Logger.Object).ApproveContractClosure(new ContractIdentifier("C1", 2, 3));

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagementDomain.ContractClosure",
                It.Is<ApproveContractClosureCommand>(c => c.ContractNumber == "C1" && c.VersionNumber == 2 && c.SubVersionNumber == 3)), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosure_Invalid_BadRequestAndNothingSent()
        {
            var result = new ContractClosureController(Logger.Object).ApproveContractClosure(new ContractIdentifier(null, 1, 0));

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<ApproveContractClosureCommand>()), Times.Never);
        }
    }

    [TestClass]
    public class ContractAmendmentControllerUnitTests : BusControllerTestBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AmendContract_Valid_SendsCommandAndAccepts()
        {
            var info = new ContractAmendmentInformation { ContractNumber = "C1", VersionNumber = 2, SubVersionNumber = 1, AmendmentType = "VARIATION" };

            var result = new ContractAmendmentController(Logger.Object).AmendContract(info);

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractCreateDomain.NonFinancialAmendment",
                It.Is<AmendContractNonFinancialAmendmentCommand>(c =>
                    c.ContractNumber == "C1" && c.VersionNumber == 2 && c.SubVersionNumber == 1 &&
                    c.AmendmentType == AmendmentType.Variation && c.IsNonFinancialAmendment)), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendContract_Invalid_BadRequestAndNothingSent()
        {
            var info = new ContractAmendmentInformation { ContractNumber = "C1", VersionNumber = 2, AmendmentType = "OTHER" };

            var result = new ContractAmendmentController(Logger.Object).AmendContract(info);

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<AmendContractNonFinancialAmendmentCommand>()), Times.Never);
        }
    }

    [TestClass]
    public class ContractModificationControllerUnitTests : BusControllerTestBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApproveModification_Valid_SendsAndAccepts()
        {
            var command = new ApproveContractModificationCommand { ContractNumber = "C1", VersionNumber = 1 };

            var result = new ContracModificationController(Logger.Object).ApproveContractModification(command);

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagement.ContractTermination", command), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateModification_Valid_SendsAndAccepts()
        {
            var command = new UpdateContractModificationCommand { ContractNumber = "C1", VersionNumber = 1 };

            var result = new ContracModificationController(Logger.Object).UpdateContractModification(command);

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagement.ContractTermination", command), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CancelModification_Invalid_BadRequestAndNothingSent()
        {
            var result = new ContracModificationController(Logger.Object).CancelContractModification(new CancelContractModificationCommand());

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<CancelContractModificationCommand>()), Times.Never);
        }
    }

    [TestClass]
    public class ContractTerminationControllerUnitTests : BusControllerTestBase
    {
        private ContractTerminationController Controller => new ContractTerminationController(Logger.Object);

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateTerminationDetails_Valid_SendsAndAccepts()
        {
            var command = new UpdateContractTerminationDetailsCommand { ContractNumber = "C1", VersionNumber = 1 };

            Assert.IsInstanceOfType(Controller.UpdateContractTerminationDetails(command), typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagement.ContractTermination", command), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateTerminationDetails_Invalid_BadRequest()
        {
            Assert.IsInstanceOfType(Controller.UpdateContractTerminationDetails(new UpdateContractTerminationDetailsCommand()), typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<UpdateContractTerminationDetailsCommand>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveTerminationInitiation_Valid_SendsAndAccepts()
        {
            var command = new ApproveContractTerminationInitiationCommand { ContractNumber = "C1", VersionNumber = 1 };

            Assert.IsInstanceOfType(Controller.ApproveContractTerminationInitiation(command), typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagement.ContractTermination", command), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveTerminationInitiation_Invalid_BadRequest()
        {
            Assert.IsInstanceOfType(Controller.ApproveContractTerminationInitiation(new ApproveContractTerminationInitiationCommand()), typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<ApproveContractTerminationInitiationCommand>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CancelTermination_Valid_SendsAndAccepts()
        {
            Assert.IsInstanceOfType(Controller.CancelContractTermination(new ContractIdentifier("C1", 2, 3)), typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagement.ContractTermination",
                It.Is<CancelContractTerminationCommand>(c => c.ContractNumber == "C1" && c.VersionNumber == 2 && c.SubVersionNumber == 3)), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CancelTermination_Invalid_BadRequest()
        {
            Assert.IsInstanceOfType(Controller.CancelContractTermination(new ContractIdentifier("C1", 0, 0)), typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<CancelContractTerminationCommand>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContract_Valid_SendsAndAccepts()
        {
            Assert.IsInstanceOfType(Controller.TerminateContract(new ContractIdentifier("C1", 2, 3)), typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractManagement.ContractTermination",
                It.Is<TerminateContractCommand>(c => c.ContractNumber == "C1" && c.VersionNumber == 2 && c.SubVersionNumber == 3)), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContract_Invalid_BadRequest()
        {
            Assert.IsInstanceOfType(Controller.TerminateContract(new ContractIdentifier(null, 0, 0)), typeof(BadRequestResult));
            Bus.Verify(b => b.Send(It.IsAny<string>(), It.IsAny<TerminateContractCommand>()), Times.Never);
        }
    }

    [TestClass]
    public class FundingAllocationControllerUnitTests : BusControllerTestBase
    {
        private FundingAllocationController Controller => new FundingAllocationController(Logger.Object);

        [TestMethod, TestCategory("UnitTest")]
        public void ReleaseGroup_SendsToReleaseGroupEndpoint()
        {
            var command = new FundingAllocationReleaseGroupCommand();

            Assert.IsInstanceOfType(Controller.ReleaseGroup(command), typeof(AcceptedResult));
            Bus.Verify(b => b.Send("FundingAllocation.ReleaseGroup", command), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HoldUnholdWithdrawReinstate_SendToUpdateEndpoint()
        {
            var hold = new HoldFundingAllocationCommand();
            var unhold = new UnHoldFundingAllocationCommand();
            var withdraw = new WithdrawFundingAllocationCommand();
            var reinstate = new ReinstateFundingAllocationCommand("F1");

            Assert.IsInstanceOfType(Controller.HoldEvent(hold), typeof(AcceptedResult));
            Assert.IsInstanceOfType(Controller.UnHoldEvent(unhold), typeof(AcceptedResult));
            Assert.IsInstanceOfType(Controller.WithdrawalEvent(withdraw), typeof(AcceptedResult));
            Assert.IsInstanceOfType(Controller.ReinstateEvent(reinstate), typeof(AcceptedResult));

            Bus.Verify(b => b.Send("FundingAllocation.UpdateFundingAllocation", hold), Times.Once);
            Bus.Verify(b => b.Send("FundingAllocation.UpdateFundingAllocation", unhold), Times.Once);
            Bus.Verify(b => b.Send("FundingAllocation.UpdateFundingAllocation", withdraw), Times.Once);
            Bus.Verify(b => b.Send("FundingAllocation.UpdateFundingAllocation", reinstate), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UnQueueEvent_SendsReleaseQueuedCommand()
        {
            var command = new UnQueueFundingAllocationsForContractCommand { ContractNumber = "C1", VersionNumber = 2, SubVersionNumber = 3 };

            Assert.IsInstanceOfType(Controller.UnQueueEvent(command), typeof(AcceptedResult));
            Bus.Verify(b => b.Send("FundingAllocation.ReleaseGroup", It.IsAny<ReleaseQueuedFundingAllocationsForContractsCommand>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UnQueueEvent_BusThrows_StillAccepted()
        {
            Bus.Setup(b => b.Send(It.IsAny<string>(), It.IsAny<ReleaseQueuedFundingAllocationsForContractsCommand>())).Throws(new InvalidOperationException("boom"));

            var result = Controller.UnQueueEvent(new UnQueueFundingAllocationsForContractCommand { ContractNumber = "C1", VersionNumber = 1 });

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Logger.Verify(l => l.LogInformation(1, It.Is<string>(s => s.Contains("boom"))), Times.Once);
        }
    }

    [TestClass]
    public class SimpleCommandControllersUnitTests : BusControllerTestBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CfsRelease_SendsCommandAndAccepts()
        {
            var command = new InitiateCfsAllocationReleaseCommand();

            var result = new ContractManagementCfsReleaseController(Logger.Object).InitiateApprovalByExternalSystem(command);

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send("ContractRequestDomain.Cfs.Release", command), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FcrRecalc_SendsCommandAndAccepts()
        {
            var command = new InitiateReCalculationForFcrCommand();

            var result = new FundingClaimReconciliationCommandController(Logger.Object).ReCalculate(command);

            Assert.IsInstanceOfType(result, typeof(AcceptedResult));
            Bus.Verify(b => b.Send("PerformanceManagementDomain.RecalculationInitiated", command), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingConfirmationReports_SendCommandsToOperationsEndpoint()
        {
            var controller = new FundingConfirmationReportController(Logger.Object);

            Assert.IsInstanceOfType(controller.CreateFundingConfirmationReport(), typeof(AcceptedResult));
            Assert.IsInstanceOfType(controller.CreateLAFundingConfirmationReport(), typeof(AcceptedResult));

            Bus.Verify(b => b.Send("Operations.FundingConfirmationReport", It.IsAny<CreateFundingConfirmationReportCommand>()), Times.Exactly(2));
        }
    }
}
