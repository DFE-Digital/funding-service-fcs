namespace Datafix.Tests.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;

    public static class MessageDeserializer
    {
        public static IReadOnlyCollection<T> GetMessagesFromFile<T>(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                var text = streamReader.ReadToEnd();
                List<T> messageList = new List<T>();
                var array = JArray.Parse(text);
                foreach (var item in array)
                {
                    var messageBody = item["body"].ToString();
                    if (!IsMessageInAzureStorage(messageBody))
                    {
                        T deserializedMessage = JsonConvert.DeserializeObject<T>(messageBody);
                        messageList.Add(deserializedMessage);
                    }
                }

                return messageList;
            }
        }

        public static IReadOnlyCollection<(string messageBody, string messageProperties)> GetMessagesInAzureStorageFromFile<T>(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                var text = streamReader.ReadToEnd();
                var messageList = new List<(string messageBody, string messageProperties)>();
                var array = JArray.Parse(text);
                foreach (var item in array)
                {
                    var messageBody = item["body"].ToString();
                    if (IsMessageInAzureStorage(messageBody))
                    {
                        var properties = item["properties"].ToString();
                        messageList.Add((messageBody, properties));
                    }
                }

                return messageList;
            }
        }

        private static bool IsMessageInAzureStorage(string messageBody)
        {
            return messageBody.Contains("body-is-in-blob-storage");
        }
    }
}
