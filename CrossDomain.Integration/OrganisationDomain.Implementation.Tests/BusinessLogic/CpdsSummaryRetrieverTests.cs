using System;
using System.Text;
using System.Collections.Generic;
using System.ServiceModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using OrganisationDomain.Implementation.BusinessLogic;
using OrganisationDomain.Implementation.Converters;
using OrganisationDomain.Implementation.DataObjects;
using OrganisationDomain.Integration.Entities;

namespace OrganisationDomain.Implementation.Tests.BusinessLogic
{
    using System.Xml.Linq;
    using NServiceBus.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class CpdsSummaryRetrieverTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public void RetrieveSummary_Should_RetreiveTheSummaryXmlFromCpds()
        {
            var serviceClientMock = new Mock<GatewayServiceContract>();
            serviceClientMock.As<ICommunicationObject>();
            serviceClientMock.As<IDisposable>();
            serviceClientMock.Setup(x => x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()))
                .Returns(new GProvByNameResponse
                {
                    RawCPDSResponse = "<provider></provider>"
                });

            var converterMock = new Mock<ICpdsProviderConverter>();

            var retriever = new CpdsSummaryRetriever(serviceClientMock.Object, converterMock.Object, Mock.Of<ILogger>());
          
            retriever.RetrieveSummary();

            serviceClientMock.Verify(
                x=>x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()),
                Times.Once(),
                "RetrieveSummary didn't call the GetProviderSummaryByName");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(CommunicationException))]
        public void RetrieveSummary_ShouldAbortTheServiceClient_WhenAnExceptionIsThrown()
        {
            var serviceClientMock = new Mock<GatewayServiceContract>();
            serviceClientMock.As<ICommunicationObject>();
            serviceClientMock.As<IDisposable>();
 
            serviceClientMock.Setup(x => x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()))
                .Throws(new CommunicationException("Test Exception"));

            var converterMock = new Mock<ICpdsProviderConverter>();

            var retriever = new CpdsSummaryRetriever(serviceClientMock.Object, converterMock.Object, Mock.Of<ILogger>());

            retriever.RetrieveSummary();

            serviceClientMock.As<ICommunicationObject>().Verify(
                x => x.Abort(),
                Times.Once(),
                "RetrieveSummary didn't call the Service Client Close");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(CommunicationException))]
        public void RetrieveSummary_WhenAnExceptionIsThrown_ShouldRethrowException()
        {
            var serviceClientMock = new Mock<GatewayServiceContract>();
            serviceClientMock.As<ICommunicationObject>();
            serviceClientMock.As<IDisposable>();

            var loggerMock = new Mock<ILog>();

            Func<GatewayServiceContract> factory = () => serviceClientMock.Object;

            serviceClientMock.Setup(x => x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()))
                .Throws(new CommunicationException("Test Exception"));

            var converterMock = new Mock<ICpdsProviderConverter>();

            var retriever = new CpdsSummaryRetriever(serviceClientMock.Object, converterMock.Object, Mock.Of<ILogger>());

            var message = string.Empty;

            retriever.RetrieveSummary();

            Assert.AreEqual("Test Exception", message, "The exception wasn't rethrown.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RetrieveSummary_ShouldCallConvertXmlToProvidersWithRawResponseFromCPDS()
        {
            var serviceClientMock = new Mock<GatewayServiceContract>();
            serviceClientMock.As<ICommunicationObject>();
            serviceClientMock.As<IDisposable>();

            Func<GatewayServiceContract> factory = () => serviceClientMock.Object;

            var testResp = new GProvByNameResponse {RawCPDSResponse = "TestResp"};
            serviceClientMock.Setup(x => x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()))
                .Returns(testResp);

            var converterMock = new Mock<ICpdsProviderConverter>();

            var retriever = new CpdsSummaryRetriever(serviceClientMock.Object, converterMock.Object, Mock.Of<ILogger>());

            retriever.RetrieveSummary();

            converterMock.VerifySet(x => x.CpdsXml = "TestResp", Times.Once(), "RetrieveSummary didn't set the CpdsXml");

            converterMock.Verify(
                x => x.ConvertXmlToProviders(),
                Times.Once(),
                "RetrieveSummary didn't call the ConvertXmlToProviders");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RetrieveSummary_ShouldReturnTheConvertedResponse()
        {
            var serviceClientMock = new Mock<GatewayServiceContract>();
            serviceClientMock.As<ICommunicationObject>();
            serviceClientMock.As<IDisposable>();

            var testResp = new GProvByNameResponse { RawCPDSResponse = "TestResp" };
            serviceClientMock.Setup(x => x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()))
                .Returns(testResp);

            var converterMock = new Mock<ICpdsProviderConverter>();
            var providers = new List<ProviderSequence>
            {
                new ProviderSequence
                {
                     Ukprn=11111,
                     SequenceNumber=11111
                }
            };
            converterMock.Setup(x => x.ConvertXmlToProviders()).Returns(providers);

            var retriever = new CpdsSummaryRetriever(serviceClientMock.Object, converterMock.Object, Mock.Of<ILogger>());
            
            var providerSummary = retriever.RetrieveSummary();

            Assert.IsTrue(providerSummary[0].Ukprn == 11111 && providerSummary[0].SequenceNumber == 11111, "RetrieveSummary didn't return the correct providers");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(CommunicationException))]
        public void RetrieveSummary_WhenCallToCpdsFails_ShouldLogError()
        {
            // Arrange
            var serviceClientMock = new Mock<GatewayServiceContract>();
            serviceClientMock.As<ICommunicationObject>();
            serviceClientMock.As<IDisposable>();

            var loggerMock = new Mock<ILog>();

            Func<GatewayServiceContract> factory = () => serviceClientMock.Object;

            var e = new CommunicationException();
            serviceClientMock.Setup(x => x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()))
                .Throws(e);

            var converterMock = new Mock<ICpdsProviderConverter>();

            var retriever = new CpdsSummaryRetriever(serviceClientMock.Object, converterMock.Object, Mock.Of<ILogger>());

            // Act
            retriever.RetrieveSummary();

            // Assert
            loggerMock.Verify(x => x.Error(It.Is<String>(y => y.Contains("CPDS has failed")), e));
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(Exception))]
        public void RetrieveSummary_WhenProcessResponseFails_ShouldLogError()
        {
            // Arrange
            var serviceClientMock = new Mock<GatewayServiceContract>();
            serviceClientMock.As<ICommunicationObject>();
            serviceClientMock.As<IDisposable>();

            var loggerMock = new Mock<ILog>();

            Func<GatewayServiceContract> factory = () => serviceClientMock.Object;

            const string rawCpdsResponse = "<organisation/>";
            serviceClientMock.Setup(x => x.GetProviderSummaryByName(It.IsAny<GProvByNameRequest>()))
                .Returns(new GProvByNameResponse { RawCPDSResponse = rawCpdsResponse });

            var e = new Exception();

            var converterMock = new Mock<ICpdsProviderConverter>();
            converterMock.Setup(x => x.ConvertXmlToProviders())
                .Throws(e);

            var retriever = new CpdsSummaryRetriever(serviceClientMock.Object, converterMock.Object, Mock.Of<ILogger>());

            // Act
            retriever.RetrieveSummary();

            // Assert
            loggerMock.Verify(x => x.Error(It.Is<String>(y => y.Contains("Error trying to process")), e));
        }
    }
}
