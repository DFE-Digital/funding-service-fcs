namespace OrganisationDomain.Integration.DataStoreEndpoint.Tests
{
    using NServiceBus.Testing;
    using System.Linq;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Entities;
    using Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class GetUpdatedOrganisationHandlerTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public void Handle_ShouldCallTheComparerGetChangesWithTheProviderSummary()
        {
            var converterMock = new Mock<ICpdsProviderConverter>();
            var cpdsProviders = new List<ProviderSequence>();
            converterMock.Setup(x => x.ConvertBlobToProviderSequenceList(
                It.IsAny<byte[]>())).Returns(cpdsProviders);
            var comparerMock = new Mock<IProviderComparer>();
            var loggerMock = new Mock<ILogger>();
            var handler = new GetUpdatedOrganisationsHandler()
            {
                Converter = converterMock.Object,
                Comparer = comparerMock.Object,
                Logger = loggerMock.Object
            };

            var message = new GetUpdatedOrganisations()
            {
                ProcessId = "1",
                ProviderSummaryDatabus =  new byte[0]
            };  
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            comparerMock.VerifySet(x => x.CpdsProviders = cpdsProviders,Times.Once(),"Handle didn't set the cpds providers");
            comparerMock.Verify(x => x.GetChanges(), Times.Once(), "Handle didn't call GetChanges");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ShouldSendTheProcessUpdatedOrganisationsCommand()
        {
            var comparerMock = new Mock<IProviderComparer>();
            var converterMock = new Mock<ICpdsProviderConverter>();
            var cpdsProviders = new List<ProviderSequence>();
            converterMock.Setup(x => x.ConvertBlobToProviderSequenceList(
                It.IsAny<byte[]>())).Returns(cpdsProviders);
            var changedList = new List<ProviderSequence>
            {
                new ProviderSequence
                {
                    Ukprn = 1,
                    Upin = 10
                },
                new ProviderSequence
                {
                    Ukprn = 2,
                    Upin = 20
                },
                new ProviderSequence
                {
                    Ukprn = 3,
                    Upin = 30
                }
            };
            comparerMock.Setup(x => x.GetChanges()).Returns(changedList);

            var loggerMock = new Mock<ILogger>();
            var handler = new GetUpdatedOrganisationsHandler()
            {
                Converter = converterMock.Object,
                Comparer = comparerMock.Object,
                Logger = loggerMock.Object
            };

            var message = new GetUpdatedOrganisations()
            {
                ProcessId = "1",
                ProviderSummaryDatabus = new byte[0]
            };

            var context = new TestableMessageHandlerContext();

            handler.Handle(message, context).Wait();

            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message is ProcessUpdatedOrganisations),
                "Unexpected number of ProcessUpdatedOrganisations messages sent");

            var assertMessage = (ProcessUpdatedOrganisations)context.SentMessages[0].Message;
            Assert.AreEqual(changedList, assertMessage.ChangedProviderUkprnList, "Incorrect ProcessProviderSummary message sent");
        }
    }
}
