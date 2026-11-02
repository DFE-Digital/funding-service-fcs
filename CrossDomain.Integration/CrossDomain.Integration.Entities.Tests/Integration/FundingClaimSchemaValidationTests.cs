namespace CrossDomain.Integration.Entities.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0;

    [TestClass]
    public class FundingClaimSchemaValidationTests
    {
        private const string ValidXmlResourceName = @"CrossDomain.Integration.Entities.Tests.TestData.FundingClaim_V3_0_TestData.xml";
        private string _validFundingClaimXml;

        [TestInitialize]
        public void TestInitialize()
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(ValidXmlResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                _validFundingClaimXml = reader.ReadToEnd();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaim_ValidXmlShouldValidateAgainstCorporateSchema()
        {
            const string assemblyName = "CrossDomain.Integration.Entities.dll";
            const string xsdResourceName = "SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0.FundingClaim.xsd";
            const string schemaNamespace = "urn:sfa:schemas:fundingclaim";
            XmlSchemaSet schemas;

            // arrange
            using (Stream stream = Assembly.LoadFrom(assemblyName).GetManifestResourceStream(xsdResourceName))
            {
                if (stream == null)
                {
                    Assert.Fail("Could not load FundingClaim schema resource.");
                }
                schemas = new XmlSchemaSet();
                schemas.Add(schemaNamespace, new XmlTextReader(stream));
            }

            List<string> validationErrors = new List<string>();
            
            // act
            XDocument xDoc = XDocument.Parse(_validFundingClaimXml, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);
            XAttribute schemaVersionAttribute = xDoc.Elements().Single(e => e.Name.LocalName == "FundingClaim").Attribute("schemaVersion");
            xDoc.Validate(schemas, (sender, e) => validationErrors.Add($"Error: {e.Exception.Message} at line {e.Exception.LineNumber}"));

            // assert
            Assert.IsFalse(validationErrors.Any(), $"Schema validation errors returned: {string.Join("\n", validationErrors)}");
            Assert.IsNotNull(schemaVersionAttribute, "No schema version attribute was found.");
            Assert.AreEqual(3.01m, decimal.Parse(schemaVersionAttribute.Value), "Schema version is incorrect.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaim_ShouldDeserializeValidXmlToCorporateSchemaType()
        {
            FundingClaim fundingClaim = new FundingClaim();

            try
            {
                fundingClaim = _validFundingClaimXml.DeserializeXml<FundingClaim>();
            }
            catch(InvalidOperationException ex)
            {
                Assert.Fail("Expected no exception, but got: " + ex.Message);
            }

            Assert.AreEqual(fundingClaim.FundingClaimAllAttrs.Count, 1, "Funding Claim example data did not deserialise correctly.");
        }
    }
}
