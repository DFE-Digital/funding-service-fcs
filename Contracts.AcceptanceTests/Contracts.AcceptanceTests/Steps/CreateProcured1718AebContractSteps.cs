namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using Pages;
    using TechTalk.SpecFlow;
    using Utilities;

    [Binding]
    public class CreateProcured1718AebContractSteps
    {
        private readonly CreateLevyContractPageObject _createLevyContractPageObject;

        public CreateProcured1718AebContractSteps(CreateLevyContractPageObject createLevyContractPageObject)
        {
            _createLevyContractPageObject = createLevyContractPageObject;
        }

        [When(@"an AEB contract approval message is received from SFS for MasterContractNumber '(.*)' and ContractNumber '(.*)' and Version '(.*)'")]
        public void WhenAnAebContractApprovalMessageIsReceivedFromSfsForMasterContractNumberAndContractNumber(TransformedString masterContractNumber, TransformedString contractNumber, int version)
        {
            _createLevyContractPageObject.SimulateSFSAndSendContractApprovalMessageForGivenContract(masterContractNumber.Value, contractNumber.Value, version);
        }
    }
}