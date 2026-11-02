namespace SFA.FCT.Operations.MessageReplay.Endpoint.Handlers
{
    using System;
    using Common;
    using NServiceBus;
    using Common.Commands;
    using Common.Services;
    using Framework.Logging.Interfaces;
    using Services;

    public class MessageReplayHandler : IHandleMessages<MessageReplayCommand>
    {
        private readonly IMessageReplayService _messageReplayService;
        private readonly ILogger _logger;

        public MessageReplayHandler(IMessageReplayService messageReplayService, ILogger logger)
        {
            _messageReplayService = messageReplayService;
            _logger = logger;
        }

        public void Handle(MessageReplayCommand message)
        {
            try
            {
                _logger.LogInformation(LoggingEventId.MessageReplay, $"MessageReplayCommand arrived {message}");

                _messageReplayService.ReplayMessage(message.MessageId, message.Description);

                _logger.LogInformation(LoggingEventId.MessageReplay, $"MessageReplayCommand completed {message}");
            }
            catch (Exception e)
            {
                _logger.LogError(LoggingEventId.MessageReplay, $"MessageReplayCommand failed {message} + {e.Message}");
                throw;
            }
        }
    }
}