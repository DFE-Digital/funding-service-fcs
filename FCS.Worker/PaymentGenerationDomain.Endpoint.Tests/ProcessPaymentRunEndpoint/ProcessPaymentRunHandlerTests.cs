namespace PaymentGenerationDomain.Endpoint.Tests.ProcessPaymentRunEndpoint
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using BusinessLogic.Services;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Commands;
    using Endpoint.ProcessPaymentRunEndpoint;
    using Endpoint.ProcessPaymentRunEndpoint.Handlers;
    using Integration.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint.Services;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateSchema = Entity::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    [TestClass]
    public class ProcessPaymentRunHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task ProcessPaymentRunHandler_ShouldSendProcessPaymentRunCompleteCommandWhenPaymentPeriodPublishedWithPayments()
        {
            // arrange
            Mock<IPaymentRunService> paymentRunServiceMock = new Mock<IPaymentRunService>();
            paymentRunServiceMock
                .Setup(m => m.PublishPaymentPeriod(
                    It.IsAny<PaymentTimetable>(), It.IsAny<Func<CorporateSchema.PaymentPeriod, int, Task>>(), It.IsAny<Func<string, Task>>(), It.IsAny<ConnectionInfo>()))
                .Callback<PaymentTimetable, Func<CorporateSchema.PaymentPeriod, int, Task>, Func<string, Task>, ConnectionInfo>(
                    (paymentTimetable, published, failed, connection) =>
                    {
                        published(new CorporateSchema.PaymentPeriod
                        {
                            PaymentDetails = new List<CorporateSchema.PaymentDetail> { new CorporateSchema.PaymentDetail() }
                        }, 1);
                    })
                .Returns(Task.FromResult(0));

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            ProcessPaymentRunHandler handler = new ProcessPaymentRunHandler(Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>(), paymentRunServiceMock.Object);

            // act
            await handler.Handle(new ProcessPaymentRunCommand { PaymentTimetable = new PaymentTimetable() }, context);

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message is ProcessPaymentRunCompleteCommand));
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ProcessPaymentRunHandler_ShouldSendProcessPaymentRunErrorCommandWhenPaymentPeriodFailsValidation()
        {
            // arrange
            Mock<IPaymentRunService> paymentRunServiceMock = new Mock<IPaymentRunService>();
            paymentRunServiceMock
                .Setup(m => m.PublishPaymentPeriod(
                    It.IsAny<PaymentTimetable>(), It.IsAny<Func<CorporateSchema.PaymentPeriod, int, Task>>(), It.IsAny<Func<string, Task>>(), It.IsAny<ConnectionInfo>()))
                .Callback<PaymentTimetable, Func<CorporateSchema.PaymentPeriod, int, Task>, Func<string, Task>, ConnectionInfo>(
                    (paymentTimetable, published, failed, connection) =>
                    {
                        failed("validation errors");
                    })
                .Returns(Task.FromResult(0));

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            ProcessPaymentRunHandler handler = new ProcessPaymentRunHandler(Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>(), paymentRunServiceMock.Object);

            // act
            await handler.Handle(new ProcessPaymentRunCommand { PaymentTimetable = new PaymentTimetable() }, context);

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.IsInstanceOfType(context.SentMessages.Single().Message, typeof(ProcessPaymentRunErrorCommand));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessPaymentRunHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ProcessPaymentRunHandler>().ImplementedBy<ProcessPaymentRunHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<ProcessPaymentRunHandler>();
        }
    }
}
