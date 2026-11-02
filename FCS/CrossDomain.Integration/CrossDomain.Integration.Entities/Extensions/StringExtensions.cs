namespace SFA.FCT.CrossDomain.Integration.Entities.Extensions
{
    internal static class StringExtensions
    {
        public static bool HasValue(this string text)
        {
            return !string.IsNullOrEmpty(text);
        }
    }
}
