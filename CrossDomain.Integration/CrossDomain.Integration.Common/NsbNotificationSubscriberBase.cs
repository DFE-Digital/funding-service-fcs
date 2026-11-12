using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using NServiceBus;
using SFA.FCT.Framework.Logging.Interfaces;

namespace SFA.FCT.CrossDomain.Integration.Common
{
    /// <summary>
    /// Base class for handling error notifications via custom recoverability policy.
    /// </summary>
    public abstract class NsbNotificationSubscriberBase
    {
        private readonly ILogger _logger;

        protected NsbNotificationSubscriberBase(ILogger logger)
        {
            _logger = logger;
        }

        /// <summary>
        /// List of specific message types to match for custom event logging.
        /// </summary>
        public virtual IReadOnlyCollection<Type> SpecificMessageTypes => new List<Type>();

        /// <summary>
        /// Event ID to use when a specific message type is matched.
        /// </summary>
        public abstract int SpecificEventId { get; }

        /// <summary>
        /// Handles error notification from recoverability policy.
        /// </summary>
        /// <param name="errorContext">Error context from recoverability pipeline.</param>
        //public Task HandleErrorNotification(IErrorContext errorContext)
        //{
        //    var headers = errorContext.Headers;

        //    var properties = new
        //    {
        //        MessageType = headers.TryGetValue("NServiceBus.EnclosedMessageTypes", out var mt) ? mt : "",
        //        MessageId = headers.TryGetValue("NServiceBus.MessageId", out var mid) ? mid : "",
        //        OriginatingMachine = headers.TryGetValue("NServiceBus.OriginatingMachine", out var om) ? om : "",
        //        OriginatingEndpoint = headers.TryGetValue("NServiceBus.OriginatingEndpoint", out var oe) ? oe : "",
        //        ExceptionType = headers.TryGetValue("NServiceBus.ExceptionInfo.ExceptionType", out var et) ? et : "",
        //        ExceptionMessage = headers.TryGetValue("NServiceBus.ExceptionInfo.Message", out var em) ? em : "",
        //        ExceptionSource = headers.TryGetValue("NServiceBus.ExceptionInfo.Source", out var es) ? es : "",
        //        TimeSent = headers.TryGetValue("NServiceBus.TimeSent", out var ts) ? ts : ""
        //    };

        //    int eventId = CommonLoggingEventId.FCSOperationsErrorCode;

        //    if (SpecificMessageTypes.Any(t => properties.MessageType.Contains(t.Name)))
        //    {
        //        eventId = SpecificEventId;
        //    }

        //    string exceptionMessage = string.Join(", ", properties.GetType().GetProperties()
        //        .Select(p => $"{p.Name}: {p.GetValue(properties)}"));

        //    _logger.LogError(eventId, $"Message sent to Error Queue: {exceptionMessage}");

        //    return Task.CompletedTask;
        //}
    }
}
