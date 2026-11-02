namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class ApprovedContractAtomFeedSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;
        public ApprovedContractAtomFeedSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }
        
        public override string GetTitle(AtomFeedItem row)
        {
            // {ContractNumber}: {MajorVersionNumber}.{MinorVersionNumber}
            return $"Contract {row.BusinessKey} was Approved";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Approved Contract";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "A contract has been approved";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}