namespace SFA.FCT.CrossDomain.Integration.Common.Atom
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.ServiceModel.Syndication;
    using System.Text;
    using SyndicationItemCreator;

    public class AtomFeedGenerator<TEntity> : IAtomFeedGenerator<TEntity>
    {
        public SyndicationFeed GenerateFeed(PageStorageResultSet<TEntity> pageStorageResultSet, string id, string feedTitle, string author, ISyndicationItemCreator<TEntity> syndicationItemCreator, bool normalizePageNumber = true)
        {
            var feed = new SyndicationFeed
            {
                Title = new TextSyndicationContent(feedTitle)
            };

            // using a permanent id is part of the rfc, but we don't insist on it so that we don't have to fix existing consumers
            if (id != null)
                feed.Id = id;

            // check for value to leave existing consumers alone, but they should probably set LastUpdated too
            if (pageStorageResultSet.LatestRowUpdatedTime.HasValue)
                feed.LastUpdatedTime = pageStorageResultSet.LatestRowUpdatedTime.Value;

            // the story asks for <author>Allocation Delivery Service</author>. but to be rfc compliant, the author, which is a person construct, MUST contain a name element
            feed.Authors.Add(new SyndicationPerson(null, author, null));

            if (pageStorageResultSet.PageNumber.HasValue)
                feed.ElementExtensions.Add("archive", "http://purl.org/syndication/history/1.0", string.Empty);

            if (pageStorageResultSet.Rows != null)
                feed.Items = CreateSyndicationItemList(pageStorageResultSet.Rows, pageStorageResultSet.MediaType, syndicationItemCreator);

            SetLinksOnFeed(feed, pageStorageResultSet, normalizePageNumber);
            return feed;
        }

        private void SetLinksOnFeed(SyndicationFeed feed, PageStorageResultSet<TEntity> pageStorageResultSet, bool normalizePageNumber)
        {
            if (pageStorageResultSet.NextPageNumber.HasValue)
            {
                AddNextLink(feed, pageStorageResultSet, normalizePageNumber);
            }

            if (DoWeRequirePrevLink(pageStorageResultSet))
            {
                AddPrevLink(feed, pageStorageResultSet, normalizePageNumber);
            }

            AddSelfLink(feed, pageStorageResultSet);

            if (pageStorageResultSet.PageNumber.HasValue)
            {
                AddCurrentLink(feed, pageStorageResultSet, normalizePageNumber);
            }
        }

        private static void AddSelfLink(SyndicationFeed feed, PageStorageResultSet<TEntity> pageStorageResultSet)
        {
            Uri selfLinkUri = new Uri(GetUrlForCurrentPage(pageStorageResultSet));

            feed.Links.Add(new SyndicationLink
            {
                RelationshipType = AtomRelationship.SelfRelationship,
                Uri = selfLinkUri,
                MediaType = pageStorageResultSet.MediaType
            });
        }

        private void AddCurrentLink(SyndicationFeed feed, PageStorageResultSet<TEntity> pageStorageResultSet, bool normalizePageNumber)
        {
            AddLink(feed, AtomRelationship.CurrentRelationship, pageStorageResultSet.PageNumber, pageStorageResultSet, normalizePageNumber);
        }

        private bool DoWeRequirePrevLink(PageStorageResultSet<TEntity> pageStorageResultSet)
        {
            return pageStorageResultSet.PrevPageNumber != null;
        }

        private void AddPrevLink(SyndicationFeed feed, PageStorageResultSet<TEntity> pageStorageResultSet, bool normalizePageNumber)
        {
            AddLink(
                feed,
                AtomRelationship.PreviousRelationship,
                pageStorageResultSet.PrevPageNumber,
                pageStorageResultSet,
                normalizePageNumber);
        }

        private void AddNextLink(SyndicationFeed feed, PageStorageResultSet<TEntity> pageStorageResultSet, bool normalizePageNumber)
        {
            AddLink(
                feed,
                AtomRelationship.NextRelationship,
                pageStorageResultSet.NextPageNumber,
                pageStorageResultSet,
                normalizePageNumber);
        }

        private void AddLink(SyndicationFeed feed, string relationship, int? pageNumber, PageStorageResultSet<TEntity> pageStorageResultSet, bool normalizePageNumber)
        {
            if (!pageNumber.HasValue)
                throw new ArgumentException("The pageNumber param was not set");   

            feed.Links.Add(new SyndicationLink
            {
                RelationshipType = relationship,
                //Uri = new Uri(GetUrlWithPageAppended(pageStorageResultSet, pageNumber.Value)),
                Uri = new Uri(GetUrlWithNewPageAppended(pageStorageResultSet, pageNumber.Value, normalizePageNumber)),
                MediaType = pageStorageResultSet.MediaType
            });
        }

        private static List<SyndicationItem> CreateSyndicationItemList(IList<TEntity> rows, string mediaType, ISyndicationItemCreator<TEntity> syndicationItemCreator)
        {
            return new List<SyndicationItem>(rows.Select(r => syndicationItemCreator.CreateItemForRow(r, mediaType)));
        }

        private string GetUrlWithNewPageAppended(PageStorageResultSet<TEntity> pageStorageResultSet, int newPageNumber, bool normalizePageNumber = true)
        {
            const string forwardSlash = "/";
            var urlBuilder = new StringBuilder();
            urlBuilder.Append(GetUrlForCurrentPage(pageStorageResultSet));
            urlBuilder.Append(forwardSlash);

            if (normalizePageNumber)
            {
                newPageNumber = AtomPageNumberNormalizer.ToUrlPageNumber(newPageNumber);
            }

            urlBuilder.Append(newPageNumber);

            return urlBuilder.ToString();
        }

        private static string GetUrlForCurrentPage(PageStorageResultSet<TEntity> pageStorageResultSet)
        {
            const string forwardSlash = "/";
            StringBuilder urlBuilder = new StringBuilder();
            urlBuilder.Append(pageStorageResultSet.Host);
            urlBuilder.Append(forwardSlash);
            urlBuilder.Append(pageStorageResultSet.RoutePrefix);
            if (!string.IsNullOrEmpty(pageStorageResultSet.RouteSuffix))
            {
                urlBuilder.Append(forwardSlash);
                urlBuilder.Append(pageStorageResultSet.RouteSuffix);
            }

            return urlBuilder.ToString();
        }
    }
}
