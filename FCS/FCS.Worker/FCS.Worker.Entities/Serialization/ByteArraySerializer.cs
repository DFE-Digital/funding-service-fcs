namespace SFA.FCS.Worker.Common.Serialization
{
    using System.IO;
    using System.Runtime.Serialization.Formatters.Binary;

    public static class ByteArraySerializer
    {
        public static byte[] ConvertToByteArray<T>(T objectToSerialize)
        {
            MemoryStream memorystream = new MemoryStream();
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(memorystream, objectToSerialize);

            byte[] serializedResult = memorystream.ToArray();

            return serializedResult;
        }
    }
}
