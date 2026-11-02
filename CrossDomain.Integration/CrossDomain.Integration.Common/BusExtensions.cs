namespace SFA.FCT.CrossDomain.Integration.Common
{
    using NServiceBus;
    using NServiceBus.Unicast;

    public static class BusExtensions
    {
        private const string FctReplyToAddress = "FCTHeaders.ReplyToAddress";

        public static void Send(this IBus bus, object message, string replyTo)
        {
            // push the replyTo address onto the stack allowing for nesting replyTo handlers
            string replyToAddress = string.Empty;

            if (bus.CurrentMessageContext != null &&
                bus.CurrentMessageContext.Headers != null &&
                bus.CurrentMessageContext.Headers.TryGetValue(FctReplyToAddress, out replyToAddress) &&
                !string.IsNullOrEmpty(replyToAddress))
            {
                replyToAddress += ";";
            }

            replyToAddress += replyTo;

            bus.SetMessageHeader(message, FctReplyToAddress, replyToAddress);
            
            bus.SetMessageHeader(message, FctReplyToAddress, replyTo);
            bus.Send(message);
        }

        public static void ForwardForReply(this IBus bus, object message)
        {
            // this sets the return address on the outbound message to being the originating caller rather than this handler
            ((UnicastBus)bus).PropagateReturnAddressOnSend = true;

            // forward the Saga headers if they exixt so that the reply in the following handler will find the originating saga
            string sagaId;
            if (bus.CurrentMessageContext.Headers.TryGetValue(Headers.OriginatingSagaId, out sagaId))
            {
                bus.SetMessageHeader(message, Headers.OriginatingSagaId, sagaId);
            }

            string sagaType;
            if (bus.CurrentMessageContext.Headers.TryGetValue(Headers.OriginatingSagaType, out sagaType))
            {
                bus.SetMessageHeader(message, Headers.OriginatingSagaType, sagaType);
            }

            string replyToAddress;
            if (bus.CurrentMessageContext.Headers.TryGetValue(FctReplyToAddress, out replyToAddress) && !string.IsNullOrEmpty(replyToAddress))
            {
                bus.SetMessageHeader(message, FctReplyToAddress, replyToAddress);
            }

            bus.Send(message);
        }

        public static void ReplyAsRequested(this IBus bus, object message)
        {
            bus.CurrentMessageContext.Headers[Headers.CorrelationId] = bus.CurrentMessageContext.Headers[Headers.RelatedTo];

            // pop the most recent replyTo address from the stack
            string replyToAddress;
            if (bus.CurrentMessageContext.Headers.TryGetValue(FctReplyToAddress, out replyToAddress) && !string.IsNullOrEmpty(replyToAddress))
            {
                var thisReplyTo = replyToAddress;
                var lastSeperatorIndex = replyToAddress.LastIndexOf(';');

                if (lastSeperatorIndex != -1)
                {
                    thisReplyTo = replyToAddress.Substring(lastSeperatorIndex + 1);

                    replyToAddress = replyToAddress.Substring(0, lastSeperatorIndex);
                    bus.SetMessageHeader(message, FctReplyToAddress, replyToAddress);
                }

                bus.CurrentMessageContext.Headers[Headers.ReplyToAddress] = thisReplyTo;
            }

            // the reply is important as there is behaviour that relies upon the message's SaveOptions in NServiceBus being a ReplyOptions instance
            // and then it turns the OriginatingSagaId/Type into SagaId/SagaType headers 
            // look at NServiceBus/Sagas/PopulateAutoCorrelationHeadersForRepliesBehavior and SagaPersistenceBehavior classes to see how these are handled
            bus.Reply(message);          
        }
    }
}
