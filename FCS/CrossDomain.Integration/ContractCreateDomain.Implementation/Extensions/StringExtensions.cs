namespace SFA.FCT.ContractCreateDomain.Implementation.Extensions
{
    using System.Text.RegularExpressions;

    public static class StringExtensions
    {
        public static bool IsNullOrEmpty(this string test)
        {
            return string.IsNullOrEmpty(test);
        }

        public static string ToTextWithSpaceBeforeCapitals(this string value)
        {
            return Regex.Replace(value, "(?!^)([A-Z])", " $1");
        }
    }
}
