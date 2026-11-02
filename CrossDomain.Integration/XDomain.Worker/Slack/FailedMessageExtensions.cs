namespace SFA.FCT.CrossDomain.Integration.Azure.Worker.Slack
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

            var values = headerKeys.Select(k => GetHeaderTextAndValueIfPresent(failedMessage.Headers, k))
                .Where(v => v != null)
                .ToList();

            var formattedText = $"({environmentName}) " + string.Join(", ", values);

            return new ErrorMessage(service: service, formattedText);
        }

        private static string GetHeaderTextAndValueIfPresent(Dictionary<string, string> dictionary, string key)
        {
            string valueText =
                dictionary.GetValueIfPresentOtherwiseNull(key);
            if (valueText != null)
            {
                return $"{key} : {valueText}";
            }

            return null;
        }
    }
}
