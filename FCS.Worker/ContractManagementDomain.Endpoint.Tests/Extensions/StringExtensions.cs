
namespace ContractManagementDomain.Endpoint.Tests.Extensions
{
    using System;

    internal static class StringExtensions
    {
        internal static string TrimInvisibleChars(this string text)
        {
            return text.Replace(Environment.NewLine, string.Empty).Replace("\t", string.Empty);
        }

    }
}
