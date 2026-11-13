namespace SFA.FCS.Worker.Common.Serialization
{

    using System.IO;
    using ProtoBuf;

    public static class ByteArraySerializer
    {
        public static byte[] ConvertToByteArray<T>(T objectToSerialize)
        {
            using (var memoryStream = new MemoryStream())
            {
                Serializer.Serialize(memoryStream, objectToSerialize);
                return memoryStream.ToArray();
            }
        }
    }

}
