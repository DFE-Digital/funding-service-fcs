namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Handlers
{
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentSchedule.PaymentScheduleXrm;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services;

    [TestClass]
    public class XrmPaymentScheduleHandlerTests
    {
        private readonly Mock<IMessageHandlerContext> _messageHandlerContextMock = new Mock<IMessageHandlerContext>();

        [TestMethod, TestCategory("UnitTest")]
        public void XrmPaymentScheduleHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            // Act
            GetContainer().Resolve<PaymentScheduleEventHandler>();
        }

        private IWindsorContainer GetContainer()
        {
            IWindsorContainer container = new WindsorContainer().Install(new PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.WindsorInstaller(new LoggerFactory()));
            container.Register(global::Castle.MicroKernel.Registration.Component.For<global::Microsoft.Xrm.Sdk.IOrganizationService>().Instance(global::Moq.Mock.Of<global::Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());
            container.Register(Component.For<PaymentScheduleEventHandler>());
            container.Register(Component.For<IMessageHandlerContext>().Instance(_messageHandlerContextMock.Object));
            container.BeginScope();

            return container;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyMissingDeliverablePeriodCreator_ShouldResolve()
        {
            var creator = GetContainer().Resolve<ILevyMissingDeliverablePeriodCreator>();

            Assert.IsNotNull(creator);
        }

        private PaymentScheduleEvent CreateDummyPaymentScheduleEvent()
        {
            PaymentScheduleEvent paymentScheduleEvent = new PaymentScheduleEvent
            {
                TimesMessageDeferred = 0,
                PaymentScheduleAllocation = new Allocation
                {
                    ContractNumber = "CON-XXX",
                    AllocationNumber = "ALL-XX",
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201501"
                                }
                            }
                        }
                    }
                }
            };
            return paymentScheduleEvent;
        }
    }
}
