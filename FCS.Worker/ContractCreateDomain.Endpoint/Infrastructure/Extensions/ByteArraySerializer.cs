namespace ContractCreateDomain.Endpoint.Infrastructure.Extensions
{
    using System.Text;
    using System.Text.Json;

    public static class ByteArraySerializer
    {
        private static readonly JsonSerializerOptions Options =
            new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
                WriteIndented = false
            };

        public static byte[] ConvertObjectToByteArray<T>(this T objectToSerialize)
        {
            if (objectToSerialize == null)
                return null;

            return Encoding.UTF8.GetBytes(
                JsonSerializer.Serialize(objectToSerialize, Options));
        }

        public static T ConvertByteArrayToObject<T>(this byte[] blob)
        {
            if (blob == null || blob.Length == 0)
                return default;

            return JsonSerializer.Deserialize<T>(
                Encoding.UTF8.GetString(blob),
                Options);
        }
    }
}
