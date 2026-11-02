namespace FundingAllocation.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using FundingAllocation.Infrastructure;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class CreateBookmarkSettingSql
    {
        private const string Bookmark = "1619-AS-2122-Contracting-LocalAuthority-10024294-1_0";
        private const int PageSize = 500;
        private static readonly string Path = $"api/v4/contracts/funding/notifications?groupingreasons=Contracting&pageSize={PageSize}";

        [TestMethod, TestCategory("Tooling")]
        public void ReadCfsFeedAndCreateSqlToSetBookmarkInFcs()
        {
            IConfigurationRoot configuration = ConfigureFeedSettingsDOAT();

            FeedPage feedPageWithBookmark = GetFeedPageWithBookmark(configuration, Bookmark);

            AtomItem[] atomItemsUpToAndIncludingTheBookMark =
                feedPageWithBookmark.AtomItems
                    .TakeUntilIncluding(ai => ai.FundingId == Bookmark)
                    .ToArray();

            string sql = GenerateSql(Bookmark, feedPageWithBookmark.PageNumber, atomItemsUpToAndIncludingTheBookMark);

            File.WriteAllText("SetBookmarkInFcs.sql", sql);
        }

        private static IConfigurationRoot ConfigureFeedSettings()
        {
            IConfigurationRoot configuration = AppConfiguration.Configuration();

            configuration["CFS:RootUrl"] = "https://api-calculate-funding.education.gov.uk";
            configuration["CFS:Tenant"] = "fad277c9-c60a-4da1-b5f3-b3b8b34a82f9";
            configuration["CFS:ClientId"] = "6596bb35-78f9-45b7-9f90-814d29d409ed";
            configuration["CFS:ClientSecret"] = "DEV OPS to supply";
            configuration["CFS:Scope"] = "https://calculatefundingserviceapi/.default";

            return configuration;
        }

        private static IConfigurationRoot ConfigureFeedSettingsDOAT()
        {
            IConfigurationRoot configuration = AppConfiguration.Configuration();

            configuration["CFS:RootUrl"] = "https://pp-api-calculate-funding.education.gov.uk";
            configuration["CFS:Tenant"] = "fad277c9-c60a-4da1-b5f3-b3b8b34a82f9";
            configuration["CFS:ClientId"] = "2aa50637-ee68-4ae1-887f-920511f8e95c";
            configuration["CFS:ClientSecret"] = "DEV OPS";
            configuration["CFS:Scope"] = "https://calculatefundingserviceapipreprod/.default";

            return configuration;
        }

        private static FeedPage GetFeedPageWithBookmark(IConfigurationRoot configuration, string bookmark)
        {
            HttpClient httpClient = new HttpClient();
            string accessToken = OAuthAccessTokenFactory.GetAccessToken(configuration, OAuthAccessTokenFactory.SecureApplication.Cfs);
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            string url = $"{configuration["CFS:RootUrl"]}/{Path}";

            do
            {
                HttpResponseMessage response = httpClient.GetAsync(url).Result;
                string json = response.Content.ReadAsStringAsync().Result;

                IReadOnlyCollection<AtomItem> atomItems = CfsAtomParser.GetAtomItems(json);
                List<string> fundingIds = atomItems.Select(ai => ai.FundingId).ToList();

                if (fundingIds.Contains(bookmark))
                {
                    return new FeedPage(pageNumber: CfsAtomParser.GetPageNumberFromLink(url), atomItems);
                }

                url = CfsAtomParser.GetPrevLink(json);
            } while (url != null);


            throw new InvalidOperationException("Bookmark not found in feed");
        }

        private static string GenerateSql(string bookmark, int pageNumber, IEnumerable<AtomItem> atomItems)
        {
            StringBuilder stringBuilder = new StringBuilder();

            stringBuilder.AppendLine($@"
INSERT INTO FundingAllocation.FeedRead
    (CfsReadCompletedDate, JobCompletedDate)
VALUES
    (GETUTCDATE(), GETUTCDATE())

DECLARE @readId int = SCOPE_IDENTITY()

INSERT INTO FundingAllocation.FundingAllocationPageControl
    (ReadId, PageNumber, LatestBookmarkOnPage)
VALUES
    (@readId, {pageNumber}, '{bookmark}')");

            atomItems
                .Select((ai, idx) => $@"
INSERT INTO FundingAllocation.FundingAllocation
	(FundingId, FundingVersion, Period, AllocationFundingStream, UKPRN, Value, CreatedDate, PositionInPage, PageNumber, ProviderFundingCount, ReadId)
VALUES
	('{ai.FundingId}', '{ai.FundingVersion}', '{ai.Period}', '{ai.AllocationFundingStream}', '{ai.Ukprn}', {ai.Value}, GETUTCDATE(), {idx + 1}, {pageNumber}, 0, @readId)")
                .ToList()
                .ForEach(sql => stringBuilder.AppendLine(sql));

            return stringBuilder.ToString();
        }

        private class FeedPage
        {
            public FeedPage(int pageNumber, IReadOnlyCollection<AtomItem> atomItems)
            {
                PageNumber = pageNumber;
                AtomItems = atomItems;
            }

            public int PageNumber { get; }

            public IReadOnlyCollection<AtomItem> AtomItems { get; }
        }
    }

    public static class EnumerableExtensions
    {
        public static IEnumerable<T> TakeUntilIncluding<T>(this IEnumerable<T> source, Func<T, bool> predicate)
        {
            foreach (T item in source)
            {
                yield return item;

                if (predicate(item))
                {
                    yield break;
                }
            }
        }
    }
}
