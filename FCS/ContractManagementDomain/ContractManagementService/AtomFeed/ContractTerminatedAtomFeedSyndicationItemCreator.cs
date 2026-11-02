namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class ContractTerminatedAtomFeedSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;

        public ContractTerminatedAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }

        public override string GetTitle(AtomFeedItem row)
        {
            return $"Contract {row.BusinessKey} has been terminated";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Terminated";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "Contract has been terminated";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}