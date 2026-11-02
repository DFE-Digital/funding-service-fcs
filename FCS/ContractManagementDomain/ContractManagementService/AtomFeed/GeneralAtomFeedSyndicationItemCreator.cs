
namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using System;
    using ContractManagement.DataStore.Model;

    public class GeneralAtomFeedSyndicationItemCreator : AtomFeedSyndicationItemCreator
    {
        private readonly string _acceptType;
        private readonly Func<AtomFeedItem, string> _getTitle;
        private readonly Func<AtomFeedItem, string> _getName;
        private readonly Func<AtomFeedItem, string> _getLabel;

        public GeneralAtomFeedSyndicationItemCreator(string acceptType, Func<AtomFeedItem, string> getTitle, Func<AtomFeedItem, string> getName, Func<AtomFeedItem, string> getLabel)
        {
            _acceptType = acceptType;
            _getTitle = getTitle;
            _getName = getName;
            _getLabel = getLabel;
        }

        public override string GetTitle(AtomFeedItem row)
        {
            return _getTitle(row);
        }

        public override string GetName(AtomFeedItem row)
        {
            return _getName(row);
        }

        public override string GetLabel(AtomFeedItem row)
        {
            return _getLabel(row);
        }

        public override string GetAcceptType()
        {
            return _acceptType;
        }
    }
}