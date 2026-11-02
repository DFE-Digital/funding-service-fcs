namespace SFA.FCT.Operations.MessageReplay.Endpoint.Services.Stubs
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Common.DTOs;
    using Common.Services;

    public class StubQueueQueryService : IQueueQueryService
    {
        private const string MessageType = "SFA.Common.Interfaces.Events.IOrganisationDetailsChanged";
        private const string EndpointName = "OrgService.Main";
        private const string JsonResourceName = @"SFA.FCT.Operations.MessageReplay.Endpoint.Services.Stubs.Resources.IOrganisationDetailsChanged.json";

        public MessageDetail GetMessageDetail(string queueName, string messageId)
        {
            return new MessageDetail(
                messageId: messageId,
                messageType: MessageType,
                messageBody: GetMessageBodyFromResource(),
                endpointName: EndpointName);
        }

        public IList<MessageDetail> GetMessageDetails(string queueName, string messageType, DateTime timeRangeStartUtc, DateTime timeRangeEndUtc, long fromSequenceNo, Func<MessageDetail, bool> matchMessage)
        {
            throw new NotImplementedException();
        }

        public long GetQueueSizeInBytes(string queueName)
        {
            throw new NotImplementedException();
        }

        private static string GetMessageBodyFromResource()
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(JsonResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }
    }
}