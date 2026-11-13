namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ESFAppendix1Test
    {
        private const string templateName_10004643_ESF623_4 = "A1_ESF_1420_2014-08-01.docx";
        private const string xml_10004643_ESF623_4 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ctr:contract schemaVersion=\"8.00\" xsi:schemaLocation=\"contract D:\\TFS\\FCT\\Main\\Corporate\\Schemas\\contract_corporate_schema.xsd\" xmlns:ctr=\"urn:sfa:schemas:contract\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><ctr:contracts><ctr:contract><ctr:fundingType><ctr:fundingTypeCode>ESF</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType><ctr:period><ctr:periodType><ctr:periodTypeCode>ESF</ctr:periodTypeCode><ctr:periodTypeName>EUROPEAN SOCIAL FUND</ctr:periodTypeName></ctr:periodType><ctr:period>1420</ctr:period><ctr:startDate>2014-08-01</ctr:startDate><ctr:endDate>2022-12-31</ctr:endDate></ctr:period><ctr:contractAllocations><ctr:contractAllocation><ctr:period><ctr:periodType><ctr:periodTypeCode>ESF</ctr:periodTypeCode><ctr:periodTypeName>EUROPEAN SOCIAL FUND</ctr:periodTypeName></ctr:periodType><ctr:period>1420</ctr:period><ctr:startDate>2014-08-01</ctr:startDate><ctr:endDate>2022-12-31</ctr:endDate></ctr:period><ctr:fundingStream><ctr:fundingStreamCode>ESF 201420</ctr:fundingStreamCode><ctr:fundingStreamName /><ctr:fundingTypeCode>1</ctr:fundingTypeCode><ctr:fundingStreamShortCode>ESF 20</ctr:fundingStreamShortCode></ctr:fundingStream><ctr:contractDeliverables /><ctr:contractAllocationNumber>ESF-4288</ctr:contractAllocationNumber><ctr:description>Skills Support for Redundancy</ctr:description><ctr:hierarchyType>CONTRACT ALLOCATION</ctr:hierarchyType><ctr:startDate>2015-08-01</ctr:startDate><ctr:endDate>2015-12-31</ctr:endDate><ctr:maximumContractValue>50000.00</ctr:maximumContractValue></ctr:contractAllocation></ctr:contractAllocations><ctr:contractNumber>ESF-623</ctr:contractNumber><ctr:contractVersionNumber>4</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10004643</ctr:ukprn><ctr:legalName>NORTHAMPTONSHIRE INDUSTRIAL TRAINING ASSOCIATION LIMITED</ctr:legalName></ctr:contractor><ctr:hierarchyType>CONTRACT</ctr:hierarchyType><ctr:startDate>2014-08-01</ctr:startDate><ctr:endDate>2020-07-31</ctr:endDate><ctr:contractStatus><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus><ctr:contractValue>50000.00</ctr:contractValue></ctr:contract></ctr:contracts><ctr:fundingType><ctr:fundingTypeCode>ESF</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType><ctr:contractNumber>SFA-6342</ctr:contractNumber><ctr:contractVersionNumber>4</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10004643</ctr:ukprn><ctr:legalName>NORTHAMPTONSHIRE INDUSTRIAL TRAINING ASSOCIATION LIMITED</ctr:legalName></ctr:contractor><ctr:hierarchyType>MASTER CONTRACT</ctr:hierarchyType><ctr:contractStatus><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus></ctr:contract>";
        private const string xml_10004643_ESF623_4_docgen = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><fct:DocumentGenerationRequest xmlns:fct=\"http://sfa.bis.gov.uk/fct\" xmlns:ctr=\"contract\"><fct:TemplateContainer>document-template-dev</fct:TemplateContainer><fct:TemplateFilename>A1_ESF_1420_2014-08-01.docx</fct:TemplateFilename><fct:MergeData><fct:MergeFields><fct:MergeField><fct:Name>MasterContractRef</fct:Name><fct:Value>SFA-6342</fct:Value></fct:MergeField><fct:MergeField><fct:Name>ContractTotal</fct:Name><fct:Value>50000.00</fct:Value></fct:MergeField><fct:MergeField><fct:Name>UKPRN</fct:Name><fct:Value>10004643</fct:Value></fct:MergeField><fct:MergeField><fct:Name>OrgName</fct:Name><fct:Value>NORTHAMPTONSHIRE INDUSTRIAL TRAINING ASSOCIATION LIMITED</fct:Value></fct:MergeField></fct:MergeFields><fct:RepeatingSections><fct:RepeatingSection><fct:Name>MainTable</fct:Name><fct:Rows><fct:Row><fct:MergeFields><fct:MergeField><fct:Name>AllocationName</fct:Name><fct:Value>Skills Support for Redundancy</fct:Value></fct:MergeField><fct:MergeField><fct:Name>AllocationContractRef</fct:Name><fct:Value>ESF-4288</fct:Value></fct:MergeField><fct:MergeField><fct:Name>AllocationStartDate</fct:Name><fct:Value>2015-08-01</fct:Value></fct:MergeField><fct:MergeField><fct:Name>AllocationEndDate</fct:Name><fct:Value>2015-12-31</fct:Value></fct:MergeField><fct:MergeField><fct:Name>AllocationTotal</fct:Name><fct:Value>50000.00</fct:Value></fct:MergeField></fct:MergeFields></fct:Row></fct:Rows></fct:RepeatingSection></fct:RepeatingSections></fct:MergeData></fct:DocumentGenerationRequest>";

        private const string templateName_10030877_ESF10_2 = "A1_ESF_1420_2014-08-01.docx";
        private const string xml_10030877_ESF10_2 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ctr:contract schemaVersion=\"8.00\" xsi:schemaLocation=\"contract D:\\TFS\\FCT\\Main\\Corporate\\Schemas\\contract_corporate_schema.xsd\" xmlns:ctr=\"urn:sfa:schemas:contract\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><ctr:contracts><ctr:contract><ctr:fundingType><ctr:fundingTypeCode>ESF</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType><ctr:period><ctr:periodType><ctr:periodTypeCode>ESF</ctr:periodTypeCode><ctr:periodTypeName>EUROPEAN SOCIAL FUND</ctr:periodTypeName></ctr:periodType><ctr:period>1420</ctr:period><ctr:startDate>2014-08-01</ctr:startDate><ctr:endDate>2022-12-31</ctr:endDate></ctr:period><ctr:contractAllocations><ctr:contractAllocation><ctr:period><ctr:periodType><ctr:periodTypeCode>ESF</ctr:periodTypeCode><ctr:periodTypeName>EUROPEAN SOCIAL FUND</ctr:periodTypeName></ctr:periodType><ctr:period>1420</ctr:period><ctr:startDate>2014-08-01</ctr:startDate><ctr:endDate>2022-12-31</ctr:endDate></ctr:period><ctr:fundingStream><ctr:fundingStreamCode>ESF 201420</ctr:fundingStreamCode><ctr:fundingStreamName /><ctr:fundingTypeCode>ESF</ctr:fundingTypeCode><ctr:fundingStreamShortCode>ESF 20</ctr:fundingStreamShortCode></ctr:fundingStream><ctr:contractDeliverables /><ctr:contractAllocationNumber>ESF-88</ctr:contractAllocationNumber><ctr:description>Skills Support for Redundancy</ctr:description><ctr:hierarchyType>CONTRACT ALLOCATION</ctr:hierarchyType><ctr:startDate>2015-08-01</ctr:startDate><ctr:endDate>2016-09-30</ctr:endDate><ctr:maximumContractValue>1000000.00</ctr:maximumContractValue></ctr:contractAllocation><ctr:contractAllocation><ctr:period><ctr:periodType><ctr:periodTypeCode>ESF</ctr:periodTypeCode><ctr:periodTypeName>EUROPEAN SOCIAL FUND</ctr:periodTypeName></ctr:periodType><ctr:period>1420</ctr:period><ctr:startDate>2014-08-01</ctr:startDate><ctr:endDate>2022-12-31</ctr:endDate></ctr:period><ctr:fundingStream><ctr:fundingStreamCode>ESF 201420</ctr:fundingStreamCode><ctr:fundingStreamName /><ctr:fundingTypeCode>ESF</ctr:fundingTypeCode><ctr:fundingStreamShortCode>ESF 20</ctr:fundingStreamShortCode></ctr:fundingStream><ctr:contractDeliverables /><ctr:contractAllocationNumber>ESF-196</ctr:contractAllocationNumber><ctr:description>Skills Support for the Unemployed</ctr:description><ctr:hierarchyType>CONTRACT ALLOCATION</ctr:hierarchyType><ctr:startDate>2016-04-01</ctr:startDate><ctr:endDate>2016-07-31</ctr:endDate><ctr:maximumContractValue>228758.54</ctr:maximumContractValue></ctr:contractAllocation></ctr:contractAllocations><ctr:contractNumber>ESF-10</ctr:contractNumber><ctr:contractVersionNumber>2</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10030877</ctr:ukprn><ctr:legalName>KENTUCKY FRIED CHICKEN (GREAT BRITAIN) LIMITED</ctr:legalName></ctr:contractor><ctr:hierarchyType>CONTRACT</ctr:hierarchyType><ctr:startDate>2014-08-01</ctr:startDate><ctr:endDate>2020-07-31</ctr:endDate><ctr:contractStatus><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus><ctr:contractValue>1228758.54</ctr:contractValue></ctr:contract></ctr:contracts><ctr:contractNumber>SFA-9092</ctr:contractNumber><ctr:contractVersionNumber>2</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10030877</ctr:ukprn><ctr:legalName>KENTUCKY FRIED CHICKEN (GREAT BRITAIN) LIMITED</ctr:legalName></ctr:contractor><ctr:hierarchyType>MASTER CONTRACT</ctr:hierarchyType><ctr:contractStatus><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus></ctr:contract>";
        private const string xml_10030877_ESF10_2_docgen = "<?xml version=\"1.0\"?><DocumentGenerationRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"http://sfa.bis.gov.uk/fct\"><TemplateContainer>document-template-dev</TemplateContainer><TemplateFilename>A1_ESF_1420_2014-08-01.docx</TemplateFilename><MergeData><MergeFields><MergeField><Name>MasterContractRef</Name><Value>SFA-9092</Value></MergeField><MergeField><Name>ContractTotal</Name><Value>1228758.54</Value></MergeField><MergeField><Name>UKPRN</Name><Value>10030877</Value></MergeField><MergeField><Name>OrgName</Name><Value>KENTUCKY FRIED CHICKEN (GREAT BRITAIN) LIMITED</Value></MergeField></MergeFields><RepeatingSections><RepeatingSection><Name>MainTable</Name><Rows><Row><MergeFields><MergeField><Name>AllocationName</Name><Value>Skills Support for Redundancy</Value></MergeField><MergeField><Name>AllocationContractRef</Name><Value>ESF-88</Value></MergeField><MergeField><Name>AllocationStartDate</Name><Value>2015-08-01</Value></MergeField><MergeField><Name>AllocationEndDate</Name><Value>2016-09-30</Value></MergeField><MergeField><Name>AllocationTotal</Name><Value>1000000.00</Value></MergeField></MergeFields><RepeatingSection><Rows /></RepeatingSection></Row><Row><MergeFields><MergeField><Name>AllocationName</Name><Value>Skills Support for the Unemployed</Value></MergeField><MergeField><Name>AllocationContractRef</Name><Value>ESF-196</Value></MergeField><MergeField><Name>AllocationStartDate</Name><Value>2016-04-01</Value></MergeField><MergeField><Name>AllocationEndDate</Name><Value>2016-07-31</Value></MergeField><MergeField><Name>AllocationTotal</Name><Value>228758.54</Value></MergeField></MergeFields><RepeatingSection><Rows /></RepeatingSection></Row></Rows></RepeatingSection></RepeatingSections></MergeData></DocumentGenerationRequest>";

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatDocumentPartIsRequiredForESF()
        {
            Contract masterContract = TestHelpers.GetObjectFromXml<Contract>(xml_10004643_ESF623_4);
            ESFAppendix1 classUnderTest = new ESFAppendix1(null, null, null);
            Assert.IsTrue(classUnderTest.IsDocumentPartRequired(masterContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatDocumentPartIsNotRequiredForOtherForESFAppendix1()
        {
            Contract masterContract = TestHelpers.GetObjectFromXml<Contract>(xml_10004643_ESF623_4.Replace("<ctr:fundingType><ctr:fundingTypeCode>ESF</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType>", "<ctr:fundingType><ctr:fundingTypeCode>OTHER</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType>"));
            ESFAppendix1 classUnderTest = new ESFAppendix1(null, null, null);
            Assert.IsFalse(classUnderTest.IsDocumentPartRequired(masterContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatHeaderIsNotRequiredForESFAppendix1()
        {
            Assert.IsFalse(new ESFAppendix1(null, DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories(), DocumentConfigurationSourceTests.GetMockFpQueryRepository(new List<MockQueryRepositorySetup>())).IsHeaderDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatRequiredHeaderDocumentNameThrowsExceptionForESFAppendix1()
        {
            Assert.ThrowsExactly<ApplicationException>(() =>
            {
                var sut = new ESFAppendix1(
                    null,
                    DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories(),
                    DocumentConfigurationSourceTests.GetMockFpQueryRepository(new List<MockQueryRepositorySetup>())
                );

                // Trigger the exception by accessing the property
                _ = sut.RequiredHeaderDocumentName;
            });
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetDocumentPartFor10004643()
        {
            TestHelpers.TestDocumentPartCreatorSupply<ESFAppendix1>(templateName_10004643_ESF623_4, xml_10004643_ESF623_4, xml_10004643_ESF623_4_docgen);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetdocumentPartFor10030877()
        {
            TestHelpers.TestDocumentPartCreatorSupply<ESFAppendix1>(templateName_10030877_ESF10_2, xml_10030877_ESF10_2, xml_10030877_ESF10_2_docgen);
        }

    }
}
