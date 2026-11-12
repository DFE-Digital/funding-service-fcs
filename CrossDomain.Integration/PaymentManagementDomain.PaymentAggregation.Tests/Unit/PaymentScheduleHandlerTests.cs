namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Unit
{
    extern alias Entities;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Castle.Windsor;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Events;
    using Microsoft.Extensions.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus.Testing;
    using PaymentManagementDomain.Integration.PaymentAggregation.Handlers;
    using PaymentManagementDomain.Integration.PaymentAggregation.Services;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.IoC;
    using paymentsAggregation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using paymentSchedule = Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using PaymentManagementDomain.Integration.PaymentAggregation.Infrastructure;

    [TestClass]
    public class PaymentScheduleHandlerTests
    {
        private Mock<IPaymentAggregationService> _paymentAggregationServiceMock;
        private Mock<IPayCalcPolicyQueryRepository> _payCalcPolicyQueryRepositoryMock;
        private PaymentScheduleHandler _paymentScheduleHandler;

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new Microsoft.Extensions.Logging.LoggerFactory()))
                .Register(Component.For<PaymentScheduleHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<PaymentScheduleHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleHandler_ShouldPublishPaymentAggregationEventWhenFundingStreamIsPayable()
        {
            // arrange
            SetupMocks();
            const int expectedNumberOfPublishedEvents = 1;

            var paymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new paymentSchedule.Allocation
                {
                    FundingStreamPeriodCode = "POA_FSP"
                }
            };
            var context = new TestableMessageHandlerContext();

            // act
            _paymentScheduleHandler.Handle(paymentScheduleEvent, context).Wait();

            // assert
            Assert.AreEqual(expectedNumberOfPublishedEvents, context.PublishedMessages.Count(m => m.Message is PaymentAggregatedEvent), $"Incorrect number of PaymentAggregatedEvent messages published. Should be {expectedNumberOfPublishedEvents}");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleHandler_ShouldNotPublishPaymentAggregationEventWhenFundingStreamIsNotPayable()
        {
            // arrange
            SetupMocks();
            const int expectedNumberOfPublishedEvents = 0;

            var paymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new paymentSchedule.Allocation
                {
                    FundingStreamPeriodCode = "NOPAY_FSP"
                }
            };
            var context = new TestableMessageHandlerContext();

            // act
            _paymentScheduleHandler.Handle(paymentScheduleEvent, context).Wait();

            // assert
            Assert.AreEqual(expectedNumberOfPublishedEvents, context.PublishedMessages.Count(m => m.Message is PaymentAggregatedEvent), $"Incorrect number of PaymentAggregatedEvent messages published. Should be {expectedNumberOfPublishedEvents}");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleHandler_ShouldSendUnchangedMsg_WhenPaymentMethodPoA_AndPaymentEventOriginApprovalAndThereAreNpZeroAggregatedValues()
        {
            // arrange
            SetupMocks();
            const int expectedNumberOfPublishedEvents = 1;

            var message = FromJson<PaymentAggregatedEvent>("SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests",
                "Resources.PaymentAggregatedEvent_596.json");

            _paymentAggregationServiceMock
                .Setup(x => x.CalculateAggregatedPayments(It.IsAny<paymentSchedule.Allocation>(), It.IsAny<ConnectionInfo>()))
                .Returns(message.Allocation);

            var paymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new paymentSchedule.Allocation
                {
                    FundingStreamPeriodCode = "POA_FSP"
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced
            };
            var context = new TestableMessageHandlerContext();

            // act
            _paymentScheduleHandler.Handle(paymentScheduleEvent, context).Wait();

            // assert
            Assert.AreEqual(expectedNumberOfPublishedEvents, context.PublishedMessages.Count(m => m.Message is PaymentAggregatedEvent), $"Incorrect number of PaymentAggregatedEvent messages published. Should be {expectedNumberOfPublishedEvents}");
            var messagePublished = (PaymentAggregatedEvent)context.PublishedMessages[0].Message;
            Assert.AreEqual(message.Allocation.SerializeToXml(), messagePublished.Allocation.SerializeToXml(), "The allocation sent out has been changed");
        }

        public static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }

        private void SetupMocks()
        {

            _paymentAggregationServiceMock = new Mock<IPaymentAggregationService>();
            _paymentAggregationServiceMock
                .Setup(x => x.CalculateAggregatedPayments(It.IsAny<paymentSchedule.Allocation>(), It.IsAny<ConnectionInfo>()))
                .Returns(new paymentsAggregation.Allocation());

            _payCalcPolicyQueryRepositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            _payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriod("NOPAY_FSP", It.IsAny<ConnectionInfo>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = "NOPAY_FSP",
                    PaymentMethod = PaymentMethod.NoPay
                });
            _payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriod("POA_FSP", It.IsAny<ConnectionInfo>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = "POA_FSP",
                    PaymentMethod = PaymentMethod.PayOnActuals
                });

            _paymentScheduleHandler = new PaymentScheduleHandler(
                Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>(),
                _paymentAggregationServiceMock.Object,
                _payCalcPolicyQueryRepositoryMock.Object,
                Mock.Of<ISessionConnectionFactory>());
        }
    }
}
