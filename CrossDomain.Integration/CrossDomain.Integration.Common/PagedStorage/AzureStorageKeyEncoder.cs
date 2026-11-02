namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    using System.Linq;

    public static class AzureStorageKeyEncoder
    {
        /// <remarks>
        /// Disallowed characters as defined by https://msdn.microsoft.com/library/azure/dd179338.aspx
        /// </remarks>
        public static string Encode(string keyToEncode)
        {
            var disallowedChars = new[] { '/', '\\', '#', '?' };

            return new string(
                keyToEncode
                    .Where(ch => !char.IsControl(ch))
                    .Select(ch => !disallowedChars.Contains(ch) ? ch : '_')
                    .ToArray());
        }
    }
}
