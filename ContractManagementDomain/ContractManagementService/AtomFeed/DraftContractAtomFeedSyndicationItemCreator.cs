namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class DraftContractAtomFeedSyndicationItemCreator: AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;

        public DraftContractAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }
        
        public override string GetTitle(AtomFeedItem row)
        {
            // {ContractNumber}: {MajorVersionNumber}.{MinorVersionNumber}
            return $"Contract {row.BusinessKey} was Published to Provider";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Published to Provider";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "A contract has been Published to Provider";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}