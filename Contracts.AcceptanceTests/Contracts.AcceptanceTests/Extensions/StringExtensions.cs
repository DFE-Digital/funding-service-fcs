namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System;

    public static class StringExtensions
    {
        public static bool DoesNotContain(this string text, string textToSearchFor)
        {
            return !text.Contains(textToSearchFor);
        }

        public static string ToTitleCase(this string text)
        {
            return text.Substring(0, 1).ToUpper() + text.Substring(1).ToLower();
        }

        public static string ParseNullableString(this string s)
        {
            return s != "?" ? s : null;
        }

        public static T ParseEnum<T>(this string s)
        {
            return (T)Enum.Parse(typeof(T), s.RemoveSpacing());
        }

        public static string RemoveSpacing(this string s)
        {
            return s?.Replace(" ", "");
        }
    }
}
