using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace PaymentGenerationDomain.Integration.PaymentGeneration.InitiatePaymentRun
{
    using Moq;
    using NServiceBus.Testing;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Common.Commands;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentRunEndpoint;
    using PaymentGenerationEndpoint.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class InitiatePaymentRunHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiatePaymentRunHandler_ShouldCallMethodUpdateTimetableStatusForPaymentRun()
        {
            // Arrange
            var dataManagerMock = new Mock<IDataAccessManager>();

            var message = new InitiatePaymentRunCommand()
            {
                PaymentTimetable = new PaymentTimetable
                {
                    FundingStreamPeriodCode = "1",
                    CalendarPeriod = "201501"
                }
            };

            var handler = new InitiatePaymentRunHandler()
            {
                DataManager = dataManagerMock.Object,
                Logger = Mock.Of<ILogger>(),
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };

            // Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            // Assert
            dataManagerMock.Verify(x => x.UpdateTimetableStatusForPaymentRun("1", "201501", It.IsAny<ConnectionInfo>()), 
                Times.Once(), "InitiatePaymentRunHandler didn't update the timetable status");
        }
    }
}
