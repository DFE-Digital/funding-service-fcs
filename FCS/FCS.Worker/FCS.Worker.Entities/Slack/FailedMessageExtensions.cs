namespace SFA.FCS.Worker.Common.Slack
{
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus.Faults;

    public static class FailedMessageExtensions
    {
        public static ErrorMessage ToErrorMessage(this FailedMessage failedMessage, string environmentName, string service)
        {
            IReadOnlyCollection<string> headerKeys = new List<string>
            {
                "NServiceBus.ProcessingEndpoint",
                "NServiceBus.ExceptionInfo.Message",
                "NServiceBus.OriginatingEndpoint"
            };

            var values = headerKeys.Select(k => DictionaryExtensions.GetTextAndValueIfPresent(failedMessage.Headers, k))
                .Where(v => v != null)
                .ToList();

            var formattedText = $"({environmentName}) " + string.Join(", ", values);

            return new ErrorMessage(service:service, formattedText);
        }
    }
}
