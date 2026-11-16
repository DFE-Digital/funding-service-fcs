namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Datafixes
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using ContractCreateDomain.Implementation.Persistence;
    using ContractCreateDomain.Integration.ContractRequest.IoC;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagementService.Common;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class AtomItemRepositoryDatafixes
    {
        private const string TestBusinessKey = "TestKey:1:0";
        private IWindsorContainer _container;

        [TestMethod, TestCategory("DataFix_LiveFix")]
        public void ContractManagementDbContext_ShouldUpdateItemsInFeed()
        {
            /***
             * This is for a Live fix to some feed items (ACH 30/Apr/2016)
             */
            IDictionary<string, ContractInfo> esfBusinessKeys = new Dictionary<string, ContractInfo>();
            esfBusinessKeys.Add("ESIF-2001:1.0", new ContractInfo("SFA-6281", "ESIF-2001"));
            esfBusinessKeys.Add("ESIF-2003:1.0", new ContractInfo("SFA-6283", "ESIF-2003"));
            
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IList<AtomFeedItem> esfItems = context.AtomFeedItems.Where(a => esfBusinessKeys.Keys.Contains(a.BusinessKey)).ToList();

                esfItems.ForEach(esfItem => UpdateContract(context, esfItem.Id, esfBusinessKeys[esfItem.BusinessKey]));
            }

            // now validate that the updated rows are correct

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IList<AtomFeedItem> esfItems = context.AtomFeedItems.Where(a => esfBusinessKeys.Keys.Contains(a.BusinessKey)).ToList();

                esfItems.ForEach(CheckEsfAtomItemIsCorrect);
            }
        }

        private static void CheckEsfAtomItemIsCorrect(AtomFeedItem atomFeedItem)
        {
            Contract rehydratedCorporateSchemaContract =
            atomFeedItem.AtomFeedItemXml.DeserializeXml<Contract>();

            Assert.IsNotNull(rehydratedCorporateSchemaContract);
            Assert.IsTrue(!string.IsNullOrEmpty(rehydratedCorporateSchemaContract.contracts.First().contractAllocations.First().ProcurementAttrs.TenderSpecReference));
        }

        private void UpdateContract(ContractManagementDbContext context, int atomFeedItemId, ContractInfo contractInfo)
        {
            IContractsManager contractsManager = _container.Resolve<IContractsManager>();
            CrossDomain.Integration.Entities.CorporateContract.Contract corporateContract = contractsManager.GetCorporateContract(contractInfo.ContractNumber, contractInfo.MasterContractNumber,
                lastApproved: false);

            corporateContract.contracts.First().contractStatus.status = contractStatusTypeStatus
                .PublishedToProvider.ToString();
            // now transform to corp schema
            ContractTransformer contractTransformer = new ContractTransformer();
            Contract corporateSchemaContrat = contractTransformer.TransformToCorporateSchemaContract(corporateContract);

            string xmlCorporateSchemaContract = corporateSchemaContrat.SerializeToXml();

            // as the AtomFeedItem is immutable we need to update the row using sql
            context.Database.ExecuteSqlCommand(
                $"Update [ContractManagement].[AtomFeedItem] set AtomFeedItemXml = '{xmlCorporateSchemaContract}' where id = {atomFeedItemId}");
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();
            _container = new WindsorContainer();
            _container.Install(new WindsorInstaller(factory));
        }

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

        private class ContractInfo
        {
            public ContractInfo(string masterContractNumber, string contractNumber)
            {
                MasterContractNumber = masterContractNumber;
                ContractNumber = contractNumber;
            }

            public string MasterContractNumber { get; }

            public string ContractNumber { get; }
        }
    }
}
