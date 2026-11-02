namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Data.Entity.Validation;
    using System.IO;
    using System.Linq;
    using Castle.Windsor;
    using ContractCreateDomain.Integration.ContractRequest.IoC;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class AtomItemRepositoryTests
    {
        private const string TestBusinessKey = "TestKey:1:0";
        private const string CorpContractSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v11.09.xsd";
        private IWindsorContainer _container;

        [TestCleanup, TestInitialize]
        public void TestCleanUp()
        {
            SetupIoC();
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                AtomFeedItem item = (from i in context.AtomFeedItems
                            where i.ItemType == AtomItemType.ApprovedContract
                                  && i.BusinessKey == TestBusinessKey
                            select i).FirstOrDefault();

                if (item != null)
                {
                    context.AtomFeedItems.Remove(item);
                    context.SaveChanges();
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest"), ExpectedException(typeof(SqlDuplicateKeyStorageException))]
        public void ApprovedContractAtomItemRepository_ShouldThrowDuplicateKeyStorageExceptionWhenAddingTheSameObjectTwice()
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);
                AtomFeedItem item1 = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                    AtomItemType.ApprovedContract, xml => true);
                AtomFeedItem item2 = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                    AtomItemType.ApprovedContract, xml => true);

                repository.Add(item1);
                repository.Add(item2);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAtomItemRepository_ShouldNotThrowDuplicateKeyStorageExceptionWhenAddingObjectWithSameBusinessKeyAndItemTypeForAllowedDuplicateItemType()
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);
                AtomFeedItem item1 = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                    AtomItemType.ContractTerminationInitiated, xml => true);
                AtomFeedItem item2 = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                    AtomItemType.ContractTerminationInitiated, xml => true);

                repository.Add(item1);
                repository.Add(item2);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAtomItemRepository_ShouldCreateAtomFeedItemWithDateGeneratedByDb()
        {
            try
            {
                using (ContractManagementDbContext context = new ContractManagementDbContext())
                {
                    IAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);
                    AtomFeedItem item =
                        AtomFeedItem.CreateAtomFeedItem(
                            new contract(), TestBusinessKey,
                            AtomItemType.ApprovedContract, xml => true);

                    repository.Add(item);

                    Assert.AreNotEqual(DateTime.MinValue, item.CreatedDate);
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                           .SelectMany(x => x.ValidationErrors)
                           .Select(x => x.ErrorMessage);

                var fullErrorMessage = String.Join("; ", errorMessages);

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
                IAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);
                
                AtomFeedItem item =
                    AtomFeedItem.CreateAtomFeedItem(
                        new contract(), businessKey,
                        AtomItemType.ApprovedContract, feedItemId, xml => true);

                repository.Add(item);
            }

            // act 
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);
                identifierResponse = repository.GetIdentifierForBusinessKey(businessKey, AtomItemType.ApprovedContract);
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
                IApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);
                identifierResponse = repository.GetIdentifierForBusinessKey(businessKey, AtomItemType.ApprovedContract);
            }

            // assert
            Assert.IsNull(identifierResponse);
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();
            _container = new WindsorContainer();
            _container.Install(new WindsorInstaller(factory));
        }

        public static Stream GetCorporateSchemaXsdFile()
        {
            return typeof(CrossDomain.Integration.Entities.CorporateSchema.Contract.contract).Assembly.GetManifestResourceStream(CorpContractSchemaResourceName);
        }
    }
}
