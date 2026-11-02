namespace CrossDomain.Integration.Common.Tests.Unit.Atom
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Atom;
    using SFA.FCT.CrossDomain.Integration.Common.Atom.SyndicationItemCreator;

    [TestClass]
    public class AtomFeedGeneratorTests
    {
        private const string MediaType = "application/atom+xml";

        [TestMethod, TestCategory("UnitTest")]
        public void GenerateFeed_setsFeedMetadataItemsAndArchiveLinks()
        {
            var latestUpdate = new DateTime(2024, 2, 3, 4, 5, 6, DateTimeKind.Utc);
            var resultSet = new PageStorageResultSet<string>
            {
                Rows = new List<string> { "first", "second" },
                LatestRowUpdatedTime = latestUpdate,
                MediaType = MediaType,
                Host = "https://example.test",
                RoutePrefix = "api/contracts",
                RouteSuffix = "approved",
                PageNumber = 1,
                NextPageNumber = 2,
                PrevPageNumber = 0
            };
            var generator = new AtomFeedGenerator<string>();
            var itemCreator = new SyndicationItemCreator<string, TestEntryContent>();

            var feed = generator.GenerateFeed(resultSet, "contract-feed", "Contracts", "FCT", itemCreator);

            Assert.AreEqual("contract-feed", feed.Id);
            Assert.AreEqual("Contracts", feed.Title.Text);
            Assert.AreEqual(new DateTimeOffset(latestUpdate), feed.LastUpdatedTime);
            Assert.AreEqual("FCT", feed.Authors.Single().Name);
            Assert.AreEqual(2, feed.Items.Count());
            Assert.AreEqual("first", feed.Items.First().Summary.Text);
            Assert.AreEqual(MediaType, feed.Items.First().Links.Single().MediaType);
            Assert.AreEqual(1, feed.ElementExtensions.Count());
            Assert.AreEqual("https://example.test/api/contracts/approved", GetLink(feed, AtomRelationship.SelfRelationship));
            Assert.AreEqual("https://example.test/api/contracts/approved/3", GetLink(feed, AtomRelationship.NextRelationship));
            Assert.AreEqual("https://example.test/api/contracts/approved/1", GetLink(feed, AtomRelationship.PreviousRelationship));
            Assert.AreEqual("https://example.test/api/contracts/approved/2", GetLink(feed, AtomRelationship.CurrentRelationship));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GenerateFeed_omitsOptionalValuesWhenTheyAreNotProvided()
        {
            var resultSet = new PageStorageResultSet<string>
            {
                Host = "https://example.test",
                RoutePrefix = "api/contracts",
                MediaType = MediaType
            };

            var feed = new AtomFeedGenerator<string>().GenerateFeed(
                resultSet,
                null,
                "Contracts",
                "FCT",
                new SyndicationItemCreator<string, TestEntryContent>());

            Assert.IsNull(feed.Id);
            Assert.AreEqual(DateTimeOffset.MinValue, feed.LastUpdatedTime);
            Assert.AreEqual(0, feed.ElementExtensions.Count());
            Assert.IsTrue(feed.Items == null || !feed.Items.Any());
            Assert.AreEqual(1, feed.Links.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GenerateFeed_canUsePageNumbersWithoutNormalization()
        {
            var resultSet = new PageStorageResultSet<string>
            {
                Host = "https://example.test",
                RoutePrefix = "api/contracts",
                NextPageNumber = 2
            };

            var feed = new AtomFeedGenerator<string>().GenerateFeed(
                resultSet,
                "id",
                "Contracts",
                "FCT",
                new SyndicationItemCreator<string, TestEntryContent>(),
                normalizePageNumber: false);

            Assert.AreEqual("https://example.test/api/contracts/2", GetLink(feed, AtomRelationship.NextRelationship));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PageNumberNormalizer_convertsBetweenInternalAndUrlPageNumbers()
        {
            Assert.AreEqual(0, AtomPageNumberNormalizer.FromUrlPageNumber(1));
            Assert.AreEqual(1, AtomPageNumberNormalizer.ToUrlPageNumber(0));
        }

        private static string GetLink(SyndicationFeed feed, string relationship)
        {
            return feed.Links.Single(link => link.RelationshipType == relationship).Uri.AbsoluteUri;
        }

        public class TestEntryContent : IEntryContent<string>
        {
            public string Value { get; set; }

            public void SetRootProperty(string value)
            {
                Value = value;
            }
        }
    }
}
