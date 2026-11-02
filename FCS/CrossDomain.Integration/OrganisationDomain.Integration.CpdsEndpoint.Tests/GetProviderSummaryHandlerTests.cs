namespace OrganisationDomain.Integration.CpdsEndpoint.Tests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Entities;
    using Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus.Testing;
    using System.Linq;

    [TestClass]
    public class GetProviderSummaryHandlerTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public void Handle_ShouldRetreiveSummaryFromCpds()
        {
            // Arrange 
            var converterMock = new Mock<ICpdsProviderConverter>();
            var blob = new byte[0];
            converterMock.Setup(x => x.ConvertProviderSequenceListToBlob(
                It.IsAny<List<ProviderSequence>>())).Returns(blob);
            
            var retrieverMock = new Mock<ICpdsSummaryRetriever>();
            retrieverMock.Setup(x => x.RetrieveSummary()).Returns(new List<ProviderSequence>());

            var handler = new GetProviderSummaryHandler(Mock.Of<ILogger>(), retrieverMock.Object, converterMock.Object);
            
            var message = new GetProviderSummary()
                { ProcessId="1"};

            // Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            // Assert
            retrieverMock.Verify(x => x.RetrieveSummary(), Times.Once(), "Handle didn't call RetrieveSummary");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ShouldSendTheProcessProviderSummaryCommand()
        {
            // Arrange
            var converterMock = new Mock<ICpdsProviderConverter>();
            var blob = new byte[0];
            converterMock.Setup(x => x.ConvertProviderSequenceListToBlob(
                It.IsAny<List<ProviderSequence>>())).Returns(blob);
            
            var retrieverMock = new Mock<ICpdsSummaryRetriever>();
            var sequence = new List<ProviderSequence>();
            retrieverMock.Setup(x => x.RetrieveSummary()).Returns(sequence);
          
            var handler = new GetProviderSummaryHandler(Mock.Of<ILogger>(), retrieverMock.Object, converterMock.Object);
            var message = new GetProviderSummary() { ProcessId = "1" };

            var context = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, context).Wait();

            // Assert
            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message is ProcessProviderSummary),
                $"Unexpected number of ProcessProviderSummary messages sent");

            var assertMessage = (ProcessProviderSummary) context.SentMessages[0].Message;
            Assert.AreEqual(blob, assertMessage.ProviderSummaryDatabus, "Incorrect ProcessProviderSummary message sent");
        }
    }
}
