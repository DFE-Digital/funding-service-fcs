namespace Operations.Worker.Slack
{
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus.Faults;
    using Extensions;

    public static class FailedMessageExtensions
    {
        public static SlackMessage ToErrorMessage(this FailedMessage failedMessage, string environmentName)
        {
            IReadOnlyCollection<string> headerKeys = new List<string>
            {
                "NServiceBus.ProcessingEndpoint",
                "NServiceBus.ExceptionInfo.Message",
                "NServiceBus.OriginatingEndpoint",
                "NServiceBus.FailedQ"
            };

            var values = headerKeys.Select(k => GetHeaderTextAndValueIfPresent(failedMessage.Headers, k))
                .Where(v => v != null)
                .ToList();

            var formattedText = $"({environmentName}) " + string.Join(System.Environment.NewLine, values);

            return new SlackMessage(formattedText);
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