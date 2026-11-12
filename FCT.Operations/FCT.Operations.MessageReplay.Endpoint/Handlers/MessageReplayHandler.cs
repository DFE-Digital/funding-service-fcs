
namespace SFA.FCT.Operations.MessageReplay.Endpoint.Handlers
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using Common.Commands;
    using Common.Services;
    using Framework.Logging.Interfaces;

    public class MessageReplayHandler : IHandleMessages<MessageReplayCommand>
    {
        private readonly IMessageReplayService _messageReplayService;
        private readonly ILogger _logger;

        public MessageReplayHandler(
            IMessageReplayService messageReplayService,
            ILogger logger)
        {
            _messageReplayService = messageReplayService;
            _logger = logger;
        }

        public async Task Handle(
            MessageReplayCommand message,
            IMessageHandlerContext context)
        {
            try
            {
                _logger.LogInformation(
                    $"MessageReplayCommand arrived {message}");

                _messageReplayService.ReplayMessage(
                    message.MessageId,
                    message.Description);

                _logger.LogInformation(
                    $"MessageReplayCommand completed {message}");
            }
            catch (Exception e)
            {
                _logger.LogInformation(
                    $"MessageReplayCommand failed {message} : {e.Message}");

                throw; // ✅ important for retries
            }

            await Task.CompletedTask;
        }
    }
}
