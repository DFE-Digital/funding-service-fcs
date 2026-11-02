using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators;
using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix2;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    [TestClass]
    public class Appendix2HeaderTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TestGetDocumentPartForAppendix2Header()
        {
            const string contractXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ctr:contract schemaVersion=\"8.00\" xsi:schemaLocation=\"contract D:\\TFS\\FCT\\Main\\Corporate\\Schemas\\contract_corporate_schema.xsd\" xmlns:ctr=\"urn:sfa:schemas:contract\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><ctr:contracts><ctr:contract><ctr:startDate>2015-08-01</ctr:startDate><ctr:endDate>2016-03-31</ctr:endDate></ctr:contract></ctr:contracts><ctr:fundingType><ctr:fundingTypeCode>MAIN</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType><ctr:contractNumber>SFA-1234</ctr:contractNumber></ctr:contract>";
            const string docGenXml = "<?xml version=\"1.0\"?><DocumentGenerationRequest xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://sfa.bis.gov.uk/fct\"><TemplateContainer>document-template-dev</TemplateContainer><TemplateFilename>A2H_MAIN_2015-08-01.docx</TemplateFilename><MergeData><MergeFields><MergeField><Name>MasterContractRef</Name><Value>SFA-1234</Value></MergeField></MergeFields><RepeatingSections /></MergeData></DocumentGenerationRequest>";

            TestHelpers.TestDocumentHeaderCreatorSupply<Appendix2HeaderCreator>("A2H_MAIN_2015-08-01.docx", contractXml, docGenXml);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestCanSupplyHeader()
        {
            Appendix2HeaderCreator creator = new Appendix2HeaderCreator(null);
            Assert.IsTrue(creator.CanSupplyHeader(Appendix2HeaderCreator.HeaderName));
        }
    }
}
