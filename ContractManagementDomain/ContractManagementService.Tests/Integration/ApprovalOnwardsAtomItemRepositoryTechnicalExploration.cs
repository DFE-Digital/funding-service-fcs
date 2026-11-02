namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]

    public class ApprovalOnwardsAtomItemRepositoryTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AllContractAtomItemRepository_GetEntitiesForLatestPage_ShouldCallTheMethodWithinAtomItemQueryRepository()
        {
            // arrange
            AtomItemType[] validAtomItemTypesForApprovalOnwardsFeed =
            {
                AtomItemType.ApprovedContract,
                AtomItemType.ClosedContract,
                AtomItemType.ContractTerminationInitiated,
                AtomItemType.CancelledContractTermination,
                AtomItemType.ContractTerminationDetailsUpdated
            };

            var testAtomItems =
                Enumerable.Range(0, Enum.GetNames(typeof(AtomItemType)).Length)
                    .Select(i => AtomFeedItem.CreateAtomFeedItem(string.Empty, $"INTEGRATION{i}", (AtomItemType)i, Guid.Empty, xml => true))
                    .ToList();

            using (var context = new ContractManagementDbContext())
            {
                context.ExecuteSql("TRUNCATE TABLE ContractManagement.AtomFeedItem");
                testAtomItems.ForEach(item => context.AtomFeedItems.Add(item));
                context.SaveChanges();
            }

            using (var context = new ContractManagementDbContext())
            {
                IApprovalOnwardsContractAtomItemRepository repository = new ApprovalOnwardsContractAtomItemRepository(context);

                // act & assert
                var storagePage = repository.GetEntitiesForLatestPage();
            }
        }
    }
}