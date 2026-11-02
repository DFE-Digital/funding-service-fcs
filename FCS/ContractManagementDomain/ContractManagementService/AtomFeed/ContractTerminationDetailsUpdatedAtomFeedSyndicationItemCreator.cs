namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class ContractTerminationDetailsUpdatedAtomFeedSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;

        public ContractTerminationDetailsUpdatedAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }

        public override string GetTitle(AtomFeedItem row)
        {
            return $"Termination details for contract {row.BusinessKey} have been updated";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Termination Details Updated";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "Termination details for a contract have been updated";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}