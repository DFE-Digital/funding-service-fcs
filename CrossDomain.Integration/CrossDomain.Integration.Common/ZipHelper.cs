namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System.IO;
    using System.IO.Compression;
    using Serializers;

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

        public static string ToStringFromZippedBytes(byte[] bytes)
        {
            using (GZipStream bigStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
            {
                MemoryStream bigStreamOut = new MemoryStream();
                bigStream.CopyTo(bigStreamOut);
                return bigStreamOut.ToArray().ConvertByteArrayToObject<string>();
            }
        }

        public static byte[] ToZippedBytesFromBytes(byte[] bytes)
        {
            MemoryStream memoryStream = new MemoryStream(bytes);
            MemoryStream outStream = new MemoryStream();

            using (GZipStream tinyStream = new GZipStream(outStream, CompressionMode.Compress))
            {
                memoryStream.CopyTo(tinyStream);
            }

            return outStream.ToArray();
        }

        public static byte[] ToBytesFromZippedBytes(byte[] zippedBytes)
        {
            using (GZipStream bigStream = new GZipStream(new MemoryStream(zippedBytes), CompressionMode.Decompress))
            {
                MemoryStream bigStreamOut = new MemoryStream();
                bigStream.CopyTo(bigStreamOut);
                return bigStreamOut.ToArray();
            }
        }
    }
}
