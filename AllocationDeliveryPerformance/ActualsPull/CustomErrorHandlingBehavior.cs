namespace ActualsPull
{
    using System;
    using System.Threading.Tasks;
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
                string errorMessageToLog = $"Exception caught by NSB 7: {ToExceptionLogMessage(ex)}";

                Exception baseException = ex.GetBaseException();
                if (baseException != ex)
                {
                    errorMessageToLog += $"{Environment.NewLine}{Environment.NewLine}-----{Environment.NewLine}{Environment.NewLine}{ToExceptionLogMessage(baseException)}";
                }

                _logger.LogError(1, errorMessageToLog);
                throw;
            }
        }

        private static string ToExceptionLogMessage(Exception exception)
        {
            string message = $"Error: {exception.Message} StackTrace: {exception.StackTrace}";

            // maybe get ef or ef core info here
            //IEnumerable<string> dbEntityValidationErrors = dbEntityValidationException.EntityValidationErrors
            //    .SelectMany(e => e.ValidationErrors)
            //    .Select(e => e.ErrorMessage);

            //message += $"{Environment.NewLine}{Environment.NewLine}DbEntityValidation errors: {string.Join("; ", dbEntityValidationErrors)}";
            
            return message;
        }
    }
}
