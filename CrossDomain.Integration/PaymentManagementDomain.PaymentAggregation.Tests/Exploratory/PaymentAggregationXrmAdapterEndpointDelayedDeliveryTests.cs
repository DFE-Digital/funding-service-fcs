namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Exploratory
{
    using CrossDomain.Integration.Events;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using UnitTests.Common;

    [TestClass]
    public class PaymentAggregationXrmAdapterEndpointDelayedDeliveryTests
    {
        //private const string ServiceBusConnectionString = "Endpoint=sb://fct-integrationsb-doat.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=";

        ///// <remarks>
        ///// Need to remove IEvent interface from PaymentScheduleEvent before running to enable sending as a command to specific endpoint.
        ///// </remarks>
        //[TestMethod, TestCategory("DataDependentExploratoryDOAT")]
        //public void SendPaymentScheduleEventAsCommandToXrmAdapterEndpointToCreatePostYearEndContractDeliverablePeriodInCrm()
        //{
        //    IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();

        //    PaymentScheduleEvent paymentScheduleEvent = TestResource.FromJson<PaymentScheduleEvent>(
        //        "SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Exploratory.Resources", "AGE-3244_G21_PaymentScheduleEvent.json");

        //    using (ISendOnlyBus bus = CreateCommandSendingBus<PaymentScheduleEvent>())
        //    {
        //        bus.Send("Xrm.ReceiveQueueForPaymentSchedule", paymentScheduleEvent);
        //    }
        //}

        ///// <remarks>
        ///// To replicate observed issues need to delete the following from CRM beforehand:
        ///// * Apr-17 contract deliverable periods for AGE-3244
        ///// * Subnominal aggregations with a key ending in "_AGE-3244_Apr-17"
        ///// </remarks>
        //[TestMethod, TestCategory("DataDependentExploratoryDOAT")]
        //public void PublishPaymentAggregatedEventToObserveRetryLogicInXrmAdapterEndpoint()
        //{
        //    PaymentAggregatedEvent paymentAggregatedEvent = TestResource.FromJson<PaymentAggregatedEvent>(
        //        "SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Exploratory.Resources", "AGE-3244_G21_PaymentAggregatedEvent.json");

        //    using (ISendOnlyBus bus = CreateEventPublishingBus<PaymentAggregatedEvent>("PaymentManagementDomain.PaymentAggregation"))
        //    {
        //        bus.Publish(paymentAggregatedEvent);
        //    }
        //}

        //private static ISendOnlyBus CreateCommandSendingBus<T>()
        //{
        //    BusConfiguration busConfiguration = new BusConfiguration();
        //    busConfiguration.Conventions().DefiningCommandsAs(t => t == typeof(T));
        //    busConfiguration.UseSerialization<JsonSerializer>();
        //    TransportExtensions<AzureServiceBusTransport> transportExtensions = busConfiguration.UseTransport<AzureServiceBusTransport>();
        //    transportExtensions.ConnectionString(ServiceBusConnectionString);

        //    return Bus.CreateSendOnly(busConfiguration);
        //}

        //private static ISendOnlyBus CreateEventPublishingBus<T>(string endpointName)
        //{
        //    BusConfiguration busConfiguration = new BusConfiguration();
        //    busConfiguration.EndpointName(endpointName);
        //    busConfiguration.Conventions().DefiningEventsAs(t => t == typeof(T));
        //    busConfiguration.UseSerialization<JsonSerializer>();
        //    TransportExtensions<AzureServiceBusTransport> transportExtensions = busConfiguration.UseTransport<AzureServiceBusTransport>();
        //    transportExtensions.ConnectionString(ServiceBusConnectionString);

        //    return Bus.CreateSendOnly(busConfiguration);
        //}
    }
}
