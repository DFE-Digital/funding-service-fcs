namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class WithdrawnContractAtomFeedSyndicationItemCreator: AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;

        public WithdrawnContractAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }
        
        public override string GetTitle(AtomFeedItem row)
        {
            return $"Contract {row.BusinessKey} was Withdrawn";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Withdrawn";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "A contract has been Withdrawn";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}