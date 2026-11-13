namespace SFA.FCT.ContractRequestDomain.DataStore.Extensions
{
    public static class StringExtensions
    {
        public static bool HasValue(this string text)
        {
            return !string.IsNullOrEmpty(text);
        }
    }
}