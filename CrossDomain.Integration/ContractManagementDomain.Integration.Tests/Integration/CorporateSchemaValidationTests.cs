namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Integration
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using System.Xml.XPath;
    using Castle.Core.Internal;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class CorporateSchemaValidationTests
    {
        private const string CorpContractSchemaNamespace = "urn:sfa:schemas:contract";
        private const string CorpContractSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v11.08.xsd";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldPassValidationWhenLotReferenceAndLotSpecificationTitleIsNull()
        {
            // arrange
            string xmlContract = GetEsfCorpContractXmlString();

            // act
            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();
            ValidateCorpContractAgainstXsd(xmlContract, validationFailureItems);

            // assert
            Assert.AreEqual(0, validationFailureItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldPassValidationWhenFundingStreamNameIs100CharsLong()
        {
            // arrange
            XDocument corpSchemaContractXDocument = GetCorpSchemaContractXDocument();
            
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:fundingStreamName", namespaceManager)
                .ToList().ForEach(c => c.Value = CreateBigTextString(100));
            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();
            
            // act
            ValidateCorpContractAgainstXsd(corpSchemaContractXDocument.ToString(), validationFailureItems);

            // assert
            Assert.AreEqual(0, validationFailureItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldPassValidationWhenFundingStreamShortCodeIs6CharsLong()
        {
            // arrange
            XDocument corpSchemaContractXDocument = GetCorpSchemaContractXDocument();
           
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:fundingStreamShortCode", namespaceManager)
                .ToList().ForEach(c => c.Value = CreateBigTextString(6));
            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();

            // act
            ValidateCorpContractAgainstXsd(corpSchemaContractXDocument.ToString(), validationFailureItems);

            // assert
            Assert.AreEqual(0, validationFailureItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldPassValidationWhenFundingStreamShortCodeIsNotPresent()
        {
            // arrange
            XDocument corpSchemaContractXDocument = GetCorpSchemaContractXDocument();

            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:fundingStreamShortCode", namespaceManager)
                .Remove();

            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();

            // act
            ValidateCorpContractAgainstXsd(corpSchemaContractXDocument.ToString(), validationFailureItems);

            // assert
            Assert.AreEqual(0, validationFailureItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldPassValidationWhenFundingTypeNameIs100CharsLong()
        {
            // arrange
            XDocument corpSchemaContractXDocument = GetCorpSchemaContractXDocument();

            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:fundingTypeName", namespaceManager)
                .ToList().ForEach(c => c.Value = CreateBigTextString(100));
            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();

            // act
            ValidateCorpContractAgainstXsd(corpSchemaContractXDocument.ToString(), validationFailureItems);

            // assert
            Assert.AreEqual(0, validationFailureItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldPassValidationWhenDasSpecificPeriodTypeIsGiven()
        {
            // arrange
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");

            XDocument corpSchemaContractXDocument = GetCorpSchemaContractXDocument();
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:periodTypeCode", namespaceManager).ToList().ForEach(c => c.Value = "LEVY");
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:periodTypeName", namespaceManager).ToList().ForEach(c => c.Value = "APPRENTICESHIP LEVY");

            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();

            // act
            ValidateCorpContractAgainstXsd(corpSchemaContractXDocument.ToString(), validationFailureItems);

            // assert
            Assert.AreEqual(0, validationFailureItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldFailValidationWhenFundingTypeNameIs101CharsLong()
        {
            // arrange
            XDocument corpSchemaContractXDocument = GetCorpSchemaContractXDocument();

            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:fundingTypeName", namespaceManager)
                .ToList().ForEach(c => c.Value = CreateBigTextString(101));
            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();

            // act
            ValidateCorpContractAgainstXsd(corpSchemaContractXDocument.ToString(), validationFailureItems);

            // assert (there are two elements in the sample xml file for fundingTypeName)
            Assert.AreEqual(2, validationFailureItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CorporateSchemaValidation_ShouldFailValidationWhenFundingStreamShortCodeIs7CharsLong()
        {
            // arrange
            XDocument corpSchemaContractXDocument = GetCorpSchemaContractXDocument();
            
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            corpSchemaContractXDocument.Root.XPathSelectElements("//ns:fundingStreamShortCode", namespaceManager)
                .ToList().ForEach(c => c.Value = CreateBigTextString(7));
            IList<ValidationFailureItem> validationFailureItems = new List<ValidationFailureItem>();

            // act
            ValidateCorpContractAgainstXsd(corpSchemaContractXDocument.ToString(), validationFailureItems);

            // assert
            Assert.AreEqual(1, validationFailureItems.Count);
        }

        private string CreateBigTextString(int numChars)
        {
            StringBuilder bigTextBuilder = new StringBuilder(numChars);
            for (int i = 0; i < numChars; i++)
            {
                bigTextBuilder.Append("A");
            }

            return bigTextBuilder.ToString();
        }

        private string GetEsfCorpContractXmlString()
        {
            using (var resource = new TestResource("SFA.FCT.ContractManagementDomain.Integration.Tests", "Resources.ESFContract.xml"))
            {
                var document = XDocument.Load(resource.Stream);

                return document.Root.ToString();
            }
        }

        private XDocument GetCorpSchemaContractXDocument()
        {
            using (var resource = new TestResource("SFA.FCT.ContractManagementDomain.Integration.Tests", "Resources.ESFContract.xml"))
            {
                return XDocument.Load(resource.Stream);
            }
        }

        private void ValidateCorpContractAgainstXsd(string xmlContract, IList<ValidationFailureItem> validationFailureItems)
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

        private void AddSchemasToSet(XmlSchemaSet schemas)
        {
            Stream xsdStream = GetCorporateSchemaXsdFile();
            schemas.Add(CorpContractSchemaNamespace, new XmlTextReader(xsdStream));
        }

        private static Stream GetCorporateSchemaXsdFile()
        {
            return typeof(Contract).Assembly.GetManifestResourceStream(CorpContractSchemaResourceName);
        }
    }
}
