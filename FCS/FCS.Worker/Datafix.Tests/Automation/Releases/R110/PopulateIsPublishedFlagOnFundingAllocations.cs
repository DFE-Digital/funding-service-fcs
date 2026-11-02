namespace Datafix.Tests.Automation.Releases.R110
{
    using System.Linq;
    using Datafix.Tests.Repositories;

    public class PopulateIsPublishedFlagOnFundingAllocations : IApplyDataFix
    {
        public string Release => "R110";

        public int StoryNumber => 34859;

        public string Name => "Populate IsPublished flag on Funding Allocations";

        public int Order => 1;

        public void ApplyDataFix()
        {
            // get all the distinct contract number and versions from FundingAllocation.Contract (maybe just the max(version))
            var contractsRelatedToFundingAllocations = FundingAllocationContractRepository.GetContracts();

            // for each these check in the [ContractManagement].[AtomFeedItem] for an ItemType of 1 (Published)
            var publishedContracts = contractsRelatedToFundingAllocations
                .Where(c => AtomFeedItemRepository.IsPublished(c.contractNumber, c.version)).ToList();

            // where we have a publish contract we need to run the same query as in ContractPublishedHandler to set the flag on the FAs
            publishedContracts.ForEach(publishedContract =>
            {
                var fundingIds =
                    FundingAllocationContractRepository.GetFundingAllocationIdsRelatedToContract(
                        publishedContract.contractNumber, publishedContract.version);

                if (fundingIds.Any())
                {
                    // update FAs to isPublished
                    FundingAllocationContractRepository.SetFundingAllocationsToPublished(fundingIds);
                }
            });
        }
    }
}
