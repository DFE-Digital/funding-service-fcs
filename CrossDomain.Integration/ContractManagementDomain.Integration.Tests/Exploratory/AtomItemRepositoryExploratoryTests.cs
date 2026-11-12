namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Exploratory
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Castle.Windsor;
    using ContractCreateDomain.Integration.ContractRequest.IoC;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class AtomItemRepositoryExploratoryTests
    {
        private const string TestBusinessKey = "TestKey:1:0";
        private const string CorpContractSchemaNamespace = "urn:sfa:schemas:contract";
        private const string CorpContractSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v11.08.xsd";
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

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractManagementDbContext_ShouldOnlyHaveValidContractsInAtomFeedItems()
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();
                context.AtomFeedItems.Select(a=> a.GetAtomFeedItemXml()).ForEach(xml => ValidateCorpContractAgainstXsd(xml, validationFailureItems));
                Assert.AreEqual(0, validationFailureItems.Count);
            }
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();
            _container = new WindsorContainer();
            _container.Install(new WindsorInstaller(factory));
        }

        private static void ValidateCorpContractAgainstXsd(string xmlContract, IList<ValidationFailureItem> validationFailureItems)
        {
            XmlSchemaSet schemas = new XmlSchemaSet();
            AddSchemasToSet(schemas);
            XDocument responseXml = XDocument.Parse(xmlContract);

            responseXml.Validate(
                schemas,
                (o, e) =>
                {
                    validationFailureItems.Add(new ValidationFailureItem(xmlContract, e.Message));
                });
        }

        private static void AddSchemasToSet(XmlSchemaSet schemas)
        {
            Stream xsdStream = GetCorporateSchemaXsdFile();
            schemas.Add(CorpContractSchemaNamespace, new XmlTextReader(xsdStream));
        }

        public static Stream GetCorporateSchemaXsdFile()
        {
            return typeof(Contract).Assembly.GetManifestResourceStream(CorpContractSchemaResourceName);
        }
    }
}
