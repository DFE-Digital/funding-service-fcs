namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using ContractManagement.DataStore.Model;

    public class TerminatedContractSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;
        public TerminatedContractSyndicationItemCreator(string acceptType)
        {
            _acceptType = acceptType;
        }

        public override string GetTitle(AtomFeedItem row)
        {
            // {ContractNumber}: {MajorVersionNumber}.{MinorVersionNumber}
            return $"Contract {row.BusinessKey} was placed under termination";
        }

        public override string GetName(AtomFeedItem row)
        {
            return "Contract Termination Initiated";
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return "A contract has been placed under termination";
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}