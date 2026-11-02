namespace OrganisationDomain.Integration.DataStoreEndpoint.Tests
{
    using System;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Implementation.DataAccess;
    using Implementation.Mappers;
    using DataStore.Model;
    using Messages.Commands;
    using System.Collections.Generic;
    using Implementation.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using NServiceBus.Testing;
    using System.Linq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class SaveUpdatedOrganisationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldCallRepository_WithMappedDbEntity()
        {
            //arrange
            var loggerMock = new Mock<ILogger>();

            var organisation = new Organisation();

            var cpdsMapperMock = new Mock<ICpdsMapper>();
            cpdsMapperMock
                .Setup(x => x.MapProviderXmlToDbEntity(It.IsAny<XDocument>()))
                .Returns(organisation);
            var orgRepoMock = new Mock<IOrganisationRepository>();
            orgRepoMock
                .Setup(m => m.GetDetailByUkprn(It.IsAny<int>()))
                .Returns(new Organisation());
            var cpdsValidatorMock = new Mock<ICpdsXmlValidator>();

            var validationErrors = new List<OrganisationSchemaValidationError>();
            cpdsValidatorMock.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(), out validationErrors)).Returns(true);

            var handler = new SaveUpdatedOrganisationHandler(orgRepoMock.Object, cpdsMapperMock.Object, cpdsValidatorMock.Object)
            {
                Logger = loggerMock.Object
            };

            //act
            handler.Handle(new SaveUpdatedOrganisation
            {
                ChangedProvider = new XDocument()
            }, new TestableMessageHandlerContext()).Wait();

            //assert
            orgRepoMock.Verify(x => x.UpdateOrganisation(organisation),
                Times.Once, "Handle didn't call Update with message data.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldNotCallRepository_WithMappedDbEntity_IfXmlIsInvalidAgainstSchema()
        {
            //arrange
            var loggerMock = new Mock<ILogger>();

            var organisation = new Organisation();

            var cpdsMapperMock = new Mock<ICpdsMapper>();
            cpdsMapperMock.Setup(x => x.MapProviderXmlToDbEntity(It.IsAny<XDocument>())).Returns(organisation);
            var orgRepoMock = new Mock<IOrganisationRepository>();
            var cpdsValidatorMock = new Mock<ICpdsXmlValidator>();

            var validationErrors = new List<OrganisationSchemaValidationError>();
            cpdsValidatorMock.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(), out validationErrors)).Returns(false);

            var handler = new SaveUpdatedOrganisationHandler(orgRepoMock.Object, cpdsMapperMock.Object, cpdsValidatorMock.Object)
            {
                Logger = loggerMock.Object
            };

            //act
            handler.Handle(new SaveUpdatedOrganisation
            {
                ChangedProvider = new XDocument()
            }, new TestableMessageHandlerContext()).Wait();

            //assert
            orgRepoMock.Verify(x => x.UpdateOrganisation(organisation),
                Times.Never, "The organisation was saved");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldCallBusSend()
        {
            //arrange
            var loggerMock = new Mock<ILogger>();
            var cpdsMapperMock = new Mock<ICpdsMapper>();
            var orgRepoMock = new Mock<IOrganisationRepository>();
            orgRepoMock
                .Setup(m => m.GetDetailByUkprn(It.IsAny<int>()))
                .Returns(new Organisation());
            var cpdsValidatorMock = new Mock<ICpdsXmlValidator>();

            var validationErrors = new List<OrganisationSchemaValidationError>();
            cpdsValidatorMock.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(),out validationErrors)).Returns(true);
            cpdsMapperMock
                .Setup(mapper => mapper.MapProviderXmlToDbEntity(It.IsAny<XDocument>()))
                .Returns(new Organisation());

            var handler = new SaveUpdatedOrganisationHandler(orgRepoMock.Object, cpdsMapperMock.Object, cpdsValidatorMock.Object)
            {
                Logger = loggerMock.Object,
            };

            var message = new SaveUpdatedOrganisation();
            var context = new TestableMessageHandlerContext();

            //act
            handler.Handle(message, context).Wait();

            //assert
            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message is ProcessSavedOrganisation),
                "Unexpected number of ProcessSavedOrganisation messages sent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldCallBusSend_WithOrganisation()
        {
            //arrange
            var loggerMock = new Mock<ILogger>();
            var cpdsMapperMock = new Mock<ICpdsMapper>();
            var orgRepoMock = new Mock<IOrganisationRepository>();
            orgRepoMock
                .Setup(m => m.GetDetailByUkprn(It.IsAny<int>()))
                .Returns(new Organisation());
            var cpdsValidatorMock = new Mock<ICpdsXmlValidator>();

            var validationErrors = new List<OrganisationSchemaValidationError>();
            cpdsValidatorMock.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(), out validationErrors)).Returns(true);
            cpdsMapperMock
                .Setup(mapper => mapper.MapProviderXmlToDbEntity(It.IsAny<XDocument>()))
                .Returns(new Organisation());

            var handler = new SaveUpdatedOrganisationHandler(orgRepoMock.Object, cpdsMapperMock.Object,cpdsValidatorMock.Object)
            {
                Logger = loggerMock.Object
            };
            var context = new TestableMessageHandlerContext();

            //act
            handler.Handle(new SaveUpdatedOrganisation(), context).Wait();

            //assert
            Assert.IsTrue(context.SentMessages.Any(m => m.Message is ProcessSavedOrganisation),
                "No ProcessSavedOrganisation messages sent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldLogErrorAndNotThrowExceptionWhenCpdsMapperThrowsNullReferenceException()
        {
            // arrange
            Mock<ICpdsMapper> cpdsMapperMock = new Mock<ICpdsMapper>();
            cpdsMapperMock
                .Setup(m => m.MapProviderXmlToDbEntity(It.IsAny<XDocument>()))
                .Throws<NullReferenceException>();
            Mock<ILogger> loggerMock = new Mock<ILogger>();

            SaveUpdatedOrganisationHandler handler = new SaveUpdatedOrganisationHandler(
                new Mock<IOrganisationRepository>().Object,
                cpdsMapperMock.Object,
                new Mock<ICpdsXmlValidator>().Object)
            {
                Logger = loggerMock.Object
            };

            // act
            handler.Handle(new SaveUpdatedOrganisation(), new TestableMessageHandlerContext()).Wait();

            // assert
            loggerMock.Verify(
                m => m.LogError(It.IsAny<int>(), It.Is<string>(s => s.StartsWith("Unable to map Provider for storage. MapProviderXmlToDbEntity failed"))),
                Times.Once,
                "CPDS XML mapping error was not logged.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldLogErrorAndNotThrowExceptionWhenCpdsMapperThrowsArgumentNullException()
        {
            // arrange
            Mock<ICpdsMapper> cpdsMapperMock = new Mock<ICpdsMapper>();
            cpdsMapperMock
                .Setup(m => m.MapProviderXmlToDbEntity(It.IsAny<XDocument>()))
                .Throws<ArgumentNullException>();
            Mock<ILogger> loggerMock = new Mock<ILogger>();

            SaveUpdatedOrganisationHandler handler = new SaveUpdatedOrganisationHandler(
                new Mock<IOrganisationRepository>().Object,
                cpdsMapperMock.Object,
                new Mock<ICpdsXmlValidator>().Object)
            {
                Logger = loggerMock.Object
            };

            // act
            handler.Handle(new SaveUpdatedOrganisation(), new TestableMessageHandlerContext()).Wait();

            // assert
            loggerMock.Verify(
                m => m.LogError(It.IsAny<int>(), It.Is<string>(s => s.StartsWith("Unable to map Provider for storage. MapProviderXmlToDbEntity failed"))),
                Times.Once,
                "CPDS XML mapping error was not logged.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldLogErrorAndNotThrowExceptionWhenCpdsMapperThrowsFormatException()
        {
            // arrange
            Mock<ICpdsMapper> cpdsMapperMock = new Mock<ICpdsMapper>();
            cpdsMapperMock
                .Setup(m => m.MapProviderXmlToDbEntity(It.IsAny<XDocument>()))
                .Throws<FormatException>();
            Mock<ILogger> loggerMock = new Mock<ILogger>();

            SaveUpdatedOrganisationHandler handler = new SaveUpdatedOrganisationHandler(
                new Mock<IOrganisationRepository>().Object,
                cpdsMapperMock.Object,
                new Mock<ICpdsXmlValidator>().Object)
            {
                Logger = loggerMock.Object
            };

            // act
            handler.Handle(new SaveUpdatedOrganisation(), new TestableMessageHandlerContext()).Wait();

            // assert
            loggerMock.Verify(
                m => m.LogError(It.IsAny<int>(), It.Is<string>(s => s.StartsWith("Unable to map Provider for storage. MapProviderXmlToDbEntity failed"))),
                Times.Once,
                "CPDS XML mapping error was not logged.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldLogErrorAndNotThrowExceptionWhenCpdsMapperThrowsOverflowException()
        {
            // arrange
            Mock<ICpdsMapper> cpdsMapperMock = new Mock<ICpdsMapper>();
            cpdsMapperMock
                .Setup(m => m.MapProviderXmlToDbEntity(It.IsAny<XDocument>()))
                .Throws<OverflowException>();
            Mock<ILogger> loggerMock = new Mock<ILogger>();

            SaveUpdatedOrganisationHandler handler = new SaveUpdatedOrganisationHandler(
                new Mock<IOrganisationRepository>().Object,
                cpdsMapperMock.Object,
                new Mock<ICpdsXmlValidator>().Object)
            {
                Logger = loggerMock.Object
            };

            // act
            handler.Handle(new SaveUpdatedOrganisation(), new TestableMessageHandlerContext()).Wait();

            // assert
            loggerMock.Verify(
                m => m.LogError(It.IsAny<int>(), It.Is<string>(s => s.StartsWith("Unable to map Provider for storage. MapProviderXmlToDbEntity failed"))),
                Times.Once,
                "CPDS XML mapping error was not logged.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldSendCreateProviderUpdatedNotificationCommandWhenOrgBeforeHasDifferentNameThanOrgAfter()
        {
            // arrange
            var cpdsMapperMock = new Mock<ICpdsMapper>();
            var loggerMock = new Mock<ILogger>();
            var cpdsValidatorMock = new Mock<ICpdsXmlValidator>();
            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(r => r.GetDetailByUkprn(It.IsAny<int>())).Returns(new Organisation
            {
                TradingName = "X"
            });

            cpdsMapperMock.Setup(m => m.MapProviderXmlToDbEntity(It.IsAny<XDocument>())).Returns(new Organisation
            {
                TradingName = "Y"
            });

            List<OrganisationSchemaValidationError> validationErrors;
           
            cpdsValidatorMock.Setup(x => x.IsOrganisationValidAgainstOrganisationCorporateSchema(It.IsAny<organisation>(), out validationErrors)).Returns(true);

            SaveUpdatedOrganisationHandler handler = new SaveUpdatedOrganisationHandler(
                orgRepositoryMock.Object,
                cpdsMapperMock.Object,
                cpdsValidatorMock.Object)
            {
                Logger = loggerMock.Object
            };
            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new SaveUpdatedOrganisation(), context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message is CreateProviderUpdatedNotificationCommand),
                "Unexpected number of CreateProviderUpdatedNotificationCommand messages sent");
        }

    }
}
