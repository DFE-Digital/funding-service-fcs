using System.Collections.Generic;
using System.Threading.Tasks;
using NServiceBus;

namespace SFA.FCT.CrossDomain.Integration.Common
{
    public static class BusExtensions
    {
        private const string FctReplyToAddress = "FCTHeaders.ReplyToAddress";

        public static async Task SendWithReplyToAsync(this IMessageHandlerContext context, object message, string replyTo)
        {
            var headers = context.MessageHeaders;
            var replyToStack = string.Empty;

            if (headers != null && headers.TryGetValue(FctReplyToAddress, out var existingReplyTo) && !string.IsNullOrEmpty(existingReplyTo))
            {
                replyToStack = existingReplyTo + ";";
            }

            replyToStack += replyTo;

            var sendOptions = new SendOptions();
            sendOptions.SetHeader(FctReplyToAddress, replyToStack);

            await context.Send(message, sendOptions);
        }

        public static async Task ForwardForReplyAsync(this IMessageHandlerContext context, object message)
        {
            var headers = context.MessageHeaders;
            var sendOptions = new SendOptions();

            if (headers.TryGetValue(Headers.OriginatingSagaId, out var sagaId))
            {
                sendOptions.SetHeader(Headers.OriginatingSagaId, sagaId);
            }

            if (headers.TryGetValue(Headers.OriginatingSagaType, out var sagaType))
            {
                sendOptions.SetHeader(Headers.OriginatingSagaType, sagaType);
            }

            if (headers.TryGetValue(FctReplyToAddress, out var replyToAddress) && !string.IsNullOrEmpty(replyToAddress))
            {
                sendOptions.SetHeader(FctReplyToAddress, replyToAddress);
            }

            await context.Send(message, sendOptions);
        }

        public static async Task ReplyAsRequestedAsync(this IMessageHandlerContext context, object message)
        {
            var headers = context.MessageHeaders;

            if (headers.TryGetValue(Headers.RelatedTo, out var relatedTo))
            {
                // Cannot assign to headers[Headers.CorrelationId] because headers is IReadOnlyDictionary.
                // Instead, set the CorrelationId header on the ReplyOptions.
                if (headers.TryGetValue(FctReplyToAddress, out var replyToAddress) && !string.IsNullOrEmpty(replyToAddress))
                {
                    var thisReplyTo = replyToAddress;
                    var lastSeparatorIndex = replyToAddress.LastIndexOf(';');

                    if (lastSeparatorIndex != -1)
                    {
                        thisReplyTo = replyToAddress.Substring(lastSeparatorIndex + 1);
                        replyToAddress = replyToAddress.Substring(0, lastSeparatorIndex);

                        var replyOptions = new ReplyOptions();
                        replyOptions.SetHeader(FctReplyToAddress, replyToAddress);
                        replyOptions.SetHeader(Headers.ReplyToAddress, thisReplyTo);
                        replyOptions.SetHeader(Headers.CorrelationId, relatedTo);

                        await context.Reply(message, replyOptions);
                        return;
                    }

                    var fallbackOptions = new ReplyOptions();
                    fallbackOptions.SetHeader(Headers.ReplyToAddress, thisReplyTo);
                    fallbackOptions.SetHeader(Headers.CorrelationId, relatedTo);

                    await context.Reply(message, fallbackOptions);
                    return;
                }

                var defaultOptions = new ReplyOptions();
                defaultOptions.SetHeader(Headers.CorrelationId, relatedTo);

                await context.Reply(message, defaultOptions);
                return;
            }

            await context.Reply(message);
        }
    }
}
