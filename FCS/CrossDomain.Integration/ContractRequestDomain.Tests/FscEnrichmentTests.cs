namespace ContractRequestDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Caching;
    using SFA.FCT.ContractRequestDomain.BusinessLogic;
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.FundingStreamConfigDomain.BusinessLogic;

    [TestClass]
    public class FscEnrichmentTests
    {
        private FileValidationFscEnrichment _fscFileEnrichment;
        private dataLoadResults _testData;

        [TestInitialize]
        public void GetData()
        {
            _fscFileEnrichment = new FileValidationFscEnrichment();
            XDocument xmlFile = XDocument.Load("Resources\\FscReferenceDataRequest.xml");

            _testData = (dataLoadResults) XmlSerialization.DeserializeXml(xmlFile.Root, typeof (dataLoadResults));
            
            ReferenceDataManager ReferenceDataManager = new ReferenceDataManager();

            var _organizationService = OrganisationServiceManager.GetOrgService();
            ReferenceDataManager.OrganizationService = _organizationService;

            _fscFileEnrichment.Manager = ReferenceDataManager;
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Check_FscReferenceData_CanBeRetrieved()
        {
            _fscFileEnrichment.Enrich(_testData);
            Assert.IsTrue(_testData.ReferenceData.FundingConfiguration.FundingConfigurationList.Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Check_FscReferenceData_CanBeRetrievedBad()
        {
            try
            {
                _fscFileEnrichment.Enrich(_testData);

            }
            catch (Exception ex)
            {
                Assert.IsTrue(ex.Message == "Cell value not found.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Check_FscReferenceData_IsCached()
        {
            //clear cache
            const string cacheName = "fscReferenceData";
            ObjectCache cache = MemoryCache.Default;
            cache.Remove(cacheName);

            List<FscDataCache> cacheData = cache[cacheName] as List<FscDataCache>;

            Assert.IsNull(cacheData);

            _fscFileEnrichment.Enrich(_testData);

            cacheData = cache[cacheName] as List<FscDataCache>;

            Assert.IsNotNull(cacheData);
        }

    }
}
