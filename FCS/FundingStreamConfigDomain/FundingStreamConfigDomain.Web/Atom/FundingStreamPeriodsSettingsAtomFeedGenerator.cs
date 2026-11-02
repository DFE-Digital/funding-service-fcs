//namespace SFA.FCT.FundingPolicyDomain.AtomFeed
//{
//    using System;
//    using System.Collections.Generic;
//    using System.IO;
//    using System.ServiceModel.Syndication;
//    using System.Text;
//    using System.Xml;
//    using System.Xml.Serialization;
//    using Controllers;
//    using CrossDomain.Integration.Entities;

//    public class FundingStreamPeriodsSettingsAtomFeedGenerator : IFundingStreamPeriodsSettingsAtomFeedGenerator
//    {
//        public const string PreviousRelationship = "prev-archive";
//        public const string NextRelationship = "next-archive";
//        public const string SelfRelationship = "self";

//        public SyndicationFeed GenerateFeed(FundingStreamPeriodsSettingsResultSet resultSet)
//        {
//            SyndicationFeed feed = new SyndicationFeed();
//            feed.Title = new TextSyndicationContent(string.Format("FundingStreamPeriodsSettingsResultSet"));
//            feed.Authors.Add(new SyndicationPerson("Funding Stream Periods Service"));
//            IList<SyndicationItem> items = new List<SyndicationItem>();
//            feed.Items = items;
//            AddItemsToFeed(items, resultSet.FundingStreamPeriodSettingConfiguration, resultSet.MediaType);
//            SetLinksOnFeed(feed, resultSet);
//            return feed;
//        }

//        private void SetLinksOnFeed(SyndicationFeed feed, FundingStreamPeriodsSettingsResultSet resultSet)
//        {
//            if (DoWeRequireNextLinkThatIsTheCurrentLink(resultSet))
//            {
//                AddCurrentNextLink(feed, resultSet);
//            }
//            else if (DoWeRequireNextLink(resultSet))
//            {
//                AddNextLink(feed, resultSet);
//            }

//            if (DoWeRequirePrevLink(resultSet))
//            {
//                AddPrevLink(feed, resultSet);
//            }
//        }

//        private void AddCurrentNextLink(SyndicationFeed feed, FundingStreamPeriodsSettingsResultSet FundingStreamPeriodsSettingsResultSet)
//        {
//            feed.Links.Add(new SyndicationLink
//            {
//                RelationshipType = NextRelationship,
//                Uri = new Uri(GetUrlForCurrentPage(FundingStreamPeriodsSettingsResultSet.Host)),
//                MediaType = FundingStreamPeriodsSettingsResultSet.MediaType
//            });
//        }

//        private bool DoWeRequireNextLinkThatIsTheCurrentLink(FundingStreamPeriodsSettingsResultSet FundingStreamPeriodsSettingsResultSet)
//        {
//            return FundingStreamPeriodsSettingsResultSet.NextPageNumber == null && FundingStreamPeriodsSettingsResultSet.PageNumber.HasValue;
//        }

//        private bool DoWeRequirePrevLink(FundingStreamPeriodsSettingsResultSet FundingStreamPeriodsSettingsResultSet)
//        {
//            return FundingStreamPeriodsSettingsResultSet.PrevPageNumber != null;
//        }

//        private bool DoWeRequireNextLink(FundingStreamPeriodsSettingsResultSet FundingStreamPeriodsSettingsResultSet)
//        {
//            return FundingStreamPeriodsSettingsResultSet.NextPageNumber != null;
//        }

//        private void AddPrevLink(SyndicationFeed feed, FundingStreamPeriodsSettingsResultSet FundingStreamPeriodsSettingsResultSet)
//        {
//            AddLink(
//                feed,
//                PreviousRelationship,
//                FundingStreamPeriodsSettingsResultSet.PrevPageNumber,
//                FundingStreamPeriodsSettingsResultSet.Host,
//                FundingStreamPeriodsSettingsResultSet.MediaType);
//        }

//        private void AddNextLink(SyndicationFeed feed, FundingStreamPeriodsSettingsResultSet FundingStreamPeriodsSettingsResultSet)
//        {
//            AddLink(
//                feed, 
//                NextRelationship,
//                FundingStreamPeriodsSettingsResultSet.NextPageNumber,
//               FundingStreamPeriodsSettingsResultSet.Host,
//               FundingStreamPeriodsSettingsResultSet.MediaType);
//        }

//        private void AddLink(SyndicationFeed feed, string relationship, int? pageNumber, string urlHost, string mediaType)
//        {
//            feed.Links.Add(new SyndicationLink
//            {
//                RelationshipType = relationship,
//                Uri = new Uri(GetUrlWithNewPageAppended(urlHost, pageNumber.Value)),
//                MediaType = mediaType
//            });
//        }

//        private void AddItemsToFeed(IList<SyndicationItem> items, IList<FundingStreamPeriodSettingConfiguration> fsps, string mediaType)
//        {
//            foreach (var f in fsps)
//            {
//                items.Add(CreateItem(f, mediaType));
//            }
//        }

//        private SyndicationItem CreateItem(FundingStreamPeriodSettingConfiguration content, string mediaType)
//        {
//            SyndicationItem syndicationItem = new SyndicationItem();
//            syndicationItem.Content = new XmlSyndicationContent(new XmlTextReader(new StringReader(SerializeToXml(content))));
//            syndicationItem.Links.Add(CreateSyndicationLink(mediaType));
//            return syndicationItem;
//        }

//        private SyndicationLink CreateSyndicationLink( string mediaType)
//        {
//            return new SyndicationLink
//            {
//                RelationshipType = SelfRelationship,
//                MediaType = mediaType
//            };
//        }

//        private string SerializeToXml(FundingStreamPeriodSettingConfiguration content)
//        {
//            XmlSerializer xs = new XmlSerializer(typeof(FundingStreamPeriodSettingConfiguration));
//            MemoryStream buffer = new MemoryStream();
//            xs.Serialize(buffer, content);

//            return ASCIIEncoding.ASCII.GetString(buffer.ToArray());
//        }

//        private string GetUrlWithNewPageAppended(string urlHost, int newPageNumber)
//        {
//            const string forwardSlash = "/";
//            StringBuilder urlBuilder = new StringBuilder();
//            urlBuilder.Append(GetUrlForCurrentPage(urlHost));
//            urlBuilder.Append(forwardSlash);
//            urlBuilder.Append(newPageNumber);

//            return urlBuilder.ToString();
//        }

//        private string GetUrlForCurrentPage(string urlHost)
//        {
//            const string forwardSlash = "/";
//            StringBuilder urlBuilder = new StringBuilder();
//            urlBuilder.Append(urlHost);
//            urlBuilder.Append(forwardSlash);
//            urlBuilder.Append(FundingPolicyController.RoutePrefix);
//            urlBuilder.Append(forwardSlash);
//            urlBuilder.Append(FundingPolicyController.FundingStreamPeriodsSettingsRoute);
           
//            return urlBuilder.ToString();
//        }
//    }
//}