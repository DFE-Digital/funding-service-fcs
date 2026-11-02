namespace OrganisationDomain.Implementation.Tests.BusinessLogic
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using Implementation.BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;

    [TestClass]
    public class CpdsXmlValidatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void HasMultipleActiveProvidersWithSameUkprn_ShouldReturnTrue_WhenTheResponseContainsMultipleActiveProviders()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml =
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" + 
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                             "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" + 
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                    "<Provider ProviderSequenceNumber='1111111' id='25114'>" + 
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            //Act
            bool hasMultipleActiveProviders = cpdsXmlValidator.HasMultipleActiveProvidersWithTheSameUkprn(XDocument.Parse(cpdsXml));

            //Assert
            Assert.IsTrue(hasMultipleActiveProviders, "HasMultipleActiveProvidersWithSameUkprn did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HasMultipleActiveProvidersWithSameUkprn_ShouldReturnFalse_WhenTheResponseContainsMultipleProvidersWithDifferentStatuses()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml =
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                    "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='110831' Type='C'>" +
                            "<EffectiveFrom>2009-03-19T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>2011-06-30T00:00:00+01:00</EffectiveTo>" +
                            "<CodeType id='87'>" +
                                "<CodeType>TPS_0910</CodeType>" +
                                "<CodeTypeDesc>Training Provider Statement 2009/10</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='197'>" +
                                "<CodeValueName>2</CodeValueName>" +
                                "<CodeValueDesc>Online Form</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            //Act
            bool hasMultipleActiveProviders = cpdsXmlValidator.HasMultipleActiveProvidersWithTheSameUkprn(XDocument.Parse(cpdsXml));

            //Assert
            Assert.IsFalse(hasMultipleActiveProviders, "HasMultipleActiveProvidersWithSameUkprn did not return false");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderHasAnActiveStatusCodeElement_ShouldReturnTrue_WhenTheProviderXMLContainsAnActiveStatusCodeElement()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml = "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +             
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                             "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
            var responseXml = XDocument.Parse(cpdsXml);          
            XElement provider = responseXml.Root.Element(ns + "Provider");
 
            //Act        
            bool providerHasAnActiveStatusCodeElement = cpdsXmlValidator.ProviderHasAnActiveStatusCodeElement(provider);

            //Assert
            Assert.IsTrue(providerHasAnActiveStatusCodeElement, "HasMultipleActiveProvidersWithSameUkprn did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderHasAnActiveStatusCodeElement_ShouldReturnFalse_WhenTheProviderXMLDonesNotContainAnActiveStatusCodeElement()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml = "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
            var responseXml = XDocument.Parse(cpdsXml);
            XElement provider = responseXml.Root.Element(ns + "Provider");

            //Act        
            bool providerHasAnActiveStatusCodeElement = cpdsXmlValidator.ProviderHasAnActiveStatusCodeElement(provider);

            //Assert
            Assert.IsFalse(providerHasAnActiveStatusCodeElement, "HasMultipleActiveProvidersWithSameUkprn did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RemoveProvidersThatAreNotActiveOrDoNotHaveANumericUpin_ShouldRemoveAllProvidersThatAreNotActiveOrDoNotHaveANumericUpin()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml =
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                    "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>L05008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                    "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='110831' Type='C'>" +
                            "<EffectiveFrom>2009-03-19T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>2011-06-30T00:00:00+01:00</EffectiveTo>" +
                            "<CodeType id='87'>" +
                                "<CodeType>TPS_0910</CodeType>" +
                                "<CodeTypeDesc>Training Provider Statement 2009/10</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='197'>" +
                                "<CodeValueName>2</CodeValueName>" +
                                "<CodeValueDesc>Online Form</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            var responseXml = XDocument.Parse(cpdsXml);

            //Act        
            cpdsXmlValidator.RemoveProvidersThatAreNotActiveOrDoNotHaveANumericUpin(responseXml);
          
            //Assert
            var expectedResult = "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                  "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                       "<Upin>105008</Upin>" +
                       "<UKPRN>12345678</UKPRN>" +
                       "<TradingName>LEARNING UPDATE</TradingName>" +
                       "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                       "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                       "<CharityNumber>UNKNOWN</CharityNumber>" +
                       "<ProviderType id='49'>" +
                         "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                         "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                         "<ParentTypeCode>PRIV</ParentTypeCode>" +
                         "<IsIndependent>Y</IsIndependent>" +
                       "</ProviderType>" +
                       "<Codes id='120649' Type='C'>" +
                           "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                           "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                           "<CodeType id='91'>" +
                               "<CodeType>EXTSTATUS</CodeType>" +
                               "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                           "</CodeType>" +
                           "<CodeValue id='214'>" +
                               "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                               "<CodeValueDesc>Active</CodeValueDesc>" +
                           "</CodeValue>" +
                       "</Codes>" +
                   "</Provider>" +
               "</ProviderDataSetV2>";

            var expectedXML = XDocument.Parse(expectedResult);
            Assert.IsTrue(responseXml.ToString() == expectedXML.ToString(), "The inactive providers were not removed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RemoveProvidersThatDoNotHaveAMatchingUpin_ShouldRemoveAllProvidersDoNotHaveAMatchingUpin()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml =
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>11111111</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                    "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>22222222</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='110831' Type='C'>" +
                            "<EffectiveFrom>2009-03-19T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>2011-06-30T00:00:00+01:00</EffectiveTo>" +
                            "<CodeType id='87'>" +
                                "<CodeType>TPS_0910</CodeType>" +
                                "<CodeTypeDesc>Training Provider Statement 2009/10</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='197'>" +
                                "<CodeValueName>2</CodeValueName>" +
                                "<CodeValueDesc>Online Form</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            var responseXml = XDocument.Parse(cpdsXml);

            //Act        
            cpdsXmlValidator.RemoveProvidersThatDoNotHaveAMatchingUpin(responseXml,11111111);

            //Assert
            var expectedResult = 
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>11111111</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                            "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
               "</ProviderDataSetV2>";

            var expectedXML = XDocument.Parse(expectedResult);
            Assert.IsTrue(responseXml.ToString() == expectedXML.ToString(), "The providers with non matching Upins were not removed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderHasANumericUpin_ShouldReturnTrue_WhenTheProviderHasANumericUpin()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml = "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>105008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                             "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
            var responseXml = XDocument.Parse(cpdsXml);
            XElement provider = responseXml.Root.Element(ns + "Provider");

            //Act        
            bool providerHasANumericUpin = ((CpdsXmlValidator) cpdsXmlValidator).ProviderHasANumericUpin(provider);

            //Assert
            Assert.IsTrue(providerHasANumericUpin, "ProviderHasANumericUpin did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderHasANumericUpin_ShouldReturnFalse_WhenTheProviderDoesNotHaveANumericUpin()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            var cpdsXml = "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                   "<Provider ProviderSequenceNumber='1111111' id='25114'>" +
                        "<Upin>L05008</Upin>" +
                        "<UKPRN>12345678</UKPRN>" +
                        "<TradingName>LEARNING UPDATE</TradingName>" +
                        "<RegisteredName>LEARNING UPDATE</RegisteredName>" +
                        "<Dissolved>1899-12-30T00:00:00+00:00</Dissolved>" +
                        "<CharityNumber>UNKNOWN</CharityNumber>" +
                        "<ProviderType id='49'>" +
                          "<ProviderType>PRI/LBG/NSC (Use of Limited exemption)</ProviderType>" +
                          "<ProviderTypeCode>PBGS</ProviderTypeCode>" +
                          "<ParentTypeCode>PRIV</ParentTypeCode>" +
                          "<IsIndependent>Y</IsIndependent>" +
                        "</ProviderType>" +
                        "<Codes id='120649' Type='C'>" +
                            "<EffectiveFrom>2001-01-01T00:00:00+00:00</EffectiveFrom>" +
                            "<EffectiveTo>9999-12-31T00:00:00+00:00</EffectiveTo>" +
                            "<CodeType id='91'>" +
                                "<CodeType>EXTSTATUS</CodeType>" +
                                "<CodeTypeDesc>Extended Status code for Organisation</CodeTypeDesc>" +
                             "</CodeType>" +
                            "<CodeValue id='214'>" +
                                "<CodeValueName>ES_ACTIVE</CodeValueName>" +
                                "<CodeValueDesc>Active</CodeValueDesc>" +
                            "</CodeValue>" +
                        "</Codes>" +
                    "</Provider>" +
                "</ProviderDataSetV2>";

            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
            var responseXml = XDocument.Parse(cpdsXml);
            XElement provider = responseXml.Root.Element(ns + "Provider");

            //Act        
            bool providerHasANumericUpin = ((CpdsXmlValidator)cpdsXmlValidator).ProviderHasANumericUpin(provider);

            //Assert
            Assert.IsFalse(providerHasANumericUpin, "ProviderHasANumericUpin did not return false");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsOrganisationValidAgainstOrganisationCorporateSchema_ShouldReturnTrue_WhenTheXmlIsValidAgainstTheOrganisationCorporateSchema()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            //arrange
            var organisationToValidate = new organisation
            {
                organisationId = "ORG0000001",
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
                        organisationIdentifier = "50000001"
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName
                    {
                        organisationName = "NACRO"
                    }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = "Active",
                            organisationStatusScheme = organisationStatusSchemeType.LEGAL
                        }                   
                    }
                },
                organisationTypeRelationships = new List<organisationTypeRelationshipsOrganisationTypeRelationship>()
                {
                    new organisationTypeRelationshipsOrganisationTypeRelationship
                    {
                        organisationType = new organisationTypeRelationshipsOrganisationTypeRelationshipOrganisationType
                        {
                            organisationTypeScheme = organisationTypeSchemeType.CORPORATE,
                            organisationType = "PRI/LBG/NSC (Use of Limited exemption)"
                        }
                    }
                }
            };

            //Act
            List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
            bool isOrgXmlValidAgainstCorporateSchema = cpdsXmlValidator.IsOrganisationValidAgainstOrganisationCorporateSchema(organisationToValidate, out validationErrors);

            //Assert
            Assert.IsTrue(isOrgXmlValidAgainstCorporateSchema, "IsOrganisationValidAgainstOrganisationCorporateSchema did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsOrganisationValidAgainstOrganisationCorporateSchema_ShouldReturnFalse_WhenTheXmlIsNotValidAgainstTheOrganisationCorporateSchema()
        {
            //Arrange
            ICpdsXmlValidator cpdsXmlValidator = new CpdsXmlValidator();

            //arrange
            var organisationToValidate = new organisation
            {
                organisationId = "ORG000000199999", //This is invalid
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
                        organisationIdentifier = "50000001"
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName
                    {
                        organisationName = "NACRO"
                    }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = "Active",
                            organisationStatusScheme = organisationStatusSchemeType.LEGAL
                        }                   
                    }
                },
                organisationTypeRelationships = new List<organisationTypeRelationshipsOrganisationTypeRelationship>()
                {
                    new organisationTypeRelationshipsOrganisationTypeRelationship
                    {
                        organisationType = new organisationTypeRelationshipsOrganisationTypeRelationshipOrganisationType
                        {
                            organisationTypeScheme = organisationTypeSchemeType.CORPORATE,
                            organisationType = "PRI/LBG/NSC (Use of Limited exemption)"
                        }
                    }
                }
            };

            //Act
            List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
            bool isOrgXmlValidAgainstCorporateSchema = cpdsXmlValidator.IsOrganisationValidAgainstOrganisationCorporateSchema(organisationToValidate, out validationErrors);

            //Assert
            Assert.IsFalse(isOrgXmlValidAgainstCorporateSchema, "IsOrganisationValidAgainstOrganisationCorporateSchema did not return false");
            Assert.IsTrue(validationErrors.Any(x=>x.ErrorMessage.Contains("organisationId")),"A organisationId error message was not returned");
        }
    }
}
