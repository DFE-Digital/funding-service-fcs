namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class ContractModifiedAtomFeedSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;

        public ContractModifiedAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }

        public override string GetTitle(AtomFeedItem row)
        {
            return $"Contract {row.BusinessKey} was modified";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Modified";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "Contract has been modified";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}