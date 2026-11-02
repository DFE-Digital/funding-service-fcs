namespace Operations.Worker.Audit
{
    using System;
    using System.Data.Entity.Validation;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Azure.Messaging.ServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using DbUpdateException = Microsoft.EntityFrameworkCore.DbUpdateException;

    public static class QueueListener
    {
        private const int UniqueConstraintViolation = 2627;
        private static LargeMessageRepository _largeMessageRepository;
        private static IFcsConfiguration _configuration;

        public static async Task BeginListening(Action<FcsMessage> processMessage, string queueName, ILogger logger, IFcsConfiguration configuration)
        {
            _configuration = configuration;
            _largeMessageRepository = new LargeMessageRepository(_configuration);
            var serviceBusProcessor = GetServiceBusProcessor(queueName, maxConcurrentCalls:1);
            serviceBusProcessor.ProcessMessageAsync += args => MessageHandler(args, processMessage, logger);
            serviceBusProcessor.ProcessErrorAsync += args => ServiceBusProcessor_ProcessErrorAsync(args, logger);

            await serviceBusProcessor.StartProcessingAsync();
        }

        private static Task ServiceBusProcessor_ProcessErrorAsync(ProcessErrorEventArgs arg, ILogger logger)
        {
            logger.LogError(1, $"Listening to the audit queue has failed: {arg.Exception.Message}, {arg.Exception.StackTrace}, {arg.EntityPath}");

            return Task.CompletedTask;
        }

        static async Task MessageHandler(ProcessMessageEventArgs args, Action<FcsMessage> processMessage, ILogger logger)
        {
            try
            {
                var fcsMessage = args.Message.ToFcsMessage(GetMessageBody);

                processMessage(fcsMessage);

                // complete the message. messages is deleted from the queue. 
                await args.CompleteMessageAsync(args.Message);
            }
            catch (AggregateException ex)
            {
                ex.Flatten().InnerExceptions.ToList().ForEach(e =>
                {
                    if (e is DbUpdateException dbUpdateException)
                    {
                        if (dbUpdateException?.InnerException?.InnerException is SqlException sqlEx)
                        {
                            logger.LogError(1,
                                $"QueueListener::sql exception, message id: {args.Message.MessageId}, errorNum: {sqlEx.Number}, error: {sqlEx.Message}");
                            if (sqlEx.Number == UniqueConstraintViolation)
                            {
                                logger.LogError(1, $"QueueListener::DBUpdate this message has already been received, message id: {args.Message.MessageId}");
                                args.CompleteMessageAsync(args.Message).Wait();
                            }
                        }
                    }
                    else
                    {
                        logger.LogError(1, $"QueueListener::aggregate error has this type - {e.GetType()}, message id: {args.Message.MessageId}, {ex.Message}, {ex.StackTrace}");
                    }
                });
            }
            catch (Exception e)
            {
                e = e.GetBaseException();
                logger.LogError(1, $"QueueListener::error has this type - {e.GetType()}, message id: {args.Message.MessageId}");
                if (e is DbEntityValidationException exEf)
                {
                    var errorMessages = exEf.EntityValidationErrors
                        .SelectMany(x => x.ValidationErrors)
                        .Select(x => x.ErrorMessage);

                    var fullErrorMessage = String.Join("; ", errorMessages);
                    var exceptionMessage = String.Concat(exEf.Message, " The validation errors are: ", fullErrorMessage);
                    logger.LogError(1, $"QueueListener::Failed to process audit message EF - {exceptionMessage}");
                }
                else
                {
                    logger.LogError(1, $"QueueListener::Failed to process audit message - {e.Message}, {e.StackTrace}");
                }

                args.AbandonMessageAsync(args.Message).Wait();
            }
        }

        private static byte[] GetMessageBody(ServiceBusReceivedMessage message)
        {
            return message.IsFcsDataBusMessage() ?
                _largeMessageRepository.GetMessageBody(message.GetFcsDataBusKey()) : message.Body.ToArray();
        }

        private static ServiceBusProcessor GetServiceBusProcessor(string queueName, int maxConcurrentCalls)
        {
            var options = new ServiceBusProcessorOptions {MaxConcurrentCalls = maxConcurrentCalls, AutoCompleteMessages = false};

            return new ServiceBusClient(AzureServiceBusConnectionString).CreateProcessor(queueName, options);
        }

        private static string AzureServiceBusConnectionString => _configuration["ConnectionStrings:NServiceBus/Transport"];
    }
}
