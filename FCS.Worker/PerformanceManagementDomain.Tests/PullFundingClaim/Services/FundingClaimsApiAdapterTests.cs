namespace PerformanceManagementDomain.Tests.PullFundingClaim.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net;
    using FluentAssertions;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim.DTOs;
    using PerformanceManagementDomain.PullFundingClaim.Services;

    [TestClass]
    public class FundingClaimsApiAdapterTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimsApiAdapter_ShouldGetFundingClaimCompletedCollections()
        {
            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;

            FundingClaimsApiAdapter adapter = new FundingClaimsApiAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act
            IReadOnlyCollection<string> completedCollections =
                adapter.GetFundingClaimCompletedCollections(new DateTime(2020, 01, 01, 0, 0, 0, 0, DateTimeKind.Utc)).Result;

            // assert
            completedCollections.Should().NotBeNull("return value should not be null");
            completedCollections.Should().HaveCountGreaterThan(0, "some dataCollectionKeys should be returned");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimsApiAdapter_ShouldGetEmptyArrayWhenQueriedWithSinceDateTimeOfLatestSubmissionCloseDateUtcWithoutAddedSecond()
        {
            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;

            FundingClaimsApiAdapter adapter = new FundingClaimsApiAdapter(new HttpService(), new OAuthAccessTokenFactory());

            DateTime latestSubmissionCloseDateUtc =
                new DateTime(2020, 02, 13, 17, 0, 0, 0, DateTimeKind.Utc);

            // act
            IReadOnlyCollection<string> completedCollections =
                adapter.GetFundingClaimCompletedCollections(latestSubmissionCloseDateUtc).Result;

            // assert
            completedCollections.Should().NotBeNull("return value should not be null");
            completedCollections.Should().HaveCount(0, "an empty array should be returned");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimsApiAdapter_ShouldGetCountOfFundingClaimsForCollectionKey()
        {
            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;

            FundingClaimsApiAdapter adapter = new FundingClaimsApiAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act
            int fundingClaimCount = adapter.GetCountOfFundingClaimsForCollectionKey("FC01").Result;

            // assert
            fundingClaimCount.Should().BeGreaterThan(0);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimsApiAdapter_ShouldGetFundingClaimsForCollectionKey()
        {
            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;

            FundingClaimsApiAdapter adapter = new FundingClaimsApiAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act
            IReadOnlyCollection<FundingClaimApiDto> fundingClaims = adapter.GetFundingClaimsForCollectionKey("FC01", 1).Result;

            // assert
            fundingClaims.Should().NotBeNull("return value should not be null");
            fundingClaims.Should().HaveCountGreaterThan(1, "some funding claims should be returned");

            FundingClaimApiDto fundingClaim = fundingClaims.First();
            fundingClaim.ContractAllocations.Should().HaveCountGreaterThan(0, "some allocations should be returned");

            ContractAllocationApiDto allocation = fundingClaim.ContractAllocations.First();
            allocation.DeliverableCodes.Should().HaveCountGreaterThan(1, "some deliverables should be returned");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimsApiAdapter_ShouldGetFundingClaimsUsingAllThreeApiCallsFromDctPreProd()
        {
            // arrange
            ConfigurationManager.AppSettings["DCT:FundingClaims:Url"] = "https://api-fundingclaims.submitlearnerdatappbeta.fasst.org.uk";
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:ClientId"] = "539331fd-027a-4320-a14f-9f58b16eac18";
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:Scope"] = "api://d5c2ca13-7d37-4886-92ea-c6dc61855cc3/.default";
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:ClientSecret"] = "";
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:Tenant"] = "3aacc835-4b83-483d-841d-cd787f6f1486";

            FundingClaimsApiAdapter adapter = new FundingClaimsApiAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act, assert
            IReadOnlyCollection<string> completedCollectionKeys =
                adapter.GetFundingClaimCompletedCollections(new DateTime(2020, 01, 01, 0, 0, 0, 0, DateTimeKind.Utc)).Result;

            completedCollectionKeys.Should().HaveCountGreaterThan(0, "some dataCollectionKeys should be returned");

            completedCollectionKeys.ToList().ForEach(key =>
            {
                int fundingClaimCount = adapter.GetCountOfFundingClaimsForCollectionKey(key).Result;
                    int totalPages = (int)Math.Ceiling((double)fundingClaimCount / adapter.PageSize);

                    IEnumerable<FundingClaimApiDto> fundingClaims =
                        Enumerable.Range(1, totalPages)
                        .SelectMany(pageNumber => adapter.GetFundingClaimsForCollectionKey(key, pageNumber).Result)
                        .ToList();

                    fundingClaims.Count().Should().Be(fundingClaimCount, $"expected number of funding claims should be returned for collection with key {key}");
                });
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimsApiAdapter_ShouldGetFundingClaimsUsingAllThreeApiCallsFromDctProd()
        {
            // arrange
            ConfigurationManager.AppSettings["DCT:FundingClaims:Url"] = "https://api-fundingclaims.submitlearnerdatabeta.fasst.org.uk";
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:ClientId"] = "dff80a63-6f3c-4246-a13b-973a84d909cd";
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:Scope"] = "api://75006943-a8b7-45b0-9000-db4c42e9763c/.default";
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:ClientSecret"] = "##DCFundingClaimsAPIClientSecret##"; // ask Rahul or DevOps
            ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:Tenant"] = "3aacc835-4b83-483d-841d-cd787f6f1486";

            FundingClaimsApiAdapter adapter = new FundingClaimsApiAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act
            IReadOnlyCollection<string> completedCollectionKeys = // 2019-11-05 15:04:16.267
                adapter.GetFundingClaimCompletedCollections(new DateTime(2019, 11, 05, 15, 04, 16, 267, DateTimeKind.Utc)).Result;

            completedCollectionKeys.Should().HaveCountGreaterThan(0, "some dataCollectionKeys should be returned");

            completedCollectionKeys.ToList().ForEach(key =>
            {
                int fundingClaimCount = adapter.GetCountOfFundingClaimsForCollectionKey(key).Result;
                    int totalPages = (int)Math.Ceiling((double)fundingClaimCount / adapter.PageSize);

                    IEnumerable<FundingClaimApiDto> fundingClaims =
                        Enumerable.Range(1, totalPages)
                        .SelectMany(pageNumber => adapter.GetFundingClaimsForCollectionKey(key, pageNumber).Result)
                        .ToList();

                    // assert
                    fundingClaims.Count().Should().Be(fundingClaimCount, $"expected number of funding claims should be returned for collection with key {key}");
                });
        }
    }
}
