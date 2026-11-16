namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    using MessagePack;
    using System.IO;
    using System.IO.Compression;
    using System.Runtime.Serialization.Formatters.Binary;

    public class StorageObjectSerializer : IStorageObjectSerializer
    {

        public byte[] Serialize(Object obj)
        {
            var serialized = MessagePackSerializer.Serialize(obj);

            using (var memoryStream = new MemoryStream())
            {
                using (var compressor = new GZipStream(memoryStream, CompressionMode.Compress))
                {
                    compressor.Write(serialized, 0, serialized.Length);
                }

                return memoryStream.ToArray();
            }
        }

        public  T Deserialize<T>(byte[] bytes)
        {
            using (var memoryStream = new MemoryStream(bytes))
            using (var decompressor = new GZipStream(memoryStream, CompressionMode.Decompress))
            using (var decompressedStream = new MemoryStream())
            {
                decompressor.CopyTo(decompressedStream);
                var decompressedBytes = decompressedStream.ToArray();
                return MessagePackSerializer.Deserialize<T>(decompressedBytes);
            }
        }

    }
}
