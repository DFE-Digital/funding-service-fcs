namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    public static class StringExtensions
    {
        public static bool IsEqual(this string text, string otherValue)
        {
            return text != null && string.Equals(text, otherValue, StringComparison.CurrentCultureIgnoreCase);
        }

        public static bool HasValue(this string text)
        {
            return !string.IsNullOrEmpty(text);
        }

        public static bool IsEmpty(this string text)
        {
            return string.IsNullOrEmpty(text);
        }

        public static string ToMd5Hash(this IEnumerable<string> strings)
        {
            using var md5 = System.Security.Cryptography.MD5.Create();

            var concatenatedString = string.Join(",", strings.OrderBy(s => s.ToUpper()));
            var inputBytes = Encoding.ASCII.GetBytes(concatenatedString);
            var hashBytes = md5.ComputeHash(inputBytes);
            var hexadecimalString = BitConverter.ToString(hashBytes);

            return hexadecimalString;
        }
    }
}
