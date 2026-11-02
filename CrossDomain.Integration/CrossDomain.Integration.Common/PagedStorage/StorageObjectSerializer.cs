namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    using System.IO;
    using System.IO.Compression;
    using System.Runtime.Serialization.Formatters.Binary;

    public class StorageObjectSerializer : IStorageObjectSerializer
    {
        public byte[] Serialize(object obj)
        {
            using (var memoryStream = new MemoryStream())
            {
                using (var compresser = new GZipStream(memoryStream, CompressionMode.Compress))
                {
                    BinaryFormatter binaryFormatter = new BinaryFormatter();
                    binaryFormatter.Serialize(compresser, obj);
                }

                return memoryStream.ToArray();
            }
        }

        public T Deserialize<T>(byte[] bytes)
        {
            var memoryStream = new MemoryStream(bytes);
            using (var decompressor = new GZipStream(memoryStream, CompressionMode.Decompress))
            {
                // The next line will throw SerializationException
                BinaryFormatter binaryFormatter = new BinaryFormatter();
                return (T)binaryFormatter.Deserialize(decompressor);
            }
        }
    }
}
