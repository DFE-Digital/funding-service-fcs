namespace AllocationDeliveryService.Tests
{
    using System.IO;
    using System.IO.Compression;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;

    public static class ZipHelper
    {
        public static byte[] ToZippedBytesFromString(string str)
        {
            MemoryStream memoryStream = new MemoryStream(str.ConvertObjectToByteArray());
            MemoryStream outStream = new MemoryStream();

            using (GZipStream tinyStream = new GZipStream(outStream, CompressionMode.Compress))
            {
                memoryStream.CopyTo(tinyStream);
            }

            return outStream.ToArray();
        }
    }
}
