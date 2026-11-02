namespace ContractRequestDomain.Cfs.Common
{
    public class ContractRequestCfsLoggingEvents
    {
        private const int LoggingEventIdContractRequestDomain = 1800;

        public const int CreateAllocationCommandReceived = LoggingEventIdContractRequestDomain + 30;
        public const int CreateAllocationCommandProcessed = LoggingEventIdContractRequestDomain + 31;
        public const int PollNotificationFeedCommandReceived = LoggingEventIdContractRequestDomain + 32;
        public const int PollNotificationFeedCommandProcessed = LoggingEventIdContractRequestDomain + 33;
        public const int ProcessNewAllocationNotificationsCommandReceived = LoggingEventIdContractRequestDomain + 34;
        public const int ProcessNewAllocationNotificationsCommandProcessed = LoggingEventIdContractRequestDomain + 35;
        public const int AllocationCreatedEventEventReceived = LoggingEventIdContractRequestDomain + 36;
        public const int AllocationCreatedEventEventProcessed = LoggingEventIdContractRequestDomain + 37;
        public const int AllocationNotificationsRetrieved = LoggingEventIdContractRequestDomain + 38;
        public const int InitiateCfsAllocationReleaseCommandReceived = LoggingEventIdContractRequestDomain + 39;
        public const int InitiateCfsAllocationReleaseCommandProcessed = LoggingEventIdContractRequestDomain + 40;
        public const int DocumentGenerationCompleteCommandReceived = LoggingEventIdContractRequestDomain + 41;
        public const int DocumentGenerationCompleteCommandProcessed = LoggingEventIdContractRequestDomain + 42;
    }
}