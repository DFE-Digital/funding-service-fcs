namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Xml;
    using CrossDomain.Integration.Common.Atom;
    using DTO;

    public static class AtomFeedReader
    {
        public static IReadOnlyCollection<SyndicationFeed> ReadAllPages(string feedUri, AzureAuthenticationConfig authenticationConfig, string atomMediaType)
        {
            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", AzureAuthenticator.GetAuthenticationResult(authenticationConfig));
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(atomMediaType));

                string result = client.GetAsync(feedUri).Result.Content.ReadAsStringAsync().Result;

                List<SyndicationFeed> feedPages = new List<SyndicationFeed>();

                SyndicationFeed feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(result)));

                feedPages.Add(feed);

                SyndicationLink link;
                do
                {
                    link = feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.PreviousRelationship);

                    if (link != null)
                    {
                        result = client.GetAsync(link.Uri.ToString()).Result.Content.ReadAsStringAsync().Result;
                        feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(result)));
                        feedPages.Add(feed);
                    }
                }
                while (link != null);

                return feedPages;
            }
        }

        public static IEnumerable<SyndicationItem> EnumerateItems(string feedUri, AzureAuthenticationConfig authenticationConfig, string atomMediaType)
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", AzureAuthenticator.GetAuthenticationResult(authenticationConfig));
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(atomMediaType));

                string result = client.GetAsync(feedUri).Result.Content.ReadAsStringAsync().Result;

                SyndicationFeed page = SyndicationFeed.Load(new XmlTextReader(new StringReader(result)));

                foreach (SyndicationItem item in page.Items.Reverse())
                {
                    yield return item;
                }

                SyndicationLink link;
                do
                {
                    link = page.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.PreviousRelationship);

                    if (link != null)
                    {
                        result = client.GetAsync(link.Uri.ToString()).Result.Content.ReadAsStringAsync().Result;
                        page = SyndicationFeed.Load(new XmlTextReader(new StringReader(result)));

                        foreach (SyndicationItem item in page.Items.Reverse())
                        {
                            yield return item;
                        }
                    }
                }
                while (link != null);
            }
        }
    }
}
