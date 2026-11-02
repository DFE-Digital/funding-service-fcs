namespace Operations.Web.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text.Json;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Operations.Web.Dtos;
    using Operations.Web.Infrastructure;
    using Operations.Web.Repositories;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;

    [RoutePrefix("replayFailedMessage")]
    public class ReplayFailedMessageController : ApiController
    {
        private readonly IAzureServiceBusQueueService _azureServiceBusQueueServiceRepository;
        public static ILogger Logger { get; set; }
        private readonly ITransportMessageSender _messageSender;
        public ReplayFailedMessageController(IAzureServiceBusQueueService azureServiceBusQueueService, ITransportMessageSender messageSender)
        {
            _azureServiceBusQueueServiceRepository = azureServiceBusQueueService;
            _messageSender = messageSender;
        }

        [HttpGet, Route("fetchmessagesfromqueue")]
        
        public async Task<IHttpActionResult> FetchMessagesFromQueue()
        {

            ErrorQueueContract result = await _azureServiceBusQueueServiceRepository.FetchMessagesFromQueue("contractmanagementdomain.confirmpublicationtoprovider.error", 100);
            
            return Ok(result);
        }

      
        [HttpPost, Route("rerunselectedfailedmessages")]

        public async Task<IHttpActionResult> ReRunSelectedFailedMessages(List<ErrorMessage> items)
        {
            Logger = new LoggerNullObject();
            Logger.LogInformation($"total message received  : {items.Count()}");
            //Rerun and Remove the failed test case from Error Queue
            ErrorQueueContract failedMessages = new ErrorQueueContract();
            failedMessages.QueueName = "contractmanagementdomain.confirmpublicationtoprovider";
            failedMessages.lstContract = items;
            await _azureServiceBusQueueServiceRepository.ReRunFailedMessagesFromQueue(failedMessages, _messageSender);
            return Ok(Task.CompletedTask);
        }

    }
}