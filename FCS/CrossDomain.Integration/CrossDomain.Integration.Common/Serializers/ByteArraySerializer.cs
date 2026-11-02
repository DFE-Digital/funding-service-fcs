namespace SFA.FCT.CrossDomain.Integration.Common.Serializers
{
    using System.IO;
    using System.Runtime.Serialization.Formatters.Binary;

    public static class ByteArraySerializer
    {
        public static byte[] ConvertObjectToByteArray<T>(this T objectToSerialize)
        {
            MemoryStream memorystream = new MemoryStream();
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(memorystream, objectToSerialize);

            byte[] serializedResult = memorystream.ToArray();

            return serializedResult;
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
