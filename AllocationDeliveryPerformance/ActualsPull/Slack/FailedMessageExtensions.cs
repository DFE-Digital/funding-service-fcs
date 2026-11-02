namespace ActualsPull.Slack
{
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using NServiceBus.Faults;

    public static class FailedMessageExtensions
    {
        public static ErrorMessge ToErrorMessage(this FailedMessage failedMessage)
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

            string formattedText = string.Join(System.Environment.NewLine, values);

            return new ErrorMessge(formattedText);
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
