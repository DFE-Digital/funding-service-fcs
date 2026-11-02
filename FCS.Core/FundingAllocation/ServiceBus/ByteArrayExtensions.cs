namespace FundingAllocation.ServiceBus
{
    using System.Linq;

    public static class ByteArrayExtensions
    {
        public static bool IsZipped(this byte[] data)
        {
            byte[] gzipHeaderBytes = { 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 4, 0 };
            byte[] gzipHeaderBytesAlt = new byte[] { 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 0, 10 }; // GZipStream from .net core has a different header

            if (data != null && data.Length >= gzipHeaderBytes.Length)
            {
                var header = data.Take(gzipHeaderBytes.Length);

                return header.SequenceEqual(gzipHeaderBytes) || header.SequenceEqual(gzipHeaderBytesAlt);
            }

            return false;
        }
    }
}
