namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using System.Collections.Generic;
    using System.ServiceModel.Syndication;
    using ContractManagement.DataStore.Model;
    using global::ContractManagementService.AtomFeed;

    public class AllContractAtomFeedSyndicationItemCreator : ISyndicationItemCreator<AtomFeedItem>
    {
        private readonly string _acceptType;

        public AllContractAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }

        private Dictionary<AtomItemType, ISyndicationItemCreator<AtomFeedItem>> SyndicationItemCreators => new Dictionary<AtomItemType, ISyndicationItemCreator<AtomFeedItem>>
        {
            {AtomItemType.DraftContract, new DraftContractAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.ApprovedContract, new ApprovedContractAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.WithdrawnContract, new WithdrawnContractAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.ClosedContract, new ClosedContractAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.ContractTerminationInitiated, new TerminatedContractSyndicationItemCreator(_acceptType)},
            {AtomItemType.CancelledContractTermination, new CancelledContractTerminationAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.ContractTerminated, new ContractTerminatedAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.ContractTerminationDetailsUpdated, new ContractTerminationDetailsUpdatedAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.ContractModified, new ContractModifiedAtomFeedSyndicationItemCreator(_acceptType)},
            {AtomItemType.TerminationModificationDetailsUpdated, new GeneralAtomFeedSyndicationItemCreator(
                _acceptType,
                getTitle: r => $"Modification details for contract {r.BusinessKey} have been updated",
                getName:r => "Contract Modification Details Updated",
                getLabel:r => "Modification details for a contract have been updated")
            },
            {AtomItemType.ContractModificationCancelled, new GeneralAtomFeedSyndicationItemCreator(
                _acceptType,
                getTitle: r => $"Modification of contract {r.BusinessKey} was cancelled",
                getName:r => "Contract Modification Cancelled",
                getLabel:r => "Modification of a contract has been cancelled")
            }
        };

        public SyndicationItem CreateItemForRow(AtomFeedItem row, string mediaType)
        {
            return SyndicationItemCreators[row.ItemType].CreateItemForRow(row, mediaType);
        }
    }
}