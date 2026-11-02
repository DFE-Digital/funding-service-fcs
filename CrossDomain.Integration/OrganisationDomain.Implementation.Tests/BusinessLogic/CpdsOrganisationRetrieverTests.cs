namespace OrganisationDomain.Implementation.Tests.BusinessLogic
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System.ServiceModel;
    using System.Xml.Linq;
    using OrganisationDomain.Implementation.BusinessExceptions;
    using OrganisationDomain.Implementation.BusinessLogic;
    using OrganisationDomain.Implementation.Mappers;
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus.Logging;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class CpdsOrganisationRetrieverTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetProviderByUKPRN_ShouldCallCPDSGetProvidersByUKRPNWithTheCorrectUKPRN()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;

            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse {RawCPDSResponse = "<organisation/>"});

            List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
            var mockCpdsXmlValidator = new Mock<ICpdsXmlValidator>();
            mockCpdsXmlValidator.Setup(x=>x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(),out validationErrors)).Returns(true);

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, mockCpdsXmlValidator.Object);

            //Act
            cpdsOrganisationRetriever.GetProviderByUkprn(500000001);

            //Assert
            mockCpdsGatewayService.Verify(
                x => x.GetProvidersByUKPRN(It.Is<GProvByUKPRINRequest>(req => req.UKPRNs[0].UKPRNData == "500000001")),
                Times.Once(),
                "CPDS gateway service was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(CommunicationException))]
        public void GetProviderByUKPRN_ShouldAbortTheServiceClient_WhenAnExceptionIsThrown()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();
         
            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Throws(new CommunicationException("Exception was thrown"));

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, new Mock<ICpdsXmlValidator>().Object);
            
            //Act
            cpdsOrganisationRetriever.GetProviderByUkprn(It.IsAny<int>());

            //Assert
            mockCpdsGatewayService.As<ICommunicationObject>().Verify(x => x.Abort(), Times.Once(),
                "CPDS service client was not aborted when an exception was thrown");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetProviderByUKPRN_ShouldCallHasMultipleActiveProvidersWithSameUkprn_UsingTheRawResponseFromCPDS()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            var mockCpdsMapper = new Mock<ICpdsMapper>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;

            const string rawCpdsResponse = "<organisation/>";
            var orgXml = XDocument.Parse(rawCpdsResponse);

            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponse });

            List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
            var mockCpdsXmlValidator = new Mock<ICpdsXmlValidator>();
            mockCpdsXmlValidator.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(), out validationErrors)).Returns(true);

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, mockCpdsMapper.Object, mockCpdsXmlValidator.Object);
          
            //Act
            cpdsOrganisationRetriever.GetProviderByUkprn(It.IsAny<int>());

            //Assert
            mockCpdsXmlValidator.Verify(x => x.HasMultipleActiveProvidersWithTheSameUkprn(It.Is<XDocument>(doc => doc.ToString() == orgXml.ToString())),
                Times.Once(), "The CPDS XML Validator was not called with the CPDS raw response");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(DuplicateUkprnProviderException))]
        public void GetProviderByUKPRN_ShouldThrowADuplicateUkPrnException_WhenHasMultipleActiveProvidersWithTheSameUkprnReturnsTrue()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();

            var loggerMock = new Mock<ILog>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;
            
            const string rawCpdsResponse = "<organisation/>";

            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponse });

            var mockCpdsXmlValidator = new Mock<ICpdsXmlValidator>();
            mockCpdsXmlValidator.Setup(x => x.HasMultipleActiveProvidersWithTheSameUkprn(It.IsAny<XDocument>()))
                .Returns(true);

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, mockCpdsXmlValidator.Object);

            var wasExceptionThrown = false;
            //Act
            try
            {
                cpdsOrganisationRetriever.GetProviderByUkprn(It.IsAny<int>());
            }
            catch (DuplicateUkprnProviderException)
            {
                wasExceptionThrown = true;
                throw;
            }

            //Assert
            Assert.IsTrue(wasExceptionThrown, "DuplicateUkprnProviderException was not thrown");
            //Expected exception of DuplicateUkprnProviderException (see method annotation)
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetProviderByUKPRN_ShouldCallRemoveProvidersThatAreNotActive_UsingTheRawResponseFromCPDS()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            var mockCpdsMapper = new Mock<ICpdsMapper>();
            var mockCpdsXmlValidator = new Mock<ICpdsXmlValidator>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;

            const string rawCpdsResponse = "<organisation/>";
            var orgXml = XDocument.Parse(rawCpdsResponse);

            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponse });

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, mockCpdsMapper.Object, mockCpdsXmlValidator.Object);
            
            mockCpdsXmlValidator.Setup(x => x.HasMultipleActiveProvidersWithTheSameUkprn(It.IsAny<XDocument>()))
                .Returns(false);

            List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
            mockCpdsXmlValidator.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(), out validationErrors)).Returns(true);

            //Act
            cpdsOrganisationRetriever.GetProviderByUkprn(It.IsAny<int>());

            //Assert
            mockCpdsXmlValidator.Verify(x => x.RemoveProvidersThatAreNotActiveOrDoNotHaveANumericUpin(It.Is<XDocument>(doc => doc.ToString() == orgXml.ToString())),
                Times.Once(), "RemoveProvidersThatAreNotActive was not called with the CPDS raw response");
        }

        
        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(CommunicationException))]
        public void GetProviderByUkprn_WhenCallToCpdsFails_ShouldLogError()
        {
            // Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();
            var loggerMock = new Mock<ILog>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;

            var e = new CommunicationException("Exception was thrown");
            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Throws(e);

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, new Mock<ICpdsXmlValidator>().Object);
            
            // Act
            cpdsOrganisationRetriever.GetProviderByUkprn(It.IsAny<int>());

            // Assert
            loggerMock.Verify(x => x.Error(It.Is<String>(y => y.Contains("CPDS has failed")), e));
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(Exception))]
        public void GetProviderByUkprn_WhenProcessResponseFails_ShouldLogError()
        {
            // Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();
            var loggerMock = new Mock<ILog>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;

            const string rawCpdsResponse = "<organisation/>";
            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponse });

            var e = new Exception();

            var cpdsXmlValidatorMock = new Mock<ICpdsXmlValidator>();
            cpdsXmlValidatorMock.Setup(x => x.HasMultipleActiveProvidersWithTheSameUkprn(It.IsAny<XDocument>()))
                .Throws(e);

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, cpdsXmlValidatorMock.Object);

            // Act
            cpdsOrganisationRetriever.GetProviderByUkprn(It.IsAny<int>());

            // Assert
            loggerMock.Verify(x => x.Error(It.Is<String>(y => y.Contains("Error trying to process")), e));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetProviderByUkprnAndUpin_ShouldCallCPDSGetProvidersByUKRPNWithTheCorrectUKPRN()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;

            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = "<organisation/>" });

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, new Mock<ICpdsXmlValidator>().Object);

            //Act
            cpdsOrganisationRetriever.GetProviderByUkprnAndUpin(500000001,It.IsAny<int>());

            //Assert
            mockCpdsGatewayService.Verify(
                x => x.GetProvidersByUKPRN(It.Is<GProvByUKPRINRequest>(req => req.UKPRNs[0].UKPRNData == "500000001")),
                Times.Once(),
                "CPDS gateway service was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetProviderByUkprnAndUpin_ShouldCallRemoveProvidersThatDoNotHaveAMatchingUpin_UsingTheRawResponseFromCPDS()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            var mockCpdsMapper = new Mock<ICpdsMapper>();
            var mockCpdsXmlValidator = new Mock<ICpdsXmlValidator>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();

            Func<GatewayServiceContract> factory = () => mockCpdsGatewayService.Object;

            const string rawCpdsResponse = "<organisation/>";
            var orgXml = XDocument.Parse(rawCpdsResponse);

            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponse });

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, mockCpdsMapper.Object, mockCpdsXmlValidator.Object);

            int upinToSearchFor = 12345;
            //Act
            cpdsOrganisationRetriever.GetProviderByUkprnAndUpin(It.IsAny<int>(), upinToSearchFor);

            //Assert
            mockCpdsXmlValidator.Verify(x => x.RemoveProvidersThatDoNotHaveAMatchingUpin(It.Is<XDocument>(doc => doc.ToString() == orgXml.ToString()),upinToSearchFor),
                Times.Once(), "The RemoveProvidersThatDoNotHaveAMatchingUpin method was not called with the correct Upin and the raw response from CPDS");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(CommunicationException))]
        public void GetProviderByUkprnAndUpin_WhenCallToCpdsFails_ShouldLogError()
        {
            // Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();
            var loggerMock = new Mock<ILog>();

            var e = new CommunicationException("Exception was thrown");
            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Throws(e);

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, new Mock<ICpdsXmlValidator>().Object);

            // Act
            cpdsOrganisationRetriever.GetProviderByUkprnAndUpin(It.IsAny<int>(), It.IsAny<int>());

            // Assert
            loggerMock.Verify(x => x.Error(It.Is<String>(y => y.Contains("CPDS has failed")), e));
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(OrganisationCorporateSchemaValidationFailedException))]
        public void GetProviderByUKPRN_ShouldThrowAnOrganisationCorporateSchemaValidationFailedException_WhenTheXmlResponseFromCpdsIsInvalidWhenMappedToCorporateSchema()
        {
            //Arrange
            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.As<ICommunicationObject>();
            mockCpdsGatewayService.As<IDisposable>();

            const string rawCpdsResponse = "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +             
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

            mockCpdsGatewayService.Setup(x => x.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponse });

            var mockCpdsXmlValidator = new Mock<ICpdsXmlValidator>();
            List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
            mockCpdsXmlValidator.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(), out validationErrors)).Returns(false);

            var cpdsOrganisationRetriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, new Mock<ICpdsMapper>().Object, mockCpdsXmlValidator.Object);
           
            var wasExceptionThrown = false;
            //Act
            try
            {
                cpdsOrganisationRetriever.GetProviderByUkprn(It.IsAny<int>());
            }
            catch (OrganisationCorporateSchemaValidationFailedException)
            {
                wasExceptionThrown = true;
                throw;
            }

            //Assert
            Assert.IsTrue(wasExceptionThrown, "OrganisationCorporateSchemaValidationFailedException was not thrown");
            //Expected exception of DuplicateUkprnProviderException (see method annotation)
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CpdsOrganisationRetrieverTest_GetProviderByUkprn_WhenCpdsResponseIsValid_ShouldNotThrowException()
        {
            // arrange
            CpdsMapper mapper = new CpdsMapper();
            CpdsXmlValidator validator = new CpdsXmlValidator();
            string mockResponse = XDocument.Load("TestData/CpdsResponses/CpdsGetOrganisationByUkprnResponse.xml").ToString();

            var mockCpdsGatewayService = new Mock<GatewayServiceContract>();
            mockCpdsGatewayService.Setup(m => m.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse(mockResponse));

            Exception unexpectedException = null;
            CpdsOrganisationRetriever retriever = new CpdsOrganisationRetriever(Mock.Of<ILogger>(), mockCpdsGatewayService.Object, mapper, validator);
            
            // act
            try
            {
                retriever.GetProviderByUkprn(12345678);
            }
            catch (Exception innerException)
            {
                unexpectedException = innerException;
            }
            
            // assert
            Assert.IsNull(unexpectedException, $"Exception was thrown unexpectedly - {unexpectedException}");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CpdsOrganisationRetriever_WhenDuplicateProvidersWithNumericUpinsExistInCpds_AndNoneOfThemAreActive_ShouldReturnNoProviders()
        {
            // arrange
            string rawCpdsResponseXml = TestResource.AsString(
                "OrganisationDomain.Implementation.Tests.BusinessLogic", "Resources.GetProvidersByUKPRN - 99990002.xml");

            Mock<GatewayServiceContract> gatewayMock = new Mock<GatewayServiceContract>();
            gatewayMock
                .Setup(m => m.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponseXml });

            CpdsOrganisationRetriever cpdsOrganisationRetriever = new CpdsOrganisationRetriever(
                Mock.Of<ILogger>(),
                gatewayMock.Object,
                new CpdsMapper(),
                new CpdsXmlValidator());

            // act
            XDocument provider = cpdsOrganisationRetriever.GetProviderByUkprn(99990002);

            // assert
            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
            Assert.IsNull(provider?.Root?.Elements(ns + "Provider").FirstOrDefault(), "Unexpected providers were returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CpdsOrganisationRetriever_WhenDuplicateProvidersWithNonNumericUpinsExistInCpds_AndAllOfThemAreActive_ShouldReturnNoProviders()
        {
            // arrange
            string rawCpdsResponseXml = TestResource.AsString(
                "OrganisationDomain.Implementation.Tests.BusinessLogic", "Resources.GetProvidersByUKPRN - 99990005.xml");

            Mock<GatewayServiceContract> gatewayMock = new Mock<GatewayServiceContract>();
            gatewayMock
                .Setup(m => m.GetProvidersByUKPRN(It.IsAny<GProvByUKPRINRequest>()))
                .Returns(new GProvByUKPRNResponse { RawCPDSResponse = rawCpdsResponseXml });

            CpdsOrganisationRetriever cpdsOrganisationRetriever = new CpdsOrganisationRetriever(
                Mock.Of<ILogger>(),
                gatewayMock.Object,
                new CpdsMapper(),
                new CpdsXmlValidator());

            // act
            XDocument provider = cpdsOrganisationRetriever.GetProviderByUkprn(99990005);

            // assert
            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
            Assert.IsNull(provider?.Root?.Elements(ns + "Provider").FirstOrDefault(), "Unexpected providers were returned");
        }
    }
}
