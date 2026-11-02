namespace SFA.FCT.ContractManagementService
{
    using System;
    using System.IO;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml;
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Mvc.Formatters;
    using Task = System.Threading.Tasks.Task;

    public class AtomMediaTypeFormatter : TextOutputFormatter
    {
        private const string AtomJsonMediaType = "application/atom+json";

        public AtomMediaTypeFormatter()
        {
            SupportedMediaTypes.Add(AtomJsonMediaType);
        }

        protected override bool CanWriteType(Type type)
        {
            return type == typeof(SyndicationFeed);
        }

        public override async Task WriteResponseBodyAsync(
            OutputFormatterWriteContext context, Encoding selectedEncoding)
        {
            var httpContext = context.HttpContext;
            var serviceProvider = httpContext.RequestServices;

            var memoryStream = new MemoryStream();

            if (context.Object is SyndicationFeed)
            {
                BuildAtomFeed(context.Object, memoryStream);
                var text = System.Text.Encoding.UTF8.GetString(memoryStream.ToArray());
                await httpContext.Response.WriteAsync(text, selectedEncoding);
            }
            else
            {
                await Task.FromResult<object>(null);
            }
        }

        private void BuildAtomFeed(object value, Stream stream)
        {
            if (value is SyndicationFeed feed)
            {
                SyndicationFeedFormatter formatter = new Atom10FeedFormatter(feed);
                
                SerializeToXml(stream, formatter);
            }
        }

        private bool IsMediaTypeAtomXml(string mediaType)
        {
            return AtomMediaTypeFilterHandler.SupportedMediaTypes.Contains(mediaType.ToUpper());
        }

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