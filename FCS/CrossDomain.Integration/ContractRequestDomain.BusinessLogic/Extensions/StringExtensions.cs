namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Extensions
{
    using System;
    public static class StringExtensions
    {
        public static string Truncate(this string str, int maxLength)
        {
            int length = Math.Min(str.Length, maxLength);
            return str.Substring(0, length);
        }
    }
}
