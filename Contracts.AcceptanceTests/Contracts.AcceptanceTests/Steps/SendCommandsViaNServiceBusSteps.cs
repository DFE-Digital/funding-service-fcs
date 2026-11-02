namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using ContractManagementService.Common.Commands;
    using Infrastructure.Services;
    using TechTalk.SpecFlow;

    [Binding]
    public class SendCommandsViaNServiceBusSteps
    {
        [When(@"if a debugger is attached a ReleaseForReviewCommand with MasterContractNumber '(.*)' and ContractNumber '(.*)' is sent")]
        public void WhenIfADebuggerIsAttachedAReleaseForReviewCommandWithMasterContractNumberAndContractNumberIsSent(string masterContractNumber, string contractNumber)
        {
            MessageSendingBus.Send("ContractManagementDomain.ReleaseForReview", new ReleaseForReviewCommand {ContractNumber = contractNumber, MasterContractNumber = masterContractNumber});
        }
    }
}
