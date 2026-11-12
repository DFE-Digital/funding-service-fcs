namespace SFA.FCT.CrossDomain.Integration.Common.Serializers
{
    using System.IO;
    using System.Text.Json;

    public static class ByteArraySerializer
    {
        public static byte[] ConvertObjectToByteArray<T>(this T objectToSerialize)
        {
            return JsonSerializer.SerializeToUtf8Bytes(objectToSerialize);
        }

        public static T ConvertByteArrayToObject<T>(this byte[] blob)
        {
            return JsonSerializer.Deserialize<T>(blob);
        }
    }
}
