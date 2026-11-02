namespace ContractManagementService.AtomFeed
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml;
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Mvc.Formatters;
    using Task = System.Threading.Tasks.Task;

    public class AtomOutputFormatter : TextOutputFormatter
    {
        public static readonly List<string> FcsAtomMediaTypes = new List<string>
        {
            "APPLICATION/ATOM+XML",
            "APPLICATION/VND.SFA.CONTRACT.V1+ATOM+XML",
            "APPLICATION/VND.SFA.ALLOCATION-DELIVERY.ALLOCATION-DELIVERY-PERFORMANCE.V1+ATOM+XML",
            "APPLICATION/VND.SFA.FUNDINGCLAIMRECONCILIATION.V1+ATOM+XML",
            "APPLICATION/VND.SFA.FUNDING-POLICY.DELIVERABLE.SETTING.V1+ATOM+XML",
            "APPLICATION/VND.SFA.PAYMENTREQUESTS.V1+ATOM+XML"
        };

        public AtomOutputFormatter()
        {
            FcsAtomMediaTypes.Select(mt => mt.ToLower()).ToList().ForEach(SupportedMediaTypes.Add);
            SupportedEncodings.Add(Encoding.UTF8);
            SupportedEncodings.Add(Encoding.Unicode);
        }

        protected override bool CanWriteType(Type type)
        {
            return type == typeof(SyndicationFeed);
        }

        public override async Task WriteResponseBodyAsync(OutputFormatterWriteContext context, Encoding selectedEncoding)
        {
            var httpContext = context.HttpContext;
            string text = string.Empty;

            if (context.Object is SyndicationFeed)
            {
                MemoryStream stream = new MemoryStream();
                BuildAtomFeed(context.Object, stream);
                stream.Flush();
                stream.Position = 0;
                StreamReader reader = new StreamReader(stream);
                text = await reader.ReadToEndAsync();
            }

            await httpContext.Response.WriteAsync(text, selectedEncoding);
        }

        private void BuildAtomFeed(object value, Stream stream)
        {
            if (value is SyndicationFeed feed)
            {
                SyndicationFeedFormatter formatter = new Atom10FeedFormatter(feed);
              
                SerializeToXml(stream, formatter);
            }
        }

        private void SerializeToXml(Stream stream, SyndicationFeedFormatter formatter)
        {
            using var writer = XmlWriter.Create(stream);
            formatter.WriteTo(writer);
            writer.Flush();
            writer.Close();
        }
    }
}
