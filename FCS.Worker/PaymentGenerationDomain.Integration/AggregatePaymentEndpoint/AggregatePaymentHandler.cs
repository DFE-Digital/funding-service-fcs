namespace PaymentGenerationDomain.Integration.AggregatePaymentEndpoint
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class AggregatePaymentHandler : IHandleMessages<IPaymentAggregatedEvent>
    {
        public Task Handle(IPaymentAggregatedEvent message, IMessageHandlerContext context)
        {
            throw new NotImplementedException();
        }
    }
}
