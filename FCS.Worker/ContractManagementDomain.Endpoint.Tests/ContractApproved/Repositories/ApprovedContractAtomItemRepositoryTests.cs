namespace ContractManagementDomain.Endpoint.Tests.ContractApproved.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Validation;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using ContractManagementDomain.Endpoint.ContractApproved.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class ApprovedContractAtomItemRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ApprovedContractAtomItemRepository_ShouldThrowDuplicateKeyStorageExceptionWhenAddingTheSameObjectTwice()
        {
            const string businessKey = "TestKey:1:0";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.RemoveWhere(afi => afi.BusinessKey == businessKey && afi.ItemType == AtomItemType.ApprovedContract);
                context.SaveChanges();
            }

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // arrange
                IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                AtomFeedItem item1 = AtomFeedItem.CreateAtomFeedItem(new Contract(), businessKey, AtomItemType.ApprovedContract, xml => true);
                AtomFeedItem item2 = AtomFeedItem.CreateAtomFeedItem(new Contract(), businessKey, AtomItemType.ApprovedContract, xml => true);

                bool threwExpectedException = false;

                // act 1
                repository.Add(item1, connectionInfo).Wait();

                try
                {
                    // act 2
                    await repository.Add(item2, connectionInfo);
                }
                catch (SqlDuplicateKeyStorageException)
                {
                    threwExpectedException = true;
                }

                Assert.IsTrue(threwExpectedException);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAtomItemRepository_ShouldNotThrowDuplicateKeyStorageExceptionWhenAddingObjectWithSameBusinessKeyAndItemTypeForAllowedDuplicateItemType()
        {
            const string businessKey = "TestKey:1:0";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.RemoveWhere(afi => afi.BusinessKey == businessKey && afi.ItemType == AtomItemType.ApprovedContract);
                context.SaveChanges();
            }

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // arrange
                IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                AtomFeedItem item1 = AtomFeedItem.CreateAtomFeedItem(new Contract(), businessKey, AtomItemType.ContractTerminationInitiated, xml => true);
                AtomFeedItem item2 = AtomFeedItem.CreateAtomFeedItem(new Contract(), businessKey, AtomItemType.ContractTerminationInitiated, xml => true);

                // act
                repository.Add(item1, connectionInfo).Wait();
                repository.Add(item2, connectionInfo).Wait();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAtomItemRepository_ShouldCreateAtomFeedItemWithDateGeneratedByDb()
        {
            const string businessKey = "TestKey:1:0";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.RemoveWhere(afi => afi.BusinessKey == businessKey && afi.ItemType == AtomItemType.ApprovedContract);
                context.SaveChanges();
            }

            try
            {
                using (ContractManagementDbContext context = new ContractManagementDbContext())
                {
                    // arrange
                    IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository();
                    ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                    AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(new Contract(), businessKey, AtomItemType.ApprovedContract, xml => true);

                    // act
                    repository.Add(item, connectionInfo).Wait();

                    // assert
                    Assert.AreNotEqual(DateTime.MinValue, item.CreatedDate);
                }
            }
            catch (DbEntityValidationException ex)
            {
                IEnumerable<string> errorMessages = ex.EntityValidationErrors
                           .SelectMany(x => x.ValidationErrors)
                           .Select(x => x.ErrorMessage);

                string fullErrorMessage = string.Join("; ", errorMessages);

                Assert.Fail(string.Join(",", fullErrorMessage));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAtomItemRepository_GetIdentifierForBusinessKey_ShouldReturnFeedItemIdWhenValidBusinessKeyAndAtomItemTypeIsProvided()
        {
            // arrange 
            const string businessKey = "TestKey:1:0";
            Guid feedItemId = Guid.NewGuid();
            Guid? identifierResponse;

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.RemoveWhere(afi => afi.BusinessKey == businessKey && afi.ItemType == AtomItemType.ApprovedContract);
                context.SaveChanges();
            }

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(new Contract(), businessKey, AtomItemType.ApprovedContract, feedItemId, xml => true);

                repository.Add(item, connectionInfo).Wait();
            }

            // act 
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                identifierResponse = repository.GetIdentifierForBusinessKey(businessKey, AtomItemType.ApprovedContract, connectionInfo).Result;
            }

            // assert
            Assert.AreEqual(feedItemId, identifierResponse);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAtomItemRepository_GetIdentifierForBusinessKey_ShouldReturnNullWhenNonValidBusinessKeyAndAtomItemTypeIsProvided()
        {
            // arrange 
            const string businessKey = "TestKey:1:0";
            Guid? identifierResponse;

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.RemoveWhere(afi => afi.BusinessKey == businessKey && afi.ItemType == AtomItemType.ApprovedContract);
                context.SaveChanges();
            }

            // act 
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                identifierResponse = repository.GetIdentifierForBusinessKey(businessKey, AtomItemType.ApprovedContract, connectionInfo).Result;
            }

            // assert
            Assert.IsNull(identifierResponse);
        }
    }
}
