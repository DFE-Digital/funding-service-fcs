namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using DataStore.Repositories;
    using Extensions;
    using Handlers;
    using Implementation.Services;
    using Messages.Commands;
    using Messages.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using Address = DataStore.Model.Address;

    [TestClass]
    public class UpdateSupplementaryBatchOfDataCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryBatchOfDataCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueNotificationForAllValues()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            const string line1Diff = "line1Diff";

            var organisationAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddress = new OrgSupplementaryAddressDto
                { Line1 = line1Diff, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", TradingName = "TRADINGNAME-1", Address = organisationAddress },
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", TradingName = "TRADINGNAME-2", Address = organisationAddress }
                }.ToList());

            IOrgSupplementaryChangeService orgSupplementaryChangeService =
                new OrgSupplementaryChangeService(logger, orgRepositoryMock.Object);

            UpdateSupplementaryBatchOfDataCommandHandler handler =
                new UpdateSupplementaryBatchOfDataCommandHandler(new LoggerNullObject(), orgSupplementaryChangeService);

            const string expectedCompanyNumberNotificationMessageForUkprn1 = "Company Number has been updated for provider 1 (TRADINGNAME-1)";
            const string expectedCharityNumberNotificationMessageForUkprn1 = "Charity Number has been updated for provider 1 (TRADINGNAME-1)";
            const string expectedAddressNotificationMessageForUkprn1 = "Address has been updated for provider 1 (TRADINGNAME-1)";

            const string expectedCompanyNumberNotificationMessageForUkprn2 = "Company Number has been updated for provider 2 (TRADINGNAME-2)";
            const string expectedCharityNumberNotificationMessageForUkprn2 = "Charity Number has been updated for provider 2 (TRADINGNAME-2)";
            const string expectedAddressNotificationMessageForUkprn2 = "Address has been updated for provider 2 (TRADINGNAME-2)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new UpdateSupplementaryBatchOfDataCommand
            {
                OrgSupplementaryDataCollection = new[]
                {
                    new OrgSupplementaryDataDto {Ukprn = 1, CompanyNumber = "Updated", CharityNumber = "Updated", LegalAddress = supplementaryAddress},
                    new OrgSupplementaryDataDto {Ukprn = 2, CompanyNumber = "Updated", CharityNumber = "Updated", LegalAddress = supplementaryAddress}
                }
            }, context).Wait();

            // assert
            Assert.AreEqual(2, context.SentMessages.Count(sm => sm.Message.GetType() == typeof(UpdateXrmOrganisationCommand)),
                "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            Assert.AreEqual(6, context.SentMessages.Count(sm => sm.Message.GetType() == typeof(CreateProviderUpdatedNotificationCommand)),
                "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            var createProviderUpdatedNotificationCommands = context.SentMessages.Select(sm => sm.Message).Where(sm => sm.GetType() == typeof(CreateProviderUpdatedNotificationCommand))
                .Cast<CreateProviderUpdatedNotificationCommand>().ToList();

            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && c.Ukprn == 1),
            "The notification message for Ukprn 1 Company number is incorrect");
            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedCharityNumberNotificationMessageForUkprn1 && c.Ukprn == 1),
                "The notification message for Ukprn 1 Charity number is incorrect");
            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedAddressNotificationMessageForUkprn1 && c.Ukprn == 1),
                "The notification message for Ukprn 1 Address is incorrect");
            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && c.Ukprn == 2),
                "The notification message for Ukprn 2 Company number is incorrect");

            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedCharityNumberNotificationMessageForUkprn2 && c.Ukprn == 2),
                "The notification message for Ukprn 2 Charity number is incorrect");

            Assert.AreEqual(1, createProviderUpdatedNotificationCommands.Count(c => c.Notification == expectedAddressNotificationMessageForUkprn2 && c.Ukprn == 2),
                "The notification message for Ukprn 2 Address is incorrect");

            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Exactly(2),
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Exactly(6),
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1)),
            //    Times.Once(), "The notification message for Ukprn 1 Company number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1)),
            //    Times.Once(), "The notification message for Ukprn 1 Charity number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //        cmd => cmd.Notification == expectedAddressNotificationMessageForUkprn1 && cmd.Ukprn == 1)),
            //    Times.Once(), "The notification message for Ukprn 1 Address is incorrect");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Company number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Charity number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //        cmd => cmd.Notification == expectedAddressNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Address is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryBatchOfDataCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueOnlyOneCompanyNumberNotification()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            var organisationAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddress = new OrgSupplementaryAddressDto
            { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", TradingName = "TRADINGNAME-1", Address = organisationAddress },
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", TradingName = "TRADINGNAME-2", Address = organisationAddress },
                }.ToList());

            IOrgSupplementaryChangeService orgSupplementaryChangeService =
                new OrgSupplementaryChangeService(logger, orgRepositoryMock.Object);

            UpdateSupplementaryBatchOfDataCommandHandler handler =
                new UpdateSupplementaryBatchOfDataCommandHandler(new LoggerNullObject(), orgSupplementaryChangeService);

            const string expectedCompanyNumberNotificationMessage = "Company Number has been updated for provider 1 (TRADINGNAME-1)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new UpdateSupplementaryBatchOfDataCommand
            {
                OrgSupplementaryDataCollection = new[]
                {
                    new OrgSupplementaryDataDto {Ukprn = 1, CompanyNumber = "Updated", CharityNumber = "CHARITYNO1", LegalAddress = supplementaryAddress},
                    new OrgSupplementaryDataDto {Ukprn = 2, CompanyNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", LegalAddress = supplementaryAddress}
                }
            }, context).Wait();

            // assert
            var updateXrmCommands =
                context.SentMessages.Select(sm => sm.Message).CastWhere<UpdateXrmOrganisationCommand>();
            Assert.AreEqual(1, updateXrmCommands.Count(), "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Once,
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            var notificationCommands =
                context.SentMessages.Select(sm => sm.Message).CastWhere<CreateProviderUpdatedNotificationCommand>().ToList();
            Assert.AreEqual(1, notificationCommands.Count(), "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Once,
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");

            Assert.AreEqual(1, notificationCommands.Count(nc => nc.Notification == expectedCompanyNumberNotificationMessage &&
                                                                nc.Ukprn == 1), "The notification message was incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>
            //    (message => message.Notification == expectedCompanyNumberNotificationMessage && message.Ukprn == 1)),
            //    Times.Once(), "The notification message was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryBatchOfDataCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueOnlyOneCharityNumberNotification()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            var organisationAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddress = new OrgSupplementaryAddressDto
            { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", TradingName = "TRADINGNAME-1", Address = organisationAddress },
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", TradingName = "TRADINGNAME-2", Address = organisationAddress },
                }.ToList());

            IOrgSupplementaryChangeService orgSupplementaryChangeService =
                new OrgSupplementaryChangeService(logger, orgRepositoryMock.Object);

            UpdateSupplementaryBatchOfDataCommandHandler handler =
                new UpdateSupplementaryBatchOfDataCommandHandler(new LoggerNullObject(), orgSupplementaryChangeService);

            const string expectedCharityNumberNotificationMessage = "Charity Number has been updated for provider 2 (TRADINGNAME-2)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new UpdateSupplementaryBatchOfDataCommand
            {
                OrgSupplementaryDataCollection = new[]
                {
                    new OrgSupplementaryDataDto {Ukprn = 1, CompanyNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", LegalAddress = supplementaryAddress},
                    new OrgSupplementaryDataDto {Ukprn = 2, CompanyNumber = "COMPANY-2", CharityNumber = "Updated", LegalAddress = supplementaryAddress}
                }
            }, context).Wait();

            // assert
            int numXrmCommands = context.SentMessages.Select(sm => sm.Message).CastWhere<UpdateXrmOrganisationCommand>()
                .Count();
            Assert.AreEqual(1, numXrmCommands, "UpdateXrmOrganisationCommand wasn't called the expected number of times");

            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Once,
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            var notificationCommands = context.SentMessages.Select(sm => sm.Message).CastWhere<CreateProviderUpdatedNotificationCommand>()
                .ToList();
            Assert.AreEqual(1, notificationCommands.Count, "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Once,
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            Assert.AreEqual(1, notificationCommands.Count(nc => nc.Notification == expectedCharityNumberNotificationMessage &&
                                                                nc.Ukprn == 2), "The notification message for Ukprn 2 Charity number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>
            //    (message => message.Notification == expectedCharityNumberNotificationMessage && message.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Charity number is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryBatchOfDataCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueOnlyOneAddressNotification()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            const string line1Diff = "line1Diff";

            var organisationAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddressSame = new OrgSupplementaryAddressDto
                { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddressDifferent = new OrgSupplementaryAddressDto
                { Line1 = line1Diff, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", TradingName = "TRADINGNAME-1", Address = organisationAddress },
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", TradingName = "TRADINGNAME-2", Address = organisationAddress },
                }.ToList());

            IOrgSupplementaryChangeService orgSupplementaryChangeService =
                new OrgSupplementaryChangeService(logger, orgRepositoryMock.Object);

            UpdateSupplementaryBatchOfDataCommandHandler handler =
                new UpdateSupplementaryBatchOfDataCommandHandler(new LoggerNullObject(), orgSupplementaryChangeService);

            const string expectedAddressNotificationMessage = "Address has been updated for provider 2 (TRADINGNAME-2)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new UpdateSupplementaryBatchOfDataCommand
            {
                OrgSupplementaryDataCollection = new[]
                {
                    new OrgSupplementaryDataDto {Ukprn = 1, CompanyNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", LegalAddress = supplementaryAddressSame},
                    new OrgSupplementaryDataDto {Ukprn = 2, CompanyNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", LegalAddress = supplementaryAddressDifferent}
                }
            }, context).Wait();

            // assert
            int numXrmCommands = context.SentMessages.Select(sm => sm.Message).CastWhere<UpdateXrmOrganisationCommand>()
                .Count();
            Assert.AreEqual(1, numXrmCommands, "UpdateXrmOrganisationCommand wasn't called the expected number of times");

            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Once,
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            var notificationCommands = context.SentMessages.Select(sm => sm.Message).CastWhere<CreateProviderUpdatedNotificationCommand>()
                .ToList();
            Assert.AreEqual(1, notificationCommands.Count, "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Once,
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");

            Assert.AreEqual(1, notificationCommands.Count(nc => nc.Notification == expectedAddressNotificationMessage &&
                                                                nc.Ukprn == 2), "The notification message for Ukprn 2 Charity number is incorrect");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>
            //    (message => message.Notification == expectedAddressNotificationMessage && message.Ukprn ==2)),
            //    Times.Once(), "The notification message for Ukprn 2 Address is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryBatchOfDataCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldNotIssueAnyNotifications()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            var organisationAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddress = new OrgSupplementaryAddressDto
            { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1, CompanyRegistrationNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", Address = organisationAddress },
                    new Organisation {Ukprn = 2, CompanyRegistrationNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", Address = organisationAddress }
                }.ToList());

            IOrgSupplementaryChangeService orgSupplementaryChangeService =
                new OrgSupplementaryChangeService(logger, orgRepositoryMock.Object);

            UpdateSupplementaryBatchOfDataCommandHandler handler =
                new UpdateSupplementaryBatchOfDataCommandHandler(new LoggerNullObject(), orgSupplementaryChangeService);
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new UpdateSupplementaryBatchOfDataCommand
            {
                OrgSupplementaryDataCollection = new[]
                {
                    new OrgSupplementaryDataDto {Ukprn = 1, CompanyNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", LegalAddress = supplementaryAddress},
                    new OrgSupplementaryDataDto {Ukprn = 2, CompanyNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", LegalAddress = supplementaryAddress}
                }
            }, context).Wait();

            // assert
            int numXrmCommands = context.SentMessages.Select(sm => sm.Message).CastWhere<UpdateXrmOrganisationCommand>()
                .Count();
            Assert.AreEqual(0, numXrmCommands, "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            int notificationCommands = context.SentMessages.Select(sm => sm.Message).CastWhere<CreateProviderUpdatedNotificationCommand>()
                .Count();
            Assert.AreEqual(0, notificationCommands, "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");

            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Never,
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Never,
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryBatchOfDataCommandHandler_CreateProviderUpdatedNotificationCommand_ShouldIssueAMixOfNotificationTypesAcrossOrganisations()
        {
            // arrange
            ILogger logger = new LoggerNullObject();
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            const string line1Diff = "line1Diff";

            var organisationAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddressSame = new OrgSupplementaryAddressDto
            { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            OrgSupplementaryAddressDto supplementaryAddressDifferent = new OrgSupplementaryAddressDto
                { Line1 = line1Diff, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation { Ukprn = 1, CompanyRegistrationNumber = "COMPANY-1", CharityNumber = "CHARITYNO1", TradingName = "TRADINGNAME-1", Address = organisationAddress },
                    new Organisation { Ukprn = 2, CompanyRegistrationNumber = "COMPANY-2", CharityNumber = "CHARITYNO2", TradingName = "TRADINGNAME-2", Address = organisationAddress },
                    new Organisation { Ukprn = 3, CompanyRegistrationNumber = "COMPANY-3", CharityNumber = "CHARITYNO3", TradingName = "TRADINGNAME-3", Address = organisationAddress },
                    new Organisation { Ukprn = 4, CompanyRegistrationNumber = "COMPANY-4", CharityNumber = "CHARITYNO4", TradingName = "TRADINGNAME-4", Address = organisationAddress },
                    new Organisation { Ukprn = 5, CompanyRegistrationNumber = "COMPANY-5", CharityNumber = "CHARITYNO5", TradingName = "TRADINGNAME-5", Address = organisationAddress },
                    new Organisation { Ukprn = 6, CompanyRegistrationNumber = "COMPANY-6", CharityNumber = "CHARITYNO6", TradingName = "TRADINGNAME-6", Address = organisationAddress }
                }.ToList());

            IOrgSupplementaryChangeService orgSupplementaryChangeService =
                new OrgSupplementaryChangeService(logger, orgRepositoryMock.Object);

            UpdateSupplementaryBatchOfDataCommandHandler handler =
                new UpdateSupplementaryBatchOfDataCommandHandler(new LoggerNullObject(), orgSupplementaryChangeService);

            const string expectedCompanyNumberNotificationMessageForUkprn1 = "Company Number has been updated for provider 1 (TRADINGNAME-1)";

            const string expectedCompanyNumberNotificationMessageForUkprn2 = "Company Number has been updated for provider 2 (TRADINGNAME-2)";
            const string expectedCharityNumberNotificationMessageForUkprn2 = "Charity Number has been updated for provider 2 (TRADINGNAME-2)";

            const string expectedCompanyNumberNotificationMessageForUkprn5 = "Company Number has been updated for provider 5 (TRADINGNAME-5)";
            const string expectedAddressNotificationMessageForUkprn5 = "Address has been updated for provider 5 (TRADINGNAME-5)";
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new UpdateSupplementaryBatchOfDataCommand
            {
                OrgSupplementaryDataCollection = new[]
                {
                    new OrgSupplementaryDataDto {Ukprn = 1, CompanyNumber = "updated", CharityNumber = "CHARITYNO1", LegalAddress = supplementaryAddressSame},
                    new OrgSupplementaryDataDto {Ukprn = 2, CompanyNumber = "updated", CharityNumber = "updated", LegalAddress = supplementaryAddressSame},
                    new OrgSupplementaryDataDto {Ukprn = 5, CompanyNumber = "updated", CharityNumber = "CHARITYNO5", LegalAddress = supplementaryAddressDifferent},
                    new OrgSupplementaryDataDto {Ukprn = 6, CompanyNumber = "COMPANY-6", CharityNumber = "CHARITYNO6", LegalAddress = supplementaryAddressSame}
                }
            }, context).Wait();

            // assert
            Assert.AreEqual(3, context.SentMessages.Count<UpdateXrmOrganisationCommand>(),
                "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<UpdateXrmOrganisationCommand>()), Times.Exactly(3),
            //    "UpdateXrmOrganisationCommand wasn't called the expected number of times");
            Assert.AreEqual(5, context.SentMessages.Count<CreateProviderUpdatedNotificationCommand>(),
                "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");
            //busMock.Verify(m => m.Send(It.IsAny<CreateProviderUpdatedNotificationCommand>()), Times.Exactly(5),
            //    "CreateProviderUpdatedNotificationCommand wasn't called the expected number of times");

            Assert.AreEqual(1, context.SentMessages.Count<CreateProviderUpdatedNotificationCommand>(cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1),
                "The notification message for Ukprn 1 Company number is incorrect");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn1 && cmd.Ukprn == 1)),
            //    Times.Once(), "The notification message for Ukprn 1 Company number is incorrect");
            Assert.AreEqual(1, context.SentMessages.Count<CreateProviderUpdatedNotificationCommand>(
                    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2),
                "The notification message for Ukprn 1 Company number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Company number is incorrect");
            Assert.AreEqual(1, context.SentMessages.Count<CreateProviderUpdatedNotificationCommand>(
                    cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2),
                "The notification message for Ukprn 2 Charity number is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCharityNumberNotificationMessageForUkprn2 && cmd.Ukprn == 2)),
            //    Times.Once(), "The notification message for Ukprn 2 Charity number is incorrect");
            Assert.AreEqual(1, context.SentMessages.Count<CreateProviderUpdatedNotificationCommand>(
                    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn5 && cmd.Ukprn == 5),
                "The notification message for Ukprn 5 Company number is incorrect");

            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //    cmd => cmd.Notification == expectedCompanyNumberNotificationMessageForUkprn5 && cmd.Ukprn == 5)),
            //    Times.Once(), "The notification message for Ukprn 5 Company number is incorrect");
            Assert.AreEqual(1, context.SentMessages.Count<CreateProviderUpdatedNotificationCommand>(
                    cmd => cmd.Notification == expectedAddressNotificationMessageForUkprn5 && cmd.Ukprn == 5),
                "The notification message for Ukprn 5 Address is incorrect");
            //busMock.Verify(x => x.Send(It.Is<CreateProviderUpdatedNotificationCommand>(
            //        cmd => cmd.Notification == expectedAddressNotificationMessageForUkprn5 && cmd.Ukprn == 5)),
            //    Times.Once(), "The notification message for Ukprn 5 Address is incorrect");
        }
    }
}
