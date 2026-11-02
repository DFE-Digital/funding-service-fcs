//namespace SFA.FCT.CrossDomain.Integration.Common.Atom
//{
//    using System;
//    using System.Collections.Generic;
//    using System.IO;
//    using System.ServiceModel.Syndication;
//    using System.Text;
//    using System.Xml;
//    using System.Xml.Serialization;
//    using Entities.CorporateContract;

//    public class AtomFeedGenerator<T> : IAtomFeedGenerator<T>
//    {
//        public SyndicationFeed GenerateFeed(PageStorageResultSet<T> pageStorageResultSet, string feedTitle, string author)
//        {
//            SyndicationFeed feed = new SyndicationFeed();
//            feed.Title = new TextSyndicationContent(feedTitle);
//            feed.Authors.Add(new SyndicationPerson(author));
//            IList<SyndicationItem> items = new List<SyndicationItem>();
//            feed.Items = items;
//            AddRowsToFeed(items, pageStorageResultSet.Rows, pageStorageResultSet.MediaType);
//            SetLinksOnFeed(feed, pageStorageResultSet);
//            return feed;
//        }

//        private void SetLinksOnFeed(SyndicationFeed feed, PageStorageResultSet<T> pageStorageResultSet)
//        {
//            if (DoWeRequireNextLinkThatIsTheCurrentLink(pageStorageResultSet))
//            {
//                AddCurrentNextLink(feed, pageStorageResultSet);
//            }
//            else if (DoWeRequireNextLink(pageStorageResultSet))
//            {
//                AddNextLink(feed, pageStorageResultSet);
//            }

//            if (DoWeRequirePrevLink(pageStorageResultSet))
//            {
//                AddPrevLink(feed, pageStorageResultSet);
//            }
//        }

//        private void AddCurrentNextLink(SyndicationFeed feed, PageStorageResultSet<T> pageStorageResultSet)
//        {
//            feed.Links.Add(new SyndicationLink
//            {
//                RelationshipType = AtomRelationship.NextRelationship,
//                Uri = new Uri(GetUrlForCurrentPage(pageStorageResultSet)),
//                MediaType = pageStorageResultSet.MediaType
//            });
//        }

//        private bool DoWeRequireNextLinkThatIsTheCurrentLink(PageStorageResultSet<T> pageStorageResultSet)
//        {
//            return pageStorageResultSet.NextPageNumber == null && pageStorageResultSet.PageNumber.HasValue;
//        }

//        private bool DoWeRequirePrevLink(PageStorageResultSet<T> pageStorageResultSet)
//        {
//            return pageStorageResultSet.PrevPageNumber != null;
//        }

//        private bool DoWeRequireNextLink(PageStorageResultSet<T> pageStorageResultSet)
//        {
//            return pageStorageResultSet.NextPageNumber != null;
//        }

//        private void AddPrevLink(SyndicationFeed feed, PageStorageResultSet<T> pageStorageResultSet)
//        {
//            AddLink(
//                feed,
//                AtomRelationship.PreviousRelationship,
//                pageStorageResultSet.PrevPageNumber,
//                pageStorageResultSet);
//        }

//        private void AddNextLink(SyndicationFeed feed, PageStorageResultSet<T> pageStorageResultSet)
//        {
//            AddLink(
//                feed,
//                AtomRelationship.NextRelationship,
//                pageStorageResultSet.NextPageNumber,
//               pageStorageResultSet);
//        }

//        private void AddLink(SyndicationFeed feed, string relationship, int? pageNumber, PageStorageResultSet<T> pageStorageResultSet)
//        {
//            feed.Links.Add(new SyndicationLink
//            {
//                RelationshipType = relationship,
//                Uri = new Uri(GetUrlWithNewPageAppended(pageStorageResultSet, pageNumber.Value)),
//                MediaType = pageStorageResultSet.MediaType
//            });
//        }

//        private void AddRowsToFeed(IList<SyndicationItem> items, IList<T> rows, string mediaType)
//        {
//            if (rows != null)
//            {
//                foreach (var row in rows)
//                {
//                    items.Add(CreateItemForRow(row, mediaType));
//                }
//            }
//        }

//        private SyndicationItem CreateItemForRow(T row, string mediaType)
//        {
//            SyndicationItem item = new SyndicationItem();
//            item.Content = new XmlSyndicationContent(new XmlTextReader(new StringReader(SerializeRowToXml(row))));
//            item.Summary = new TextSyndicationContent(GetSummaryText(row));

//            item.Links.Add(CreateSyndicationLink(mediaType));
//            return item;
//        }

//        private string GetSummaryText(T row)
//        {
//            return row.ToString();
//        }

//        private SyndicationLink CreateSyndicationLink(string mediaType)
//        {
//            return new SyndicationLink
//            {
//                RelationshipType = AtomRelationship.SelfRelationship,
//                MediaType = mediaType
//            };
//        }

//        private string SerializeRowToXml(T item)
//        {
//            // really horrible hack here for contract - when serialized the contract elem was missing
//            if (item is contract)
//            {
//                ContractEntryContent<T> contractEntry = new ContractEntryContent<T>();
//                contractEntry.contract = item;

//                XmlSerializer xs = new XmlSerializer(typeof(ContractEntryContent<contract>));
//                using (MemoryStream buffer = new MemoryStream())
//                {
//                    xs.Serialize(buffer, contractEntry);
//                    buffer.Position = 0;

//                    return ASCIIEncoding.ASCII.GetString(buffer.ToArray());
//                }
//            }
//            else
//            {
//                XmlSerializer xs = new XmlSerializer(typeof(T));
//                using (MemoryStream buffer = new MemoryStream())
//                {
//                    xs.Serialize(buffer, item);
//                    buffer.Position = 0;

//                    return ASCIIEncoding.ASCII.GetString(buffer.ToArray());
//                }
//            }
//        }

//        private string GetUrlWithNewPageAppended(PageStorageResultSet<T> pageStorageResultSet, int newPageNumber)
//        {
//            const string forwardSlash = "/";
//            StringBuilder urlBuilder = new StringBuilder();
//            urlBuilder.Append(GetUrlForCurrentPage(pageStorageResultSet));
//            urlBuilder.Append(forwardSlash);
//            urlBuilder.Append(newPageNumber);

//            return urlBuilder.ToString();
//        }

//        private string GetUrlForCurrentPage(PageStorageResultSet<T> pageStorageResultSet)
//        {
//            const string forwardSlash = "/";
//            StringBuilder urlBuilder = new StringBuilder();
//            urlBuilder.Append(pageStorageResultSet.Host);
//            urlBuilder.Append(forwardSlash);
//            urlBuilder.Append(pageStorageResultSet.RoutePrefix);
//            urlBuilder.Append(forwardSlash);
//            urlBuilder.Append(pageStorageResultSet.RouteSuffix);

//            return urlBuilder.ToString();
//        }
//    }
//}
