namespace ContractManagement.DataStore.Repositories
{ 
    using Model;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using System;
    using System.Data.SqlClient;

    public class AllContractAtomItemRepository : AtomItemQueryRepository, IAllContractAtomItemRepository
    {
        private static StoragePage<AtomFeedItem> _cachedLatestPage;
        private static Guid? _previousLatestIdentifier = new Guid();

        public AllContractAtomItemRepository(SqlConnection connection) : base(connection)
        {
        }

        protected override AtomItemType[] AtomItemTypes { get; } =
        {
            Model.AtomItemType.DraftContract,
            Model.AtomItemType.WithdrawnContract,
            Model.AtomItemType.ApprovedContract,
            Model.AtomItemType.ClosedContract,
            Model.AtomItemType.ContractTerminationInitiated,
            Model.AtomItemType.CancelledContractTermination,
            Model.AtomItemType.ContractTerminated,
            Model.AtomItemType.ContractTerminationDetailsUpdated,
            Model.AtomItemType.ContractModified,
            Model.AtomItemType.TerminationModificationDetailsUpdated,
            Model.AtomItemType.ContractModificationCancelled
        };

        public override StoragePage<AtomFeedItem> GetEntitiesForLatestPage()
        {
            if (HasFeedTableChangedSinceLastCalled())
            {
                _cachedLatestPage = GetLatestPage();
            }

            return _cachedLatestPage;
        }

        private bool HasFeedTableChangedSinceLastCalled()
        {
            var latestIdentifier = GetLatestIdentifier();

            if (latestIdentifier != _previousLatestIdentifier)
            {
                _previousLatestIdentifier = latestIdentifier;
                return true;
            }

            return false;
        }
    }
}
