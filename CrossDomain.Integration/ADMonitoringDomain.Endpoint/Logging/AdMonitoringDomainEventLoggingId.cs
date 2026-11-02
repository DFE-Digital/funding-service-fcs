namespace ADMonitoringDomain.Endpoint.Logging
{
    using SFA.FCT.CrossDomain.Integration.Common;

    public static class AdMonitoringDomainEventLoggingId
    {
        public const int EventReceived = LoggingEventId.AllocationDeliveryMonitoringDomain;
        public const int EventMapped = LoggingEventId.AllocationDeliveryMonitoringDomain + 1;
        public const int EventStoredForFeed = LoggingEventId.AllocationDeliveryMonitoringDomain + 2;
        public const int VersionNumberOne = LoggingEventId.AllocationDeliveryMonitoringDomain + 3;
        public const int MappingError = LoggingEventId.AllocationDeliveryMonitoringDomain + 4;
        public const int EventHandled = LoggingEventId.AllocationDeliveryMonitoringDomain + 5;
        public const int GeneratingFeed = LoggingEventId.AllocationDeliveryMonitoringDomain + 6;
        public const int GeneratedFeed = LoggingEventId.AllocationDeliveryMonitoringDomain + 7;
        public const int VersionNumberLessThanOne = LoggingEventId.AllocationDeliveryMonitoringDomain + 8;
        public const int VersionNumberGreaterThanOne = LoggingEventId.AllocationDeliveryMonitoringDomain + 9;
        public const int AllocationPayOnProfile = LoggingEventId.AllocationDeliveryMonitoringDomain + 10;
        public const int AllocationIsNotPay = LoggingEventId.AllocationDeliveryMonitoringDomain +11;

    }
}
