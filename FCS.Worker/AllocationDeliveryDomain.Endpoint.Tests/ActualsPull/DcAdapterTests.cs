namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using Endpoint.ActualsPull;
    using Endpoint.ActualsPull.Adapters;
    using Endpoint.ActualsPull.Handlers;
    using Endpoint.ActualsPull.Repositories;
    using Endpoint.Infrastructure;
    using Endpoint.Repositories;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;
    using DTOs = AllocationDelivery.Messages.DTOs;
    using Model = SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    [TestClass]
    public class DcAdapterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DcAdapter_ShouldReturnEmptyCollectionWhenNoClosedCollectionsFound()
        {
            // arrange
            var httpServiceMock = new Mock<IHttpService>();
            httpServiceMock
                .Setup(m => m.GetAsync(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(string.Empty);
            DcAdapter dcAdapter = new DcAdapter(httpServiceMock.Object, Mock.Of<IOAuthAccessTokenFactory>());

            // act
            IReadOnlyCollection<DTOs.ClosedCollection> closedCollections =
                dcAdapter.GetClosedCollectionsSince(DateTime.UtcNow).Result;

            // assert
            closedCollections.Should().NotBeNull("a non-null collection should be returned");
            closedCollections.Should().HaveCount(0, "an empty collection should be returned");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DcAdapter_ShouldRetrieveClosedCollections()
        {
            // the below setup allows us to point to PreProd
            ConfigurationManager.AppSettings["DCT:Oauth:ClientId"] = "5a3a8177-606b-433f-bbb6-de40f5f85329";
            ConfigurationManager.AppSettings["DCT:Oauth:Scope"] = "api://0176c049-ceea-4d25-a375-6b70d9dbae13/.default";
            ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"] = "";
            ConfigurationManager.AppSettings["DCT:Oauth:Tenant"] = "3aacc835-4b83-483d-841d-cd787f6f1486";
            ConfigurationManager.AppSettings["DCT:Url"] =
                "https://api-summarisedactuals.submitlearnerdatappbeta.fasst.org.uk";

            // These are the TST / OAT credentials 
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientId"] = "1352dba0-9cc1-47da-973b-b1cb5300f3ec";
            //ConfigurationManager.AppSettings["DCT:Oauth:Scope"] = "api://f937d85c-300c-4505-83c5-84ebb9d9c99c/.default";
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"] = "";
            //ConfigurationManager.AppSettings["DCT:Oauth:Tenant"] = "1a92889b-8ea1-4a16-8132-347814051567";
            //ConfigurationManager.AppSettings["DCT:Url"] =
            //    "https://dcol-tst-integrationapi-summarisedactuals-weu.tst.ase.dct.fasst.org.uk";

            //the below setup allows us to point to Prod
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientId"] = "4ffd25c2-e3ff-4ecd-ad9c-26f0124cb608";
            //ConfigurationManager.AppSettings["DCT:Oauth:Scope"] = "api://8c27edec-aaa9-49dc-8957-b89bc4d8ae5d/.default";
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"] = "Alan has this";
            //ConfigurationManager.AppSettings["DCT:Oauth:Tenant"] = "3aacc835-4b83-483d-841d-cd787f6f1486";
            //ConfigurationManager.AppSettings["DCT:Url"] =
            //    "https://api-summarisedactuals.submitlearnerdatabeta.fasst.org.uk";

            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true; // bypass self-signed SSL cert for now

            DcAdapter adapter = new DcAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act
            IReadOnlyCollection<DTOs.ClosedCollection> closedCollections =
                adapter.GetClosedCollectionsSince(new DateTime(2020, 09, 01, 00, 00, 00, DateTimeKind.Utc)).Result;

            // assert
            Assert.IsNotNull(closedCollections, "Null returned");
            Assert.AreNotEqual(0, closedCollections.Count, "Empty collection returned");

            DTOs.ClosedCollection sampleCollection = closedCollections.First();
            Assert.IsTrue(!string.IsNullOrWhiteSpace(sampleCollection.CollectionType), "CollectionType not returned");
            Assert.IsTrue(!string.IsNullOrWhiteSpace(sampleCollection.CollectionReturnCode), "CollectionReturnCode not returned");
            Assert.AreNotEqual(DateTime.MinValue, sampleCollection.ClosedTime, "ClosedTime not returned");
            Assert.AreNotEqual(0, sampleCollection.TotalRowCount, "TotalRowCount not returned");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DcAdapter_ShouldRetrievePageOfSummarisedActuals()
        {
            const int pageSize = 100;

            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true; // bypass self-signed SSL cert for now
            
            DcAdapter adapter = new DcAdapter(new HttpService(), new OAuthAccessTokenFactory());

            IReadOnlyCollection<DTOs.ClosedCollection> closedCollections =
                adapter.GetClosedCollectionsSince(new DateTime(2020, 01, 01, 00, 00, 00, DateTimeKind.Utc)).Result;
            DTOs.ClosedCollection sampleCollection = closedCollections.First(cc => cc.TotalRowCount > pageSize);

            // act
            IReadOnlyCollection<Model.SummarisedActual> summarisedActuals =
                adapter.GetClosedCollectionsPage(sampleCollection.CollectionType, sampleCollection.CollectionReturnCode, 1, pageSize).Result;

            // assert
            Assert.IsNotNull(summarisedActuals);
            Assert.AreEqual(pageSize, summarisedActuals.Count);

            Model.SummarisedActual sampleSummarisedActual = summarisedActuals.First();
            Assert.IsTrue(!string.IsNullOrWhiteSpace(sampleSummarisedActual.CollectionType), "CollectionType not returned");
            Assert.IsTrue(!string.IsNullOrWhiteSpace(sampleSummarisedActual.CollectionReturnCode), "CollectionReturnCode not returned");
            Assert.IsTrue(!string.IsNullOrWhiteSpace(sampleSummarisedActual.OrganisationId), "OrganisationId not returned");
            Assert.IsTrue(!string.IsNullOrWhiteSpace(sampleSummarisedActual.FundingStreamPeriodCode), "FundingStreamPeriodCode not returned");
            Assert.AreNotEqual(0, sampleSummarisedActual.Period, "Period not returned");
            Assert.AreNotEqual(0, sampleSummarisedActual.DeliverableCode, "DeliverableCode not returned");
            Assert.IsNotNull(sampleSummarisedActual.DataCollectionsId, "DataCollectionsId not returned");
            Assert.AreNotEqual(0, sampleSummarisedActual.DataCollectionsId, "DataCollectionsId not returned");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DcAdapter_ShouldRetrieveAllSummarisedActualsForClosedCollectionInPages()
        {
            const int pageSize = 100;

            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true; // bypass self-signed SSL cert for now
            
            DcAdapter adapter = new DcAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act
            IReadOnlyCollection<DTOs.ClosedCollection> closedCollections =
                adapter.GetClosedCollectionsSince(new DateTime(2020, 01, 01, 00, 00, 00, DateTimeKind.Utc)).Result;

            DTOs.ClosedCollection sampleCollection = closedCollections.First(cc => cc.TotalRowCount > pageSize);

            int numberOfPages = adapter.GetNumPages(sampleCollection.TotalRowCount, pageSize);

            IReadOnlyCollection<Model.SummarisedActual> allSummarisedActuals =
                Enumerable.Range(1, numberOfPages)
                    .SelectMany(pageNumber => adapter.GetClosedCollectionsPage(sampleCollection.CollectionType, sampleCollection.CollectionReturnCode, pageNumber, pageSize).Result)
                    .ToList();

            // assert
            Assert.AreEqual(sampleCollection.TotalRowCount, allSummarisedActuals.Count, "Did not retrieve all Summarised Actuals");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DcAdapter_ShouldRetrieveAMonthEndOfClosedCollectionsAndStoreInSqlStagingUsingHandlersAndHandleConnectivityExceptions()
        {
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true; // bypass self-signed SSL cert for now

            // clear staging storage and set placeholder row to trigger last ~3 collections to be pulled
            using (MonitoringDeliverablesDbContext dbContext = new MonitoringDeliverablesDbContext())
            {
                dbContext.ClosedCollections.RemoveAll();
                dbContext.ClosedCollections.Add(new Model.ClosedCollection(
                    "DATE-PLACEHOLDER",
                    "DATE-PLACEHOLDER",
                    new DateTime(2020, 02, 12, 00, 00, 00, DateTimeKind.Utc),
                    0));
                dbContext.SaveChanges();
            }

            int totalCallsToHttpService = 0;

            HttpService httpService = new HttpService();
            Mock<IHttpService> occasionalExceptionThrowingHttpService = new Mock<IHttpService>();
            occasionalExceptionThrowingHttpService
                .Setup(m => m.GetAsync(It.IsAny<string>(), It.IsAny<string>()))
                .Returns((string token, string uri) =>
                {
                    totalCallsToHttpService++;

                    if (totalCallsToHttpService % 5 == 0)
                    {
                        throw new HttpRequestException("Unauthorized"); // force re-authorization
                    }

                    if (totalCallsToHttpService % 13 == 0)
                    {
                        throw new Exception("Kaboom"); // unlucky 13, mimic general problems
                    }

                    return httpService.GetAsync(token, uri);
                });

            // use singleton DC adapter for all handler calls
            DcAdapter dcAdapter = new DcAdapter(occasionalExceptionThrowingHttpService.Object, new OAuthAccessTokenFactory());

            List<PullClosedCollectionPageCommand> pageCommands;

            // pull closed collections and generate page commands
            using (MonitoringDeliverablesDbContext dbContext = new MonitoringDeliverablesDbContext())
            {
                Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
                sessionConnectionFactoryMock
                    .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, dbContext.Database.Connection));

                BeginDcActualsPullHandler beginDcActualsPullHandler = new BeginDcActualsPullHandler(
                    Mock.Of<ILogger>(),
                    dcAdapter,
                    sessionConnectionFactoryMock.Object,
                    new ClosedCollectionRepository(),
                    Mock.Of<IMonthEndStartRepository>());

                ConfigurationManager.AppSettings["DCT:PageSize"] = "100";

                TestableMessageHandlerContext handlerContext = new TestableMessageHandlerContext();

                beginDcActualsPullHandler.Handle(new BeginDcActualsPullCommand(), handlerContext).Wait();

                pageCommands = handlerContext.SentMessages
                    .Select(m => m.Message)
                    .OfType<PullClosedCollectionPageCommand>()
                    .ToList();
            }

            // pull pages of actuals and write to staging simulating parallel processing as best we can
            Parallel.ForEach(pageCommands, new ParallelOptions { MaxDegreeOfParallelism = 4 }, cmd =>
            {
                using (MonitoringDeliverablesDbContext dbContext = new MonitoringDeliverablesDbContext())
                {
                    Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
                    sessionConnectionFactoryMock
                        .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                        .Returns(new ConnectionInfo(null, dbContext.Database.Connection));

                    PullClosedCollectionPageHandler pullClosedCollectionPageHandler = new PullClosedCollectionPageHandler(
                        Mock.Of<ILogger>(),
                        dcAdapter,
                        sessionConnectionFactoryMock.Object,
                        new SummarisedActualsRepository());

                    pullClosedCollectionPageHandler.Handle(cmd, new TestableInvokeHandlerContext()).Wait();
                }
            });

            // assert all actuals are in staging
            using (MonitoringDeliverablesDbContext dbContext = new MonitoringDeliverablesDbContext())
            {
                int expectedTotalActuals = dbContext.ClosedCollections.Sum(cc => cc.TotalRowCount);
                int actualTotalActuals = dbContext.SummarisedActuals.Count();

                Assert.AreEqual(expectedTotalActuals, actualTotalActuals, "Not all actuals were stored in staging");
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DcAdapter_ShouldReturnEmptyCollectionWhenNoContentResponseReceived()
        {
            // the below setup allows us to point to PreProd
            ConfigurationManager.AppSettings["DCT:Oauth:ClientId"] = "5a3a8177-606b-433f-bbb6-de40f5f85329";
            ConfigurationManager.AppSettings["DCT:Oauth:Scope"] = "api://0176c049-ceea-4d25-a375-6b70d9dbae13/.default";
            ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"] = "";
            ConfigurationManager.AppSettings["DCT:Oauth:Tenant"] = "3aacc835-4b83-483d-841d-cd787f6f1486";
            ConfigurationManager.AppSettings["DCT:Url"] =
                "https://api-summarisedactuals.submitlearnerdatappbeta.fasst.org.uk";

            // These are the TST / OAT credentials 
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientId"] = "1352dba0-9cc1-47da-973b-b1cb5300f3ec";
            //ConfigurationManager.AppSettings["DCT:Oauth:Scope"] = "api://f937d85c-300c-4505-83c5-84ebb9d9c99c/.default";
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"] = "";
            //ConfigurationManager.AppSettings["DCT:Oauth:Tenant"] = "1a92889b-8ea1-4a16-8132-347814051567";
            //ConfigurationManager.AppSettings["DCT:Url"] =
            //    "https://dcol-tst-integrationapi-summarisedactuals-weu.tst.ase.dct.fasst.org.uk";

            // the below setup allows us to point to Prod
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientId"] = "4ffd25c2-e3ff-4ecd-ad9c-26f0124cb608";
            //ConfigurationManager.AppSettings["DCT:Oauth:Scope"] = "api://8c27edec-aaa9-49dc-8957-b89bc4d8ae5d/.default";
            //ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"] = "Alan has this";
            //ConfigurationManager.AppSettings["DCT:Oauth:Tenant"] = "3aacc835-4b83-483d-841d-cd787f6f1486";
            //ConfigurationManager.AppSettings["DCT:Url"] =
            //    "https://api-summarisedactuals.submitlearnerdatabeta.fasst.org.uk";

            // arrange
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true; // bypass self-signed SSL cert for now

            DcAdapter adapter = new DcAdapter(new HttpService(), new OAuthAccessTokenFactory());

            // act
            IReadOnlyCollection<DTOs.ClosedCollection> closedCollections =
                adapter.GetClosedCollectionsSince(new DateTime(2025, 01, 01, 00, 00, 00, DateTimeKind.Utc)).Result;

            // assert
            closedCollections.Should().NotBeNull("a non-null collection should be returned");
            closedCollections.Should().HaveCount(0, "an empty collection should be returned");
        }
    }
}
