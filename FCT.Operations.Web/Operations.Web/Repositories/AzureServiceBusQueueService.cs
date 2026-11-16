
using Azure.Messaging.ServiceBus;
using Azure.Messaging.ServiceBus.Administration;
namespace Operations.Web.Repositories
{
    extern alias CMService;
    using System.Threading.Tasks;
    using Azure.Messaging.ServiceBus;
    using Azure.Messaging.ServiceBus.Administration;
    using System.Text;
    using Newtonsoft.Json;
    using System.Collections.Generic;
    using System.Text.RegularExpressions;
    using System.Linq;
    using NServiceBus;
    using System.IO;
    using System;
    using CMService::SFA.FCT.ContractManagementService.Common.Commands;
    using Operations.Web.Dtos;
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Operations.Web.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using Microsoft.Azure.Amqp.Framing;
    using System.Configuration;

    public class AzureServiceBusQueueService : IAzureServiceBusQueueService
    {
        //private readonly IFcsConfiguration _configuration;
        public static ILogger Logger { get; set; }
        private string AzureServiceBusConnectionString =>ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
        public AzureServiceBusQueueService()
        {

        }

        public async Task<long> GetQueueSizeInBytes(string queueName)
        {
            var client = new ServiceBusAdministrationClient(AzureServiceBusConnectionString);
            var runtimeProperties = (await client.GetQueueRuntimePropertiesAsync(queueName)).Value;

            return runtimeProperties.ActiveMessageCount;
        }


        public async Task<ErrorQueueContract> FetchMessagesFromQueue(string queueName, int numberOfMessagesToFetch)
        {
            ErrorQueueContract lst = new ErrorQueueContract();
            List<ErrorMessage> clist = new List<ErrorMessage>();
            var receiver = FetchServiceBusReceiver(queueName);
            //
            var allMessages = new List<ServiceBusReceivedMessage>();
            int batchSize = 100;
            int remainingMessages = batchSize;
            int retryCount = 0;
            while (remainingMessages > 0)
            {
                IEnumerable<ServiceBusReceivedMessage> receivedMessages = await receiver.ReceiveMessagesAsync(maxMessages: remainingMessages, maxWaitTime: TimeSpan.FromSeconds(10));

                if (receivedMessages != null && receivedMessages.Any())
                {
                    allMessages.AddRange(receivedMessages);
                    remainingMessages -= receivedMessages.Count();
                }
                else
                {
                    if (!allMessages.Any() && retryCount < 10)
                    {
                        retryCount++;
                        continue;
                    }
                    break; // Exit the loop if no more messages are available
                }
            }
             await receiver.CloseAsync();

            lst.QueueName = receiver.EntityPath.Replace(".error", "");
            //var Queueresult = await receiver.ReceiveMessagesAsync(numberOfMessagesToFetch, maxWaitTime: TimeSpan.FromSeconds(30));
            if (allMessages.Any())
            {
                foreach (var result in allMessages)
                {

                    string base64Message = Encoding.UTF8.GetString(result.Body.ToArray());
                    string JsonMessage = ExtractJsonFromBase64(base64Message);

                    if (!string.IsNullOrEmpty(JsonMessage))
                    {
                        ErrorMessage contract = new ErrorMessage();
                        contract.MessageBody = JsonMessage;
                        contract.MessageId = result.MessageId;
                        contract.CompleteDate = result.EnqueuedTime.DateTime;
                        clist.Add(contract);
                    }
                }
                lst.lstContract = clist;
            }
            return lst;
        }

        private static string RemoveNonPrintableCharacters(string input)
        {
            StringBuilder cleaned = new StringBuilder();
            foreach (char c in input)
            {
                if (!char.IsControl(c) || c == '\t' || c == '\n' || c == '\r')
                {
                    cleaned.Append(c);
                }
            }
            return cleaned.ToString();
        }

        private string ExtractJsonFromBase64(string inputstr)
        {
            if (string.IsNullOrEmpty(inputstr))
            {
                return null;
            }
            string input = RemoveNonPrintableCharacters(inputstr);
            int startIndex = input.IndexOf('{');
            int endIndex = input.LastIndexOf('}');

            if (startIndex >= 0 && endIndex > startIndex)
            {
                return Regex.Replace(input.Substring(startIndex, endIndex - startIndex + 1), @"[^\u0000-\u007F]+", string.Empty);
            }
            else
            {
                return null;
            }
        }

        private ServiceBusReceiver FetchServiceBusReceiver(string queueName)
        {
            var options = new ServiceBusReceiverOptions { ReceiveMode = ServiceBusReceiveMode.PeekLock };

            return new ServiceBusClient(AzureServiceBusConnectionString).CreateReceiver(queueName, options);
        }

        private ServiceBusReceiver GetServiceBusReceiver(string queueName)
        {
            var options = new ServiceBusReceiverOptions { ReceiveMode = ServiceBusReceiveMode.ReceiveAndDelete };

            return new ServiceBusClient(AzureServiceBusConnectionString).CreateReceiver(queueName, options);
        }

        public async Task ReRunFailedMessagesFromQueue(ErrorQueueContract failedMessages, ITransportMessageSender messageSender)
        {
            Logger = new LoggerNullObject();
            Logger.LogInformation($"ReRunFailedMessagesFromQueue received  : {failedMessages.lstContract.Count()}");
            
            foreach (var messages in failedMessages.lstContract)
            {
                Logger.LogInformation($"ReRunFailedMessagesFromQueue process message body  : {messages.MessageBody}");
                
                ConfirmPublicationToProviderCommand contractCmd = JsonConvert.DeserializeObject<ConfirmPublicationToProviderCommand>(messages.MessageBody);
                await messageSender.Send(command: contractCmd, destination: failedMessages.QueueName);
  
            }
            if (failedMessages.lstContract.Any())
            {
                //Deleted Messages from Queue which is retriggered
                await DeleteMessagesFromQueue("contractmanagementdomain.confirmpublicationtoprovider.error", failedMessages.lstContract);
                Logger.LogInformation($"Deleted process message body  : {failedMessages.lstContract.Count()}");
            }
        }

        public async Task DeleteMessagesFromQueue(string queueName, List<ErrorMessage> lstContract)
        {
            List<string> messagesIds = new List<string>();
            messagesIds = lstContract.Select(x => x.MessageId).ToList();
            var receiver = FetchServiceBusReceiver(queueName);
            var allMessages = new List<ServiceBusReceivedMessage>();
            int batchSize = 100;
            int remainingMessages = batchSize;
            int retryCount = 0;
            while (remainingMessages > 0)
            {
                IEnumerable<ServiceBusReceivedMessage> receivedMessages = await receiver.ReceiveMessagesAsync(maxMessages: remainingMessages, maxWaitTime: TimeSpan.FromSeconds(15));

                if (receivedMessages != null && receivedMessages.Any())
                {
                    allMessages.AddRange(receivedMessages);
                    remainingMessages -= receivedMessages.Count();
                    foreach (ServiceBusReceivedMessage message in receivedMessages)
                    {
                        if (messagesIds.Contains(message.MessageId))
                        {
                            await receiver.CompleteMessageAsync(message);
                        }
                    }
                }
                else
                {
                    if (!allMessages.Any() && retryCount < 15)
                    {
                        retryCount++;
                        continue;
                    }
                    break; // Exit the loop if no more messages are available
                }
            }
            await receiver.CloseAsync();

        }

        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            EndpointConfiguration endpointConfiguration =
                new EndpointConfiguration("TestSendingEndpoint");

            endpointConfiguration.SendOnly();

            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            string[] assembliesToExclude =
                Directory.EnumerateFiles(
                    AppDomain.CurrentDomain.BaseDirectory,
                    "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner =
                endpointConfiguration.AssemblyScanner();

            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<SystemJsonSerializer>();

            return Endpoint.Start(endpointConfiguration)
                .GetAwaiter()
                .GetResult();
        }

    }
}