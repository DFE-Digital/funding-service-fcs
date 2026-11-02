namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus;
    using Framework.Logging.Interfaces;
    using NServiceBus.Faults;

    public abstract class NsbNotificationSubscriberBase : IWantToRunWhenBusStartsAndStops, IDisposable
    {
        private readonly BusNotifications _busNotifications;
        private readonly ILogger _logger;
        private IDisposable _errorQueueSubscriber;

        protected NsbNotificationSubscriberBase(BusNotifications busNotifications, ILogger logger)
        {
            _busNotifications = busNotifications;
            _logger = logger;
        }

        public virtual IReadOnlyCollection<Type> SpecificMessageTypes
        {
            get
            {
                return new List<Type>();
            }
        }

        public abstract int SpecificEventId { get; }

        public void Start()
        {
            _errorQueueSubscriber = _busNotifications.Errors
                .MessageSentToErrorQueue
                .Subscribe(LogMessage);
        }

        private void LogMessage(FailedMessage message)
        {

            var properties = new
            {
                MessageType = message.Headers["NServiceBus.EnclosedMessageTypes"],
                MessageId = message.Headers["NServiceBus.MessageId"],
                OriginatingMachine = message.Headers["NServiceBus.OriginatingMachine"],
                OriginatingEndpoint = message.Headers["NServiceBus.OriginatingEndpoint"],
                ExceptionType = message.Headers["NServiceBus.ExceptionInfo.ExceptionType"],
                ExceptionMessage = message.Headers["NServiceBus.ExceptionInfo.Message"],
                ExceptionSource = message.Headers["NServiceBus.ExceptionInfo.Source"],
                TimeSent = message.Headers["NServiceBus.TimeSent"]
            };

            int eventId = CommonLoggingEventId.FCSOperationsErrorCode;

            string exceptionMessage = properties.ToString().Replace("}", "").Replace("{", "");

            if (SpecificMessageTypes.Any(specificMessageType => properties.MessageType.Contains(specificMessageType.Name)))
            {
                eventId = SpecificEventId;
            }

            _logger.LogError(eventId, "Message sent to Error Queue" + exceptionMessage);
        }

        public void Stop()
        {
            Dispose();
        }

        public void Dispose()
        {
            _errorQueueSubscriber.Dispose();
        }
    }
}
