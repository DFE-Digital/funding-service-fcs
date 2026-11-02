namespace OrganisationDomain.Integration.DataStoreEndpoint.Tests
{
    using System.Xml.Linq;
    using DataStore;
    using Implementation.BusinessLogic;
    using Implementation.DataAccess;
    using Implementation.Mappers;
    using UnitTests.Common;
    using Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class SaveUpdatedOrganisationHandlerIntegrationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SaveUpdatedOrganisationHandler_ShouldSendCreateProviderUpdatedNotificationCommand()
        {
            // arrange
            var command = GetMessageFromFile();
            Assert.IsNotNull(command);
            XDocument changeProvider = XDocument.Parse(command.ChangedProvider);
            Assert.IsNotNull(changeProvider);
            SaveUpdatedOrganisationHandler handler = new SaveUpdatedOrganisationHandler(new OrganisationRepository
            {
                OrganisationDomainDbContext = new OrganisationDomainDbContext()
            }, new CpdsMapper(), new CpdsXmlValidator());

            handler.Logger = Mock.Of<ILogger>();
                // act
            handler.Handle(new SaveUpdatedOrganisation
            {
                ProcessId = command.ProcessId,
                ChangedProvider = changeProvider
            }, new TestableMessageHandlerContext()).Wait();
            // assert
        }

        private SimpleCommand GetMessageFromFile()
        {
            return TestResource.FromJson<SimpleCommand>("OrganisationDomain.Integration.DataStoreEndpoint.Tests",
                "Resources.SaveUpdatedOrganisation.json");
        }

        private class SimpleCommand
        {
            public string ChangedProvider { get; set; }
            public string ProcessId { get; set; }

        }
    }
}
