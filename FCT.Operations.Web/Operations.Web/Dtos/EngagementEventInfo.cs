namespace Operations.Web.Dtos
{
    using System;

    public class EngagementEventInfo
    {
        public EngagementEventInfo(long eventId, string providerId, DateTime createdDate, string processingState, string contractNumber)
        {
            EventId = eventId;
            ProviderId = providerId;
            CreatedDate = createdDate;
            ProcessingState = processingState;
            ContractNumber = contractNumber;
        }

        public long EventId { get; }

        public string ProviderId { get; }

        public DateTime CreatedDate { get; }

        public string ProcessingState { get; }

        public string ContractNumber { get; }
    }
}