namespace SFA.FCT.Operations.Common.Services
{
    using System;
    using System.Collections.Generic;
    using DTOs;

    public interface IQueueQueryService
    {
        MessageDetail GetMessageDetail(string queueName, string messageId);

        IList<MessageDetail> GetMessageDetails(string queueName, string messageType, DateTime timeRangeStartUtc, DateTime timeRangeEndUtc, long fromSequenceNo, Func<MessageDetail, bool> matchMessage);

        long GetQueueSizeInBytes(string queueName);
    }
}
