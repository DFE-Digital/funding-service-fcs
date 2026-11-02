namespace Operations.DataStore.Model
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.IO;
    using System.IO.Compression;
    using System.Runtime.Serialization.Formatters.Binary;
    using Extensions;
    using Newtonsoft.Json;

    public class AuditMessage
    {
        private AuditMessage()
        {
        }

        public AuditMessage(
            byte[] messageBytes,
            string messageType,
            DateTime sentTime,
            Guid messageId,
            string originatingEndpoint,
            string processingEndpoint,
            string businessKey,
            byte[] propertiesBytes)
        {
            MessageBytes = messageBytes;
            MessageType = messageType;
            SentTime = sentTime;
            MessageId = messageId;
            OriginatingEndpoint = originatingEndpoint;
            ProcessingEndpoint = processingEndpoint;
            BusinessKey = businessKey;
            PropertiesBytes = propertiesBytes;
        }

        [Key, Column(Order = 0)]
        public Guid MessageId { get; private set; }

        /// <summary>
        /// this is a a fully qualified type name
        /// </summary>
        [Index("IX_AuditMessage_MessageType", IsUnique = false)]
        [MaxLength(120), Required]
        public string MessageType { get; private set; }

        [Required]
        public DateTime SentTime { get; private set; }

        [MaxLength(100), Required]
        public string OriginatingEndpoint { get; private set; }

        [Key, Column(Order = 2), MaxLength(100), Required]
        public string ProcessingEndpoint { get; private set; }

        [MaxLength(80), Required]
        public string BusinessKey { get; private set; }

        [Required]
        public byte[] MessageBytes { get; private set; }

        [Required]
        public byte[] PropertiesBytes { get; private set; }

        public string GetMessageAsJson()
        {
            byte[] unzippedBytes = GetUnZippedBytes(MessageBytes);

            return GetStringFromBytes(unzippedBytes);
        }

        public IReadOnlyDictionary<string, object> GetPropertiesDictionary()
        {
            var dictionary = ConvertByteArrayToObject<ReadOnlyDictionary<string, object>>(PropertiesBytes);
            
            return dictionary;
        }

        private static byte[] GetUnZippedBytes(byte[] messageBytes)
        {
            if (messageBytes.IsZipped())
            {
                using (GZipStream bigStream = new GZipStream(new MemoryStream(messageBytes), CompressionMode.Decompress))
                {
                    MemoryStream unZippedStream = new MemoryStream();
                    bigStream.CopyToAsync(unZippedStream).Wait();

                    return unZippedStream.ToArray();
                }
            }

            return messageBytes;
        }

        private static string GetStringFromBytes(byte[] bytes)
        {
            using (MemoryStream ms = new MemoryStream(bytes))
            {
                using (StreamReader sr = new StreamReader(ms))
                {
                    return sr.ReadToEnd();
                }
            }
        }

        public static T ConvertByteArrayToObject<T>(byte[] bytes)
        {
            MemoryStream memorystream = new MemoryStream(bytes);
            BinaryFormatter bfd = new BinaryFormatter();
            T deserializedResult = (T)bfd.Deserialize(memorystream);
            return deserializedResult;
        }
    }
}
