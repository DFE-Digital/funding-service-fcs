namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class CancelledContractTerminationAtomFeedSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;

        public CancelledContractTerminationAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }

        public override string GetTitle(AtomFeedItem row)
        {
            return $"Termination of contract {row.BusinessKey} was cancelled";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Termination Cancelled";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "Termination of a contract has been cancelled";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}