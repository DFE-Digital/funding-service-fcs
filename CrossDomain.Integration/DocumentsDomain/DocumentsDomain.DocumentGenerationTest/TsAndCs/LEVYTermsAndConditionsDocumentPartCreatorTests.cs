namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.TsAndCs
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using Common.Models;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.TsAndCs;

    [TestClass]
    public class LEVYTermsAndConditionsDocumentPartCreatorTests
    {
        private const string xml_10000976_APPLEVY1_v1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ctr:contract schemaVersion=\"8.00\" xsi:schemaLocation=\"contract D:\\TFS\\FCT\\Main\\Corporate\\Schemas\\contract_corporate_schema.xsd\" xmlns:ctr=\"urn:sfa:schemas:contract\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><ctr:contracts><ctr:contract><ctr:fundingType><ctr:fundingTypeCode>LEVY</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType><ctr:period><ctr:periodType><ctr:periodTypeCode>LEVY</ctr:periodTypeCode><ctr:periodTypeName>ACADEMIC YEAR</ctr:periodTypeName></ctr:periodType><ctr:period>1799</ctr:period><ctr:startDate>2015-04-01</ctr:startDate><ctr:endDate>2016-03-31</ctr:endDate></ctr:period><ctr:contractAllocations><ctr:contractAllocation><ctr:period><ctr:periodType><ctr:periodTypeCode>AY</ctr:periodTypeCode><ctr:periodTypeName>ACADEMIC YEAR</ctr:periodTypeName></ctr:periodType><ctr:period>1516</ctr:period><ctr:startDate>2015-04-01</ctr:startDate><ctr:endDate>2016-03-31</ctr:endDate></ctr:period><ctr:fundingStream><ctr:fundingStreamCode>AGE</ctr:fundingStreamCode><ctr:fundingStreamName /><ctr:fundingTypeCode>1</ctr:fundingTypeCode><ctr:fundingStreamShortCode>AGE</ctr:fundingStreamShortCode></ctr:fundingStream><ctr:contractDeliverables><ctr:contractDeliverable><ctr:deliverable><ctr:fundingStreamCode>AGE</ctr:fundingStreamCode><ctr:deliverableCode>1</ctr:deliverableCode></ctr:deliverable><ctr:contractDeliverablePeriods><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>4</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>31946.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>5</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>6</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>15482.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>7</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>45126.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>8</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>42849.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>9</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>54090.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>10</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>24009.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>11</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>52701.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>12</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>33154.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>1</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>2</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>58786.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>3</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>24067.00</ctr:plannedValue></ctr:contractDeliverablePeriod></ctr:contractDeliverablePeriods><ctr:deliverableDescription>16-18 Apprenticeship Grant for Employers</ctr:deliverableDescription></ctr:contractDeliverable><ctr:contractDeliverable><ctr:deliverable><ctr:fundingStreamCode>AGE</ctr:fundingStreamCode><ctr:deliverableCode>2</ctr:deliverableCode></ctr:deliverable><ctr:contractDeliverablePeriods><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>4</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>5</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>6</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>55547.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>7</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>45142.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>8</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>19663.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>9</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>10</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>51367.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>11</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>12</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>1</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>2</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>11688.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>3</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>28933.00</ctr:plannedValue></ctr:contractDeliverablePeriod></ctr:contractDeliverablePeriods><ctr:deliverableDescription>19-24 Apprenticeship Grant for Employers</ctr:deliverableDescription></ctr:contractDeliverable></ctr:contractDeliverables><ctr:contractAllocationNumber>APPLEVY-3928</ctr:contractAllocationNumber><ctr:description>Apprenticeship Grant for Employers</ctr:description><ctr:hierarchyType>CONTRACT ALLOCATION</ctr:hierarchyType><ctr:startDate>2015-08-01</ctr:startDate><ctr:endDate>2016-07-31</ctr:endDate></ctr:contractAllocation></ctr:contractAllocations><ctr:contractNumber>EMPAGE-1</ctr:contractNumber><ctr:contractVersionNumber>1</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10000976</ctr:ukprn><ctr:legalName>BUCKINGHAMSHIRE COUNTY COUNCIL</ctr:legalName></ctr:contractor><ctr:hierarchyType>CONTRACT</ctr:hierarchyType><ctr:startDate>2015-08-01</ctr:startDate><ctr:endDate>2016-07-31</ctr:endDate><ctr:contractStatus><ctr:status>DRAFT</ctr:status><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus><ctr:contractValue>594550</ctr:contractValue></ctr:contract></ctr:contracts><ctr:fundingType><ctr:fundingTypeCode>LEVY</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType><ctr:contractNumber>SFA-9009</ctr:contractNumber><ctr:contractVersionNumber>1</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10000976</ctr:ukprn><ctr:legalName>BUCKINGHAMSHIRE COUNTY COUNCIL</ctr:legalName></ctr:contractor><ctr:hierarchyType>MASTER CONTRACT</ctr:hierarchyType><ctr:contractStatus><ctr:status>DRAFT</ctr:status><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus></ctr:contract>";
        private string template_name = "T&C_LEVY_1799_2015-04-01.docx";

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatDocumentPartIsRequiredForLEVY()
        {
            contract masterContract = TestHelpers.GetObjectFromXml<contract>(xml_10000976_APPLEVY1_v1);
            LEVYTermsAndConditionsDocumentPartCreator classUnderTest = new LEVYTermsAndConditionsDocumentPartCreator(null, null, null);
            Assert.IsTrue(classUnderTest.IsDocumentPartRequired(masterContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatDocumentPartIsNotRequiredForOtherForLEVYTsAndCs()
        {
            contract masterContract = TestHelpers.GetObjectFromXml<contract>(xml_10000976_APPLEVY1_v1.Replace("<ctr:fundingType><ctr:fundingTypeCode>LEVY</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType>", "<ctr:fundingType><ctr:fundingTypeCode>OTHER</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType>"));
            LEVYTermsAndConditionsDocumentPartCreator classUnderTest = new LEVYTermsAndConditionsDocumentPartCreator(null, null, null);
            Assert.IsFalse(classUnderTest.IsDocumentPartRequired(masterContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatHeaderIsNotRequiredForLEVYTsAndCsAppendix1()
        {
            Assert.IsFalse(new LEVYTermsAndConditionsDocumentPartCreator(null, null, null).IsHeaderDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(ApplicationException))]
        public void TestThatRequiredHeaderDocumentNameThrowsExceptionForLEVYHeaderName()
        {
            string headerName = new LEVYTermsAndConditionsDocumentPartCreator(null, DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories(), null).RequiredHeaderDocumentName;
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestSupplyDocumentGenerationWithNullAllocationCollection()
        {
            contract masterContract = new contract()
            {
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "LEVY"
                        },
                        period = new period
                        {
                            period1 = "1799",
                            periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.LEVY, periodTypeName = periodTypeNameType.APPRENTICESHIPLEVY}
                        }
                    }
                }
            };

            masterContract.contracts[0].contractAllocations = null;


            TestHelpers.TestDocumentPartCreatorSupply<LEVYTermsAndConditionsDocumentPartCreator>(template_name, null, masterContract, new DocumentGenerationRequest[0]);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestSupplyDocumentGenerationWithEmptyAllocationCollection()
        {
            contract masterContract = new contract()
            {
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "LEVY"
                        },
                        period = new period
                        {
                            period1 = "1799",
                            periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.LEVY, periodTypeName = periodTypeNameType.APPRENTICESHIPLEVY}
                        },
                        contractAllocations = new List<contractAllocationsContractAllocation>()
                    }
                }
            };

            TestHelpers.TestDocumentPartCreatorSupply<LEVYTermsAndConditionsDocumentPartCreator>(template_name, null, masterContract, new DocumentGenerationRequest[0]);
        }

    }
}
