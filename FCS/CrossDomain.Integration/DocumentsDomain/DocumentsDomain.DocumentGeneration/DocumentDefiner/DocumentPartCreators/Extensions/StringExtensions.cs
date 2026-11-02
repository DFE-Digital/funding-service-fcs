namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Extensions
{
    public static class StringExtensions
    {
        public static string GetValueOrDefault(this string text, string defaultText)
        {
            if (string.IsNullOrEmpty(text))
            {
                return defaultText;
            }

            return text;
        }

        public static string AddPrefixIfNotEmpty(this string text, string prefixText)
        {
            if (text.HasValue())
            {
                return prefixText + text;
            }

            return text;
        }

        public static bool HasValue(this string text)
        {
            return !string.IsNullOrEmpty(text);
        }
    }
}
