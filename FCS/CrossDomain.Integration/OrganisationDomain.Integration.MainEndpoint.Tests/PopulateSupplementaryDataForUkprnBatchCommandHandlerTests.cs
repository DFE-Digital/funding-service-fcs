namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using DataStore.Repositories;
    using Handlers;
    using Implementation.Services;
    using Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;

    [TestClass]
    public class PopulateSupplementaryDataForUkprnBatchCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task PopulateSupplementaryDataForUkprnBatchCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueNotificationForAllValues()
        {
            // arrange
            ILogger logger = new LoggerNullObject();

            Mock<IOrgSupplementaryDataService> orgSupplementaryDataSvcMock = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult("CRN", "CN", true));

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-1"},
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-2"}
                }.ToList());

            IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                new OrgSupplementaryPopulationService(logger, orgSupplementaryDataSvcMock.Object,
                    orgRepositoryMock.Object);

            PopulateSupplementaryDataForUkprnBatchCommandHandler handler =
                new PopulateSupplementaryDataForUkprnBatchCommandHandler(new LoggerNullObject(), orgSupplementaryPopulationService);

            const string expectedCompanyNumberNotificationMessageForUkprn1 = "Company Number has been updated for provider 1 (TRADINGNAME-1)";
            const string expectedCharityNumberNotificationMessageForUkprn1 = "Charity Number has been updated for provider 1 (TRADINGNAME-1)";

            const string expectedCompanyNumberNotificationMessageForUkprn2 = "Company Number has been updated for provider 2 (TRADINGNAME-2)";
            const string expectedCharityNumberNotificationMessageForUkprn2 = "Charity Number has been updated for provider 2 (TRADINGNAME-2)";

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            handler.Handle(new PopulateSupplementaryDataForUkprnBatchCommand { ShouldIssueCrmNotifications = true, UkprnBatch = new List<int> { 1, 2 } }, context).Wait();

            // assert
            Assert.AreEqual(2, context.SentMessages.Count(o => o.Message.GetType() == typeof(UpdateXrmOrganisationCommand)),
                "UpdateXrmOrganisationCommand wasn't sent the expected number of times");
            Assert.AreEqual(4, context.SentMessages.Count(o => o.Message.GetType() == typeof(CreateProviderUpdatedNotificationCommand)),
                "CreateProviderUpdatedNotificationCommand wasn't sent the expected number of times");
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).Where(o => o.GetType() == typeof(CreateProviderUpdatedNotificationCommand))
                    .Cast<CreateProviderUpdatedNotificationCommand>()
                    .Count(cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1),
                "The notification message for Ukprn 1 Company number is incorrect");
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).Where(o => o.GetType() == typeof(CreateProviderUpdatedNotificationCommand))
                    .Cast<CreateProviderUpdatedNotificationCommand>()
                    .Count(cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2),
                "The notification message for Ukprn 2 Company number is incorrect");
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).Where(o => o.GetType() == typeof(CreateProviderUpdatedNotificationCommand))
                    .Cast<CreateProviderUpdatedNotificationCommand>()
                    .Count(cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2),
                "The notification message for Ukprn 2 Company number is incorrect");

            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Exactly(2),
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Exactly(4),
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1)),
            //    Times.Once(), "The notification message for Ukprn 1 Company number is incorrect1");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1)),
            //    Times.Once(), "The notification message for Ukprn 1 Charity number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Company number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Charity number is incorrect");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void PopulateSupplementaryDataForUkprnBatchCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueOnlyOneCompanyNumberNotification()
        {
            // arrange
            ILogger logger = new LoggerNullObject();

            Mock<IOrgSupplementaryDataService> orgSupplementaryDataSvcMock = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult("COMPANY-1", null, true));

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-1"}
                }.ToList());

            IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                new OrgSupplementaryPopulationService(logger, orgSupplementaryDataSvcMock.Object,
                    orgRepositoryMock.Object);

            PopulateSupplementaryDataForUkprnBatchCommandHandler handler =
                new PopulateSupplementaryDataForUkprnBatchCommandHandler(new LoggerNullObject(), orgSupplementaryPopulationService);

            const string expectedCompanyNumberNotificationMessage = "Company Number has been updated for provider 1 (TRADINGNAME-1)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new PopulateSupplementaryDataForUkprnBatchCommand { ShouldIssueCrmNotifications = true, UkprnBatch = new List<int> { 1 } }, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Count(o => o.Message.GetType() == typeof(UpdateXrmOrganisationCommand)),
                "UpdateXrmOrganisationCommand wasn't sent the expected number of times");

            Assert.AreEqual(1, context.SentMessages.Count(o => o.Message.GetType() == typeof(CreateProviderUpdatedNotificationCommand)),
                "CreateProviderUpdatedNotificationCommand wasn't sent the expected number of times");
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).Where(o => o.GetType() == typeof(CreateProviderUpdatedNotificationCommand))
                    .Cast<CreateProviderUpdatedNotificationCommand>()
                    .Count(cmd => cmd.Notification == expectedCompanyNumberNotificationMessage && cmd.Ukprn == 1),
                "The notification message was incorrect");
            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Once,
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Once,
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>
            //    (message => message.Notification == expectedCompanyNumberNotificationMessage && message.Ukprn == 1)),
            //    Times.Once(), "The notification message was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PopulateSupplementaryDataForUkprnBatchCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueOnlyOneCharityNumberNotification()
        {
            // arrange
            ILogger logger = new LoggerNullObject();

            Mock<IOrgSupplementaryDataService> orgSupplementaryDataSvcMock = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(null, "CHARITYNO2", true));

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-2"}
                }.ToList());

            IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                new OrgSupplementaryPopulationService(logger, orgSupplementaryDataSvcMock.Object,
                    orgRepositoryMock.Object);

            PopulateSupplementaryDataForUkprnBatchCommandHandler handler =
                new PopulateSupplementaryDataForUkprnBatchCommandHandler(new LoggerNullObject(), orgSupplementaryPopulationService);

            const string expectedCharityNumberNotificationMessage = "Charity Number has been updated for provider 2 (TRADINGNAME-2)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            handler.Handle(new PopulateSupplementaryDataForUkprnBatchCommand { ShouldIssueCrmNotifications = true, UkprnBatch = new List<int> { 2 } }, context).Wait();
   
            // assert
            Assert.AreEqual(1, context.SentMessages.Count(sm => sm.Message.GetType() == typeof(UpdateXrmOrganisationCommand)),
                "UpdateXrmOrganisationCommand wasn't sent the expected number of times");
            Assert.AreEqual(1, context.SentMessages.Count(sm => sm.Message.GetType() == typeof(CreateProviderUpdatedNotificationCommand)),
                "CreateProviderUpdatedNotificationCommand wasn't sent the expected number of times");
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).Where(sm => sm.GetType() == typeof(CreateProviderUpdatedNotificationCommand))
                .Cast<CreateProviderUpdatedNotificationCommand>().Count(m => m.Notification == expectedCharityNumberNotificationMessage &&
                                                                             m.Ukprn == 2),
                "The notification message for Ukprn 2 Charity number is incorrect");

            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Once,
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Once,
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>
            //    (message => message.Notification == expectedCharityNumberNotificationMessage && message.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Charity number is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PopulateSupplementaryDataForUkprnBatchCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldNotIssueAnyNotifications()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            Mock<IOrgSupplementaryDataService> orgSupplementaryDataSvcMock = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult("CRN", "CN", true));

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns((IReadOnlyCollection<int> ukprns) => new List<Organisation> {new Organisation {Ukprn = ukprns.First()}});

            IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                new OrgSupplementaryPopulationService(logger, orgSupplementaryDataSvcMock.Object,
                    orgRepositoryMock.Object);

            PopulateSupplementaryDataForUkprnBatchCommandHandler handler =
                new PopulateSupplementaryDataForUkprnBatchCommandHandler(new LoggerNullObject(), orgSupplementaryPopulationService);
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new PopulateSupplementaryDataForUkprnBatchCommand { ShouldIssueCrmNotifications = false, UkprnBatch = new List<int> { 12345678 }}, context).Wait();

            // assert - should execute action to only send UpdateXrmOrganisationCommand
            Assert.AreEqual(1, context.SentMessages.Count(sm => sm.Message.GetType() == typeof(UpdateXrmOrganisationCommand)), "number of UpdateXrmOrganisationCommands incorrect");
            Assert.AreEqual(0, context.SentMessages.Count(sm => sm.Message.GetType() == typeof(CreateProviderUpdatedNotificationCommand)), "number of CreateProviderUpdatedNotificationCommand incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryBatchOfDataCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueAMixOfNotificationTypesAcrossOrganisations()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            
            Mock<IOrgSupplementaryDataService> orgSupplementaryDataSvcMock = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.Is<int>(ukprn => ukprn == 1)))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult("COMPANY-1", null, true));
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.Is<int>(ukprn => ukprn == 2)))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult("COMPANY-2", "CHARITYNO1", true));
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.Is<int>(ukprn => ukprn == 3)))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(null, null, false));
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.Is<int>(ukprn => ukprn == 4)))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(null, null, false));
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.Is<int>(ukprn => ukprn == 5)))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult("COMPANY-5", null, true));
            orgSupplementaryDataSvcMock.Setup(m => m.GetDataForUkprn(It.Is<int>(ukprn => ukprn == 6)))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(null, null, false));

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-1"},
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-2"},
                    new Organisation {Ukprn = 3, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-3"},
                    new Organisation {Ukprn = 4, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-4"},
                    new Organisation {Ukprn = 5, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-5"},
                    new Organisation {Ukprn = 6, CompanyRegistrationNumber = null, CharityNumber = null, TradingName = "TRADINGNAME-6"}
                }.ToList());

            IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                new OrgSupplementaryPopulationService(logger, orgSupplementaryDataSvcMock.Object,
                    orgRepositoryMock.Object);

            PopulateSupplementaryDataForUkprnBatchCommandHandler handler =
                new PopulateSupplementaryDataForUkprnBatchCommandHandler(new LoggerNullObject(), orgSupplementaryPopulationService);

            const string expectedCompanyNumberNotificationMessageForUkprn1 = "Company Number has been updated for provider 1 (TRADINGNAME-1)";

            const string expectedCompanyNumberNotificationMessageForUkprn2 = "Company Number has been updated for provider 2 (TRADINGNAME-2)";
            const string expectedCharityNumberNotificationMessageForUkprn2 = "Charity Number has been updated for provider 2 (TRADINGNAME-2)";

            const string expectedCompanyNumberNotificationMessageForUkprn5 = "Company Number has been updated for provider 5 (TRADINGNAME-5)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new PopulateSupplementaryDataForUkprnBatchCommand { ShouldIssueCrmNotifications = true, UkprnBatch = new List<int> { 1, 2, 5 } }, context).Wait();

            // assert
            Assert.AreEqual(3, context.SentMessages.Count(sm => sm.Message.GetType() == typeof(UpdateXrmOrganisationCommand)), "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Exactly(3),
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");

            var createProviderUpdatedNotificationCommands = context.SentMessages.Where(sm => sm.Message.GetType() == typeof(CreateProviderUpdatedNotificationCommand))
                .Select(sm => sm.Message).Cast<CreateProviderUpdatedNotificationCommand>();

            Assert.AreEqual(4, createProviderUpdatedNotificationCommands.Count(), "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Exactly(4),
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c=> c.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && c.Ukprn == 1),
                "The notification message for Ukprn 1 Company number is incorrect");
            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && c.Ukprn == 2),
                "The notification message for Ukprn 2 Company number is incorrect");
            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedCharityNumberNotificationMessageForUkprn2 && c.Ukprn == 2),
                "The notification message for Ukprn 2 Charity number is incorrect");
            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedCompanyNumberNotificationMessageForUkprn5 && c.Ukprn == 5),
                "The notification message for Ukprn 5 Company number is incorrect");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1)),
            //    Times.Once(), "The notification message for Ukprn 1 Company number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Company number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Charity number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn5 && cmd.Ukprn == 5)),
            //    Times.Once(), "The notification message for Ukprn 5 Company number is incorrect");
        }
    }
}