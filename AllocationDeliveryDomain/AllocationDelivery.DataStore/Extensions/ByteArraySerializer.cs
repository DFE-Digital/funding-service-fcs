namespace SFA.FCT.AllocationDelivery.DataStore.Extensions
{
    using System;
    using System.Text.Json;

    public static class ByteArraySerializer
    {
        private static readonly JsonSerializerOptions _jsonOptions = new()
        {
            WriteIndented = false,            
        };

        public static byte[] ConvertObjectToByteArray<T>(this T objectToSerialize)
        {           
            return JsonSerializer.SerializeToUtf8Bytes(objectToSerialize, _jsonOptions);
        }

        public static T? ConvertByteArrayToObject<T>(this byte[] blob)
        {
            if (blob == null || blob.Length == 0) return default;
            return JsonSerializer.Deserialize<T>(blob, _jsonOptions);
        }
    }
}
