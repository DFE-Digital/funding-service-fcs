namespace ContractManagementService.Infrastructure
{
    using System.IO;
    using System.IO.Compression;
    using System.Runtime.Serialization.Formatters.Binary;

    public static class ZipHelper
    {
        public static string ToStringFromZippedBytes(byte[] bytes)
        {
            using (GZipStream bigStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
            {
                MemoryStream bigStreamOut = new MemoryStream();
                bigStream.CopyTo(bigStreamOut);
                return bigStreamOut.ToArray().ConvertByteArrayToObject<string>();
            }
        }

        public static T ConvertByteArrayToObject<T>(this byte[] blob)
        {
            MemoryStream memorystream = new MemoryStream(blob);
            BinaryFormatter bfd = new BinaryFormatter();
            T deserializedResult = (T)bfd.Deserialize(memorystream);

            return deserializedResult;
        }
    }
}
