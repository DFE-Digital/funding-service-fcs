namespace ContractManagement.DataStore.Repositories
{
    using System;
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using System.Linq;
    using Exceptions;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ApprovalOnwardsContractAtomItemRepository : AtomItemRepository, IApprovalOnwardsContractAtomItemRepository
    {
        public ApprovalOnwardsContractAtomItemRepository(IContractManagementDbContext contractManagementDbContext) : base(contractManagementDbContext)
        {
        }

        public Guid? GetIdentifierForBusinessKey(ConnectionInfo connectionInfo, string businessKey, AtomItemType atomItemType)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return context.AtomFeedItems.SingleOrDefault(afi => afi.BusinessKey == businessKey && afi.ItemType == atomItemType)?.Identifier;
            }
        }

        public void Add(ConnectionInfo connectionInfo, AtomFeedItem atomFeedItem)
        {
            if (connectionInfo.UseDefault())
            {
                Add(atomFeedItem);
            }
            else
            {
                using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
                {
                    try
                    {
                        context.AtomFeedItems.Add(atomFeedItem);
                        context.SaveChanges();
                    }
                    catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException && ((SqlException)ex.InnerException.InnerException).Number == 2601) // Handle duplicate key exception
                    {
                        var exceptionToThrow = new SqlDuplicateKeyStorageException(ex);
                        throw exceptionToThrow;
                    }
                }
            }
        }

        protected override AtomItemType[] AtomItemTypes { get; } =
        {
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
    }
}