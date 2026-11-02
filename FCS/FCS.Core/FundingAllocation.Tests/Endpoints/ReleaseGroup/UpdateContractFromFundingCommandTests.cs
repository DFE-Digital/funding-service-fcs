namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using FluentAssertions;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class UpdateContractFromFundingCommandTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractFromFundingCommand_ShouldHaveIsAmendmentPropertyTrueWhenIntentIsAmendment()
        {
            // arrange
            var updateContractFromFundingCommand = new UpdateContractFromFundingCommand(null,
                null, null, ContractIntent.Amendment, "", 1, true);

            // act & assert
            updateContractFromFundingCommand.IsAmendment.Should().Be(true);
        }
    }
}