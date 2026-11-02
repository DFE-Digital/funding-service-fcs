namespace Datafix.Tests.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;

    public static class NsbMessagesDeserializer
    {
        public static IReadOnlyCollection<T> DeserializeMessagesFromFile<T>(string fileName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream(fileName))
            using (var streamReader = new StreamReader(stream))
            {
                var text = streamReader.ReadToEnd();
                var messages = new List<T>();
                var array = JArray.Parse(text);
                foreach (var item in array)
                {
                    var messageBody = item["body"].ToString();
                    var message = JsonConvert.DeserializeObject<T>(messageBody);
                    messages.Add(message);
                }

                return messages;
            }
        }
    }
}
