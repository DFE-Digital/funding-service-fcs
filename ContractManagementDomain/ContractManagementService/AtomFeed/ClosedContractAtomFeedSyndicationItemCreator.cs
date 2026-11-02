namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class ClosedContractAtomFeedSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;

        public ClosedContractAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }

        public override string GetTitle(AtomFeedItem row)
        {
            return $"Contract {row.BusinessKey} was Closed";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Closed";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "A contract has been closed";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}