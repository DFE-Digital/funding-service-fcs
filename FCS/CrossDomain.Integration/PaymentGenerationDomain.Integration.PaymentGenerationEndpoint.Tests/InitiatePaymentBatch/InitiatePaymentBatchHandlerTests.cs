namespace PaymentGenerationDomain.Integration.PaymentGeneration.InitiatePaymentBatch
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentGenerationDomain.Common.Commands;
    using PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint;
    using BusinessLogic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using SFA.FCT.Framework.Logging;
    using Castle.MicroKernel.Registration;
    using DataStore;
    using NServiceBus.Testing;
    using PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint.Ioc;
    using PaymentGenerationEndpoint.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class InitiatePaymentBatchHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiatePaymentBatchHandler_ShouldGetThePaymentTimetableFromDatabase()
        {
            // Arrange 
            var date = new Mock<IDate>();
            DateTime assertDate = DateTime.MinValue;
            date.Setup(x => x.GetCalculationDate()).Returns(assertDate).Verifiable();

            var dataManagerMock = new Mock<IDataAccessManager>();
            dataManagerMock.Setup(x => x.GetPaymentTimetableByDateAndStatus(It.IsAny<DateTime>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<PaymentTimetable>());

            var handler = new InitiatePaymentBatchHandler(
                logger: Mock.Of<ILogger>(),
                date: date.Object,
                dataManager: dataManagerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            // Act
            handler.Handle(new InitiatePaymentBatchCommand(), new TestableMessageHandlerContext()).Wait();

            // Assert
            date.Verify(x => x.GetCalculationDate(), Times.Once,
                "GetCalculationDate was not called");
            dataManagerMock.Verify(x => x.GetPaymentTimetableByDateAndStatus(It.Is<DateTime>(y => y == assertDate), PaymentRunStatus.NotStarted, It.IsAny<ConnectionInfo>()), Times.Once(),
                "Handle_PaymentBatchCommand didn't get the timetable");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiatePaymentBatchHandler_ShouldSendAnInitiatePaymentRunCommandPerTimetableItem()
        {
            // Arrange 
            var date = new Mock<IDate>();
            date.Setup(x => x.GetCalculationDate()).Returns(DateTime.MinValue).Verifiable();

            var dataManagerMock = new Mock<IDataAccessManager>();
            dataManagerMock.Setup(x => x.GetPaymentTimetableByDateAndStatus(It.IsAny<DateTime>(), PaymentRunStatus.NotStarted, It.IsAny<ConnectionInfo>()))
                .Returns(new List<PaymentTimetable> { new PaymentTimetable(), new PaymentTimetable() });
            
            var handler = new InitiatePaymentBatchHandler(
                logger: Mock.Of<ILogger>(),
                date: date.Object,
                dataManager: dataManagerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            var context = new TestableMessageHandlerContext();

            // Act
            handler.Handle(new InitiatePaymentBatchCommand(), context).Wait();

            // Assert
            date.Verify(x => x.GetCalculationDate(), Times.Once,
                "GetCalculationDate was not called");
            Assert.AreEqual(2,
                context.SentMessages
                    .Select(m => m.Message)
                    .OfType<InitiatePaymentRunCommand>()
                    .Count(),
                "InitiatePaymentBatchHandler didn't send an InitiatePaymentRunCommand the required number of times");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiatePaymentBatchHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new InitiatePaymentBatchWindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<IHandleMessages<InitiatePaymentBatchCommand>>()
                .ImplementedBy<InitiatePaymentBatchHandler>());

            container.BeginScope();

            var handler = container.Resolve<IHandleMessages<InitiatePaymentBatchCommand>>();

            Assert.IsNotNull(handler, "InitiatePaymentBatchHandler did not resolve");
        }
    }
}
