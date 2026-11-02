namespace PaymentGenerationDomain.Integration.PaymentGeneration.ProcessPaymentRunComplete
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common;
    using DataStore;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PaymentGenerationEndpoint.Infrastructure;
    using PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint;
    using PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint.Ioc;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ProcessPaymentRunCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ProcessPaymentRunCompleteHandler_ShouldUpdateTheTimeTableToComplete()
        {
            var message = new ProcessPaymentRunCompleteCommand
            {
                FundingStreamShortCode = "AP16",
                FundingStreamPeriodStartDate = new DateTime(2015, 8, 1),
                FundingStreamPeriodEndDate = new DateTime(2016, 7, 31),
                CensusEndDate = new DateTime(2015, 8, 1),
                LinkCode = "AP16150616A"
            };
            var datamanagerMock = new Mock<IDataAccessManager>();
            datamanagerMock.Setup(
                x =>
                    x.GetFundingStreamPeriodCodeFromShortCode(It.IsAny<string>(), It.IsAny<DateTime>(),
                        It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>())).Returns("16-18APPS1516");
            datamanagerMock.Setup(
                x =>
                    x.GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate("16-18APPS1516",
                        message.CensusEndDate, It.IsAny<ConnectionInfo>())).Returns("201508");

            var loggerMock = new Mock<ILogger>();
            var aggregatedPaymentMapperMock = new Mock<IAggregatedPaymentMapper>();
            aggregatedPaymentMapperMock.Setup(
                    (x => x.MapDbEntitiesToAggregatedPaymentCorporateSchema(It.IsAny<List<SubnominalAggregation>>(),
                        It.IsAny<ConnectionInfo>())))
                .Returns(new List<Allocation>());

            datamanagerMock.Setup(m =>
                    m.UpdatePaymentsToPostedForPaymentRun(It.IsAny<string>(), It.IsAny<string>(),
                        It.IsAny<ConnectionInfo>()))
                .Returns(new List<SubnominalAggregation>());

            var outstandingPaymentsCheckerMock = new Mock<IOutstandingPaymentsChecker>();
            outstandingPaymentsCheckerMock.Setup(m =>
                m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>())).Returns(true);

            var handler = new ProcessPaymentRunCompleteHandler(
                datamanagerMock.Object,
                aggregatedPaymentMapperMock.Object,
                outstandingPaymentsCheckerMock.Object,
                loggerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            datamanagerMock.Verify(
                x => x.UpdateTimetableForCompletedPaymentRun("16-18APPS1516", "201508", "AP16150616A",
                    It.IsAny<ConnectionInfo>()), Times.Once(),
                "Handle_ProcessPaymentRunCompleteCommand didn't update the timetable");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessPaymentRunCompleteHandler_ShouldUpdatePaymentsToPosted()
        {
            var message = new ProcessPaymentRunCompleteCommand()
            {
                FundingStreamShortCode = "AP16",
                CensusEndDate = new DateTime(2015, 8, 1),
            };
            var datamanagerMock = new Mock<IDataAccessManager>();
            datamanagerMock.Setup(x => x.GetFundingStreamPeriodCodeFromShortCode("AP16",
                It.IsAny<DateTime>(),
                It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()
            )).Returns("AA1234");

            var loggerMock = new Mock<ILogger>();
            var aggregatedPaymentMapperMock = new Mock<IAggregatedPaymentMapper>();
            aggregatedPaymentMapperMock.Setup(
                    (x => x.MapDbEntitiesToAggregatedPaymentCorporateSchema(It.IsAny<List<SubnominalAggregation>>(),
                        It.IsAny<ConnectionInfo>())))
                .Returns(new List<Allocation>());

            datamanagerMock.Setup(m =>
                    m.UpdatePaymentsToPostedForPaymentRun(It.IsAny<string>(), It.IsAny<string>(),
                        It.IsAny<ConnectionInfo>()))
                .Returns(new List<SubnominalAggregation>());

            var outstandingPaymentsChecker = new Mock<IOutstandingPaymentsChecker>();
            outstandingPaymentsChecker.Setup(m =>
                m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>())).Returns(true);

            var handler = new ProcessPaymentRunCompleteHandler(
                datamanagerMock.Object,
                aggregatedPaymentMapperMock.Object,
                outstandingPaymentsChecker.Object,
                loggerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            datamanagerMock.Verify(
                x => x.UpdatePaymentsToPostedForPaymentRun("AA1234", It.IsAny<string>(), It.IsAny<ConnectionInfo>()),
                Times.Once(),
                "Handle_ProcessPaymentRunCompleteCommand didn't cupdate posted flags");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessPaymentRunCompleteHandler_ShouldPublishAnEventWithUpdatedAllocationsWithPostedFlags()
        {
            var message = new ProcessPaymentRunCompleteCommand()
            {
                FundingStreamShortCode = "AP16",
                CensusEndDate = new DateTime(2015, 8, 1),
            };
            var datamanagerMock = new Mock<IDataAccessManager>();
            datamanagerMock.Setup(x => x.GetFundingStreamPeriodCodeFromShortCode("AP16",
                It.IsAny<DateTime>(),
                It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()
            )).Returns("AA1234");

            var loggerMock = new Mock<ILogger>();
            var aggregatedPaymentMapperMock = new Mock<IAggregatedPaymentMapper>();
            aggregatedPaymentMapperMock.Setup(
                    (x => x.MapDbEntitiesToAggregatedPaymentCorporateSchema(It.IsAny<List<SubnominalAggregation>>(),
                        It.IsAny<ConnectionInfo>())))
                .Returns(new List<Allocation>() {new Allocation() { }});

            datamanagerMock.Setup(m =>
                    m.UpdatePaymentsToPostedForPaymentRun(It.IsAny<string>(), It.IsAny<string>(),
                        It.IsAny<ConnectionInfo>()))
                .Returns(new List<SubnominalAggregation>());

            var outstandingPaymentsCheckerMock = new Mock<IOutstandingPaymentsChecker>();
            outstandingPaymentsCheckerMock.Setup(m =>
                m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>())).Returns(true);

            var handler = new ProcessPaymentRunCompleteHandler(
                datamanagerMock.Object,
                aggregatedPaymentMapperMock.Object,
                outstandingPaymentsCheckerMock.Object,
                loggerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            var context = new TestableMessageHandlerContext();

            handler.Handle(message, context).Wait();

            aggregatedPaymentMapperMock.Verify(
                x => x.MapDbEntitiesToAggregatedPaymentCorporateSchema(It.IsAny<List<SubnominalAggregation>>(),
                    It.IsAny<ConnectionInfo>()),
                Times.Once(),
                "Handle_ProcessPaymentRunCompleteCommand didn't call MapDbEntitiesToAggregatedPaymentCorporateSchema");

            Assert.AreEqual(1,
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<PaymentPostedEvent>()
                    .Count(),
                "Handle_ProcessPaymentRunCompleteCommand didn't call Bus.Publish");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(Exception))]
        public void ProcessPaymentRunCompleteHandler_ShouldLogTheError_WhenErrorOccurs()
        {
            var message = new ProcessPaymentRunCompleteCommand()
            {
                FundingStreamShortCode = "AP16",
                CensusEndDate = new DateTime(2015, 8, 1),
            };
            var testException = new Exception("Test Exception");
            var contextMock = new Mock<PaymentGenerationDbContext>();
            var datamanagerMock = new Mock<IDataAccessManager>();
            datamanagerMock.Setup(x => x.GetFundingStreamPeriodCodeFromShortCode("AP16",
                It.IsAny<DateTime>(),
                It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()
            )).Throws(testException);

            var loggerMock = new Mock<ILogger>();

            var outstandingPaymentsCheckerMock = new Mock<IOutstandingPaymentsChecker>();
            outstandingPaymentsCheckerMock.Setup(m =>
                m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>())).Returns(true);

            var handler = new ProcessPaymentRunCompleteHandler(
                datamanagerMock.Object,
                Mock.Of<IAggregatedPaymentMapper>(),
                outstandingPaymentsCheckerMock.Object,
                loggerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            try
            {
                handler.Handle(message, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex)
            {
                loggerMock.Verify(x => x.LogError(
                        PaymentGenerationDomainLoggingEventId.PaymentGenerationError,
                        testException,
                        It.IsAny<string>(),
                        "AP16",
                        It.IsAny<string>()),
                    Times.Once(),
                    "Handle_ProcessPaymentRunCompleteCommand didn't log the error");
                throw ex.InnerException;
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessPaymentRunCompleteHandler_ShouldPublishEventWithAllocationNumberAndHasOutstandingPayments()
        {
            // arrange
            const string allocNum = "ALLOC1";

            Mock<IDataAccessManager> dataManagerMock = new Mock<IDataAccessManager>();
            Mock<IAggregatedPaymentMapper> mapperMock = new Mock<IAggregatedPaymentMapper>();
            Mock<IOutstandingPaymentsChecker> outstandingPaymentsCheckerMock = new Mock<IOutstandingPaymentsChecker>();

            dataManagerMock.Setup(m => m.UpdatePaymentsToPostedForPaymentRun(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                    .Returns(new List<SubnominalAggregation>());

            mapperMock.Setup(
                    (x => x.MapDbEntitiesToAggregatedPaymentCorporateSchema(It.IsAny<List<SubnominalAggregation>>(), It.IsAny<ConnectionInfo>())))
                    .Returns(new List<Allocation>() { new Allocation { AllocationNumber = allocNum } });

            outstandingPaymentsCheckerMock.Setup(m => m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            var handler = new ProcessPaymentRunCompleteHandler(
                dataManagerMock.Object,
                mapperMock.Object,
                outstandingPaymentsCheckerMock.Object,
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>());

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new ProcessPaymentRunCompleteCommand()
            {
                FundingStreamShortCode = "AP16",
                CensusEndDate = new DateTime(2015, 8, 1),
            }, context).Wait();

            // assert
            Assert.AreEqual(1,
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<IAllocationPaymentsChangedOnPostingEvent>()
                    .Count(e => e.HasOutstandingPayments && e.AllocationNumber == allocNum));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessPaymentRunCompleteHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            IWindsorContainer container  = new WindsorContainer().Install(new ProcessPaymentRunCompleteWindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<ProcessPaymentRunCompleteHandler>());
            container.BeginScope();

            container.Resolve<ProcessPaymentRunCompleteHandler>();
        }
    }
}
