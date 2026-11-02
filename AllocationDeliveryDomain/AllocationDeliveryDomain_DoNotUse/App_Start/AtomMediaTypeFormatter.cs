namespace SFA.FCT.AllocationDeliveryDomain
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Formatting;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using System.Xml;
    using Castle.Core.Internal;

    public class AtomMediaTypeFormatter : MediaTypeFormatter
    {
        private const string AtomJsonMediaType = "application/atom+json";

        public AtomMediaTypeFormatter()
        {
            // we don't support json at the moment
            AtomMediaTypeFilterHandler.SupportedMediaTypes.ForEach(smt => SupportedMediaTypes.Add(new MediaTypeHeaderValue(smt)));
        }

        public override bool CanReadType(Type type)
        {
            return type == typeof(SyndicationFeed);
        }

        public override bool CanWriteType(Type type)
        {
            return type == typeof(SyndicationFeed);
        }

        public override Task WriteToStreamAsync(Type type, object value, Stream writeStream, HttpContent content, TransportContext transportContext)
        {
            return Task.Factory.StartNew(() =>
            {
                if (type == typeof(SyndicationFeed))
                {
                    BuildAtomFeed(value, writeStream, content.Headers.ContentType.MediaType);
                }
            });
        }

        private void BuildAtomFeed(object value, Stream stream, string mediaType)
        {
            var feed = value as SyndicationFeed;

            if (feed != null)
            {
                SyndicationFeedFormatter formatter = new Atom10FeedFormatter(feed);
                if (IsMediaTypeAtomXml(mediaType))
                {
                    SerializeToXml(stream, formatter);
                }
                else if (string.Compare(mediaType, AtomJsonMediaType, StringComparison.OrdinalIgnoreCase) == 0)
                {
                    // we don't support json at the moment
                }
            }
        }

        private bool IsMediaTypeAtomXml(string mediaType)
        {
            return AtomMediaTypeFilterHandler.SupportedMediaTypes.Contains(mediaType.ToUpper());
        }

        ////private void SerializeToJson(Stream stream, SyndicationFeedFormatter formatter)
        ////{
        ////    JsonSerializer serializer = new JsonSerializer();
        ////    //using (var jsonTextWriter = new JsonTextWriter(new StreamWriter(stream)))
        ////    //{
        ////    //    serializer.Serialize(jsonTextWriter, formatter);
        ////    //    jsonTextWriter.Flush();    
        ////    //    jsonTextWriter.Close();
        ////    //}

        ////    // Make a stream to serialize into.

        ////    // Serialize into the stream.
        ////    //using (var jsonTextWriter = new JsonTextWriter(new StreamWriter(stream)))
        ////    //{
        ////    //    var streamWriter = new StreamWriter(stream, Encoding.UTF8);
        ////    //    serializer.Serialize(jsonTextWriter, formatter);
        ////    //    streamWriter.Flush();
        ////    //    stream.Position = 0;    
        ////    //}            
        ////}

        private void SerializeToXml(Stream stream, SyndicationFeedFormatter formatter)
        {
            using (var writer = XmlWriter.Create(stream))
            {
                formatter.WriteTo(writer);
                writer.Flush();
                writer.Close();
            }
        }
    }
}