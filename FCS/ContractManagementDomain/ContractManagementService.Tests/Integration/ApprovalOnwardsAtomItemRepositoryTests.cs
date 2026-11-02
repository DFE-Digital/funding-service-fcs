namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Common.PagedStorage;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Data.SqlClient;
    using CrossDomain.Integration.Entities.Data;
    using global::ContractManagementService.Tests;

    [TestClass]
    public class ApprovalOnwardsAtomItemRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovalOnwardsContractAtomItemRepository_ShouldReturnExpectedContractEventsOnly()
        {
            // arrange
            AtomItemType[] validAtomItemTypesForApprovalOnwardsFeed =
            {
                AtomItemType.ApprovedContract,
                AtomItemType.ClosedContract,
                AtomItemType.ContractTerminationInitiated,
                AtomItemType.CancelledContractTermination,
                AtomItemType.ContractTerminationDetailsUpdated,
                AtomItemType.ContractModified,
                AtomItemType.TerminationModificationDetailsUpdated,
                AtomItemType.ContractModificationCancelled
            };

            List<AtomFeedItem> testAtomItems =
                Enumerable.Range(0, Enum.GetNames(typeof(AtomItemType)).Length)
                    .Select(i => AtomFeedItem.CreateAtomFeedItem(string.Empty, $"INTEGRATION{i}", (AtomItemType) i, Guid.Empty, xml => true))
                    .ToList();

            using (var context = GetContractManagementDbContext())
            {
                context.ExecuteSql("TRUNCATE TABLE ContractManagement.AtomFeedItem");
                testAtomItems.ForEach(item => context.AtomFeedItems.Add(item));
                context.SaveChanges();
            }

            using (var context = GetContractManagementDbContext())
            {
                IApprovalOnwardsContractAtomItemRepository repository = new ApprovalOnwardsContractAtomItemRepository(context);
                // act
                StoragePage<AtomFeedItem> storagePage = repository.GetEntitiesForLatestPage();

                // assert
                validAtomItemTypesForApprovalOnwardsFeed.ToList().ForEach(validAtomItemType =>
                {
                    AtomFeedItem expectedItem = storagePage.Rows.SingleOrDefault(feedItem => feedItem.ItemType == validAtomItemType);
                    Assert.IsNotNull(expectedItem, $"Feed did not contain item for type {validAtomItemType}");
                });
            }
        }

        private static ContractManagementDbContext GetContractManagementDbContext()
        {
            var sqlConnection = new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]);
            return new ContractManagementDbContext(new ConnectionInfo(null, sqlConnection));
        }
    }
}