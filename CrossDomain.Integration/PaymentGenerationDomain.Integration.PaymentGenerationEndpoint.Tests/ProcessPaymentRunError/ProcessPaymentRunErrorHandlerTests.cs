namespace PaymentGenerationDomain.Integration.PaymentGeneration.ProcessPaymentRunError
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Common;
    using PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunErrorEndpoint;
    using PaymentGenerationEndpoint.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ProcessPaymentRunErrorHandlerTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public void Handle_ProcessPaymentRunErrorCommand_ShouldUpdateTheTimeTableToFailed()
        {
            var message = new ProcessPaymentRunErrorCommand
            {
                FundingStreamShortCode= "AP16",
                FundingStreamPeriodStartDate = new DateTime(2015, 8, 1),
                FundingStreamPeriodEndDate = new DateTime(2016, 7, 31),
                CensusEndDate = new DateTime(2015,8,1),
                FailureDescription="Error Occured"
            };
            var datamanagerMock = new Mock<IDataAccessManager>();
            datamanagerMock.Setup(x => x.GetFundingStreamPeriodCodeFromShortCode(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>())).Returns("16-18APPS1516");
            datamanagerMock.Setup(
                x =>
                    x.GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate("16-18APPS1516",
                        message.CensusEndDate, It.IsAny<ConnectionInfo>())).Returns("201508");
            
            var loggerMock = new Mock<ILogger>();
            var handler = new ProcessPaymentRunErrorHandler
            {
                DataManager=datamanagerMock.Object,
                Logger=loggerMock.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            datamanagerMock.Verify(x => x.UpdateTimetableStatusForFailedPaymentRun("16-18APPS1516", "201508", It.IsAny<ConnectionInfo>()), Times.Once(), "Handle_ProcessPaymentRunErrorCommand didn't update the timetable");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessPaymentRunErrorCommand_ShouldLogAnError()
        {
            var message = new ProcessPaymentRunErrorCommand()
            {
                FundingStreamShortCode = "AP16",
                CensusEndDate = new DateTime(2015, 8, 1),
                FailureDescription = "Error Occured"
            };
            var datamanagerMock = new Mock<IDataAccessManager>();
            datamanagerMock.Setup(x => x.GetFundingStreamPeriodCodeFromShortCode(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>())).Returns("16-18APPS1516");
            datamanagerMock.Setup(
                x =>
                    x.GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate("16-18APPS1516",
                        message.CensusEndDate, It.IsAny<ConnectionInfo>())).Returns("201508");
            var loggerMock = new Mock<ILogger>();
            var handler = new ProcessPaymentRunErrorHandler()
            {
                DataManager = datamanagerMock.Object,
                Logger = loggerMock.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();
            loggerMock.Verify(x => x.LogError(PaymentGenerationDomainLoggingEventId.PaymentGenerationError,
                It.IsAny<string>(), "AP16", "201508", It.IsAny<string>(), "Error Occured"), Times.Once(),
                "Handle_ProcessPaymentRunErrorCommand didn't log the error");
        }
    }
}
