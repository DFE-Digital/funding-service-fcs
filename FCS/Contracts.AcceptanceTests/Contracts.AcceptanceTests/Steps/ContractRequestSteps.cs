namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using Extensions;
    using Infrastructure.Repositories;
    using MoreLinq;
    using TechTalk.SpecFlow;

    [Binding]
    public class ContractRequestSteps
    {
        [Given(@"there is no data in the ContractRequest\.FundingAllocationRelease table")]
        public void GivenThereIsNoDataInTheContractRequest_FundingAllocationReleaseTable()
        {
            ContractRequestFundingAllocationReleaseRepository.ClearDown();
        }

        [Given(@"the following data exists in the ContractRequest\.FundingAllocationRelease table")]
        public void GivenTheFollowingDataExistsInTheContractRequest_FundingAllocationReleaseTable(Table table)
        {
            var releaseGroupGroupId = FundingAllocationReleaseGroupRepository.GetNextReleaseGroupGroupId();

            ContractRequestFundingAllocationReleaseRepository.ClearDown();
            table.Rows.ForEach(row =>
                ContractRequestFundingAllocationReleaseRepository.AddFundingAllocationRelease(
                    releaseGroupGroupId,
                    row.ParseNullableString("FundingTypeCode"),
                    row.ParseNullableString("FundingPeriodName"),
                    row.ParseNullableString("ReleaseStatus")));
        }
    }
}