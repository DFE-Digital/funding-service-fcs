using System;
using System.Threading.Tasks;

namespace Operations.Worker
{
    using NServiceBus.Pipeline;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CustomErrorHandlingBehavior : Behavior<ITransportReceiveContext>
    {
        private readonly ILogger _logger;

        public CustomErrorHandlingBehavior(ILogger logger)
        {
            _logger = logger;
        }

        public override async Task Invoke(ITransportReceiveContext context, Func<Task> next)
        {
            try
            {
                await next()
                    .ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                _logger.LogError(1, $"Exception Caught By NSB, Error: {ex.Message} StackTrace: {ex.StackTrace}");
                throw;
            }
        }
    }
}
