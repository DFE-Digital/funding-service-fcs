namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml;
    using System.Xml.Serialization;
    using AllocationDelivery.DataStore.Model;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Entities;
    using DTO;
    using Infrastructure.Services;

    public class ADMonitoringDomainPageObject
    {
        private const string MostRecentPageUrl = "/api/allocation-delivery/monitoring/notifications/all";
        private SyndicationFeed _mostRecentlyRetrievedFeed = null;
        private readonly IList<SimpleContractAllocation> _contractAllocationsInFeed = new List<SimpleContractAllocation>();
        
        public bool VerifyAllocationsAreInFeed(IEnumerable<SimpleContractAllocation> contractAllocationsToCheck)
        {
            _contractAllocationsInFeed.Clear();

            RetrieveCurrentFeedContents();

            return contractAllocationsToCheck.All(a => _contractAllocationsInFeed.Contains(a));
        }

        public bool VerifyAllocationsAreInFeedByAllocRef(IEnumerable<string> allocationRefs)
        {
            _contractAllocationsInFeed.Clear();

            RetrieveCurrentFeedContents();

            return allocationRefs.All(a => _contractAllocationsInFeed.Any(r => r.AllocationNumber == a));
        }

        public IList<SimpleContractAllocation> GetAllEntriesInFeed()
        {
            return _contractAllocationsInFeed;
        }

        public void VerifyPlannedVolumeInFeed(FeedAllocation allocationToCheck, IList<SimpleContractAllocation> feedEntries)
        {
            AllocationDeliveryPerformance adpEntryItem = feedEntries
                                     .First(x => x.AllocationDeliveryEntryCategory == allocationToCheck.EntryCategory
                                        && x.AllocationNumber == allocationToCheck.AllocationNumber
                                        && x.ContractVersionNumber == allocationToCheck.AllocationVersion).AllocationDeliveryPerformanceItem;

            foreach(var adpToCheck in allocationToCheck.AllocationDeliverablePeriods)
            {
                if (adpEntryItem != null)
                {
                    var contractDeliverablePeriods = adpEntryItem.ContractDeliverables.First(x => x.DeliverableCode == adpToCheck.DeliverableCode).ContractDeliverablePeriods;

                    adpToCheck.IsPlannedVolumeMatches = contractDeliverablePeriods.Find(x=>x.Period== adpToCheck.Period)?.PlannedVolume == adpToCheck.PlannedVolume;
                }
            }

        }

        public void VerifyActualVolumeInFeed(FeedAllocation allocationToCheck, IList<SimpleContractAllocation> feedEntries)
        {
            AllocationDeliveryPerformance adpEntryItem = feedEntries
                                     .First(x => x.AllocationDeliveryEntryCategory == allocationToCheck.EntryCategory
                                        && x.AllocationNumber == allocationToCheck.AllocationNumber
                                        && x.ContractVersionNumber == allocationToCheck.AllocationVersion).AllocationDeliveryPerformanceItem;

            foreach (var adpToCheck in allocationToCheck.AllocationDeliverablePeriods)
            {
                if (adpEntryItem == null) continue;
                var actualPeriod =
                    adpEntryItem.ActualsPeriods.ActualsPeriod.First(x => x.Period == adpToCheck.Period).Actual;

                adpToCheck.IsActualVolumeMatches =
                    actualPeriod.Find(x => x.DeliverableCode == adpToCheck.DeliverableCode)?.ActualVolume ==
                    adpToCheck.ActualVolume;
            }

        }

        private void RetrieveCurrentFeedContents()
        {
            var retrievedFeed = CallEndpointAndReturnResult("application/atom+xml", MostRecentPageUrl); ;
            _mostRecentlyRetrievedFeed = SyndicationFeed.Load(new XmlTextReader(new StringReader(retrievedFeed)));

            AddFeedContentsToRetrievedContractList();

            var link = _mostRecentlyRetrievedFeed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.PreviousRelationship);
            while (link != null)
            {
                retrievedFeed = CallEndpointAndReturnResult("application/atom+xml", link.Uri.AbsolutePath);
                _mostRecentlyRetrievedFeed = SyndicationFeed.Load(new XmlTextReader(new StringReader(retrievedFeed)));
                AddFeedContentsToRetrievedContractList();
                link = _mostRecentlyRetrievedFeed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.PreviousRelationship);
            }
        }

        private void AddFeedContentsToRetrievedContractList()
        {
            XmlWriterSettings ws = new XmlWriterSettings
            {
                Indent = true,
                IndentChars = " ",
                OmitXmlDeclaration = true,
                Encoding = new UTF8Encoding()
            };

            // this code is UGLY but right now is the quick and dirty way to sort out the additional root element
            // in the supplied content.
            foreach (var item in _mostRecentlyRetrievedFeed.Items)
            {
                XmlSyndicationContent content = (XmlSyndicationContent)item.Content;

                MemoryStream ms = new MemoryStream();
                XmlWriter w = XmlWriter.Create(ms, ws);
                content.WriteTo(w, "Content", "");
                w.Flush();
                ms.Position = 0;
                StreamReader sr = new StreamReader(ms);
                string xmlContent = sr.ReadToEnd();
                xmlContent = StripOffOuterElement(xmlContent);
              
                ms = new MemoryStream();

                StreamWriter sw = new StreamWriter(ms);
                sw.WriteLine(xmlContent);
                sw.Flush();

                ms.Position = 0;

                XmlSerializer xs = new XmlSerializer(typeof(AllocationDeliveryPerformance));
                var allocationDeliveryPerformance = xs.Deserialize(ms) as AllocationDeliveryPerformance;
                _contractAllocationsInFeed.Add(CreateSimpleContractAllocation(
                    (AllocationDeliveryEntryCategory)Enum.Parse(typeof(AllocationDeliveryEntryCategory), item.Categories.First().Name),
                    allocationDeliveryPerformance));
            }
        }

        private static string StripOffOuterElement(string xmlContent)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xmlContent);

            return doc.FirstChild.FirstChild.OuterXml;
        }

        private static SimpleContractAllocation CreateSimpleContractAllocation(
            AllocationDeliveryEntryCategory allocationDeliveryEntryCategory,
            AllocationDeliveryPerformance allocationDeliveryPerformance)
        {
            return new SimpleContractAllocation(allocationDeliveryEntryCategory, allocationDeliveryPerformance);
        }

        private static string CallEndpointAndReturnResult(string mediaType, string url)
        {
            var client = new HttpClient();
            client
                .DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthenticator.GetAuthenticationResult());

            var urlHost =TestConfiguration.Configuration["ContractManagementServiceUrl"];
            urlHost = StripOffUrlSuffix(urlHost);
            var responseMessage = client
                       .GetAsync(urlHost + url)
                       .Result;

            var statusCode = responseMessage.StatusCode;

            if (statusCode != HttpStatusCode.OK)
            {
                throw new ApplicationException(string.Format("Http status code of {0} returned", statusCode));
            }

            string response = responseMessage
                            .Content
                            .ReadAsStringAsync()
                            .Result;

            return response;
        }

        private static string StripOffUrlSuffix(string url)
        {
            const string urlSuffix = "ContractManagementService";
            int indexOfSuffix  = url.IndexOf(urlSuffix);
            if (indexOfSuffix != -1)
            {
                url = url.Remove(indexOfSuffix, urlSuffix.Length);
            }

            return url;
        }
    }
}
