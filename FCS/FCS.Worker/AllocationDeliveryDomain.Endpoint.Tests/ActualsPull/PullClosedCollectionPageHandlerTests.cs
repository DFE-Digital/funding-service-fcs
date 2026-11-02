namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Dapper;
    using Endpoint.ActualsPull;
    using Endpoint.ActualsPull.Adapters;
    using Endpoint.ActualsPull.Handlers;
    using Endpoint.Infrastructure;
    using Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PullClosedCollectionPageHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PullClosedCollectionPageHandler_ShouldResolve()
        {
            ConfigurationManager.AppSettings["DCT:UseStub"] = "false";

            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(l => l.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(loggerFactoryMock.Object))
                .Register(Component.For<PullClosedCollectionPageHandler>().ImplementedBy<PullClosedCollectionPageHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<PullClosedCollectionPageHandler>();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PullClosedCollectionPageHandler_ShouldWriteActualsReturnFromAdapterToDb()
        {
            const string collectionType = "CT";
            const string collectionReturnCode = "CRC";

            ClearAllSummarisedActuals();
            ClearClosedCollections();
            InsertClosedCollection(collectionType, collectionReturnCode, DateTime.Now);
            var connection = new SqlConnection(ConnectionString);
            connection.Open();
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IDcAdapter> mockDcAdapter = new Mock<IDcAdapter>();
            Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            mockSessionConnectionFactory.Setup(cf => cf.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, connection));

            var summarisedActual = new SummarisedActual
            {
                CollectionType = collectionType,
                Period = 202004,
                DeliverableCode = 1,
                CollectionReturnCode = collectionReturnCode,
                ActualValue = 1,
                ActualVolume = 2,
                ContractAllocationNumber = "CA",
                DataCollectionsId = 12,
                FundingStreamPeriodCode = "FSP",
                OrganisationId = "123",
                UopCode = "UOP"
            };
            mockDcAdapter
                .Setup(a => a.GetClosedCollectionsPage(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .ReturnsAsync(new List<SummarisedActual>
                {
                    summarisedActual
                });

            PullClosedCollectionPageHandler handler = new PullClosedCollectionPageHandler(Mock.Of<ILogger>(), mockDcAdapter.Object, mockSessionConnectionFactory.Object, new SummarisedActualsRepository());
            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new PullClosedCollectionPageCommand
            {
                CollectionType = collectionType,
                CollectionReturnCode = collectionReturnCode
            }, context).Wait();

            // assert
            var actuals = GetSummarisedActuals();
            Assert.AreEqual(1, actuals.Count, "The is an incorrect number of actuals");
            Assert.AreEqual(summarisedActual.ActualValue, actuals.First().ActualValue, "The ActualValue is incorrect");
            Assert.AreEqual(summarisedActual.ActualVolume, actuals.First().ActualVolume, "The ActualVolume is incorrect");
            Assert.AreEqual(summarisedActual.CollectionReturnCode, actuals.First().CollectionReturnCode, "The CollectionReturnCode is incorrect");
            Assert.AreEqual(summarisedActual.CollectionType, actuals.First().CollectionType, "The CollectionType is incorrect");
            Assert.AreEqual(summarisedActual.ContractAllocationNumber, actuals.First().ContractAllocationNumber, "The ContractAllocationNumber is incorrect");
            Assert.AreEqual(summarisedActual.DeliverableCode, actuals.First().DeliverableCode, "The DeliverableCode is incorrect");
            Assert.AreEqual(summarisedActual.FundingStreamPeriodCode, actuals.First().FundingStreamPeriodCode, "The FundingStreamPeriodCode is incorrect");
            Assert.AreEqual(summarisedActual.DataCollectionsId, actuals.First().DataCollectionsId, "The DataCollectionsId is incorrect");
            Assert.AreEqual(summarisedActual.OrganisationId, actuals.First().OrganisationId, "The OrganisationId is incorrect");
            Assert.AreEqual(summarisedActual.Period, actuals.First().Period, "The Period is incorrect");
            Assert.AreEqual(summarisedActual.UopCode, actuals.First().UopCode, "The UopCode is incorrect");
        }

    private void ClearAllSummarisedActuals()
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            const string sql = @"DELETE 
                    FROM [MonitoringDeliverables].[SummarisedActual]";

            connection.Execute(sql);
        }
    }

    private void ClearClosedCollections()
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            const string sql = @"DELETE 
                    FROM [MonitoringDeliverables].[ClosedCollection]";

            connection.Execute(sql);
        }
    }

    private void InsertClosedCollection(string collectionType, string collectionReturnCode, DateTime closedTime)
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            const string sql = @"insert into [MonitoringDeliverables].[ClosedCollection]
                    (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount)
                    values (@collectionType, @collectionReturnCode, @closedTime, 0, 0)";

            connection.Execute(sql, new { collectionType, collectionReturnCode, closedTime });
        }
    }

    private IReadOnlyCollection<SummarisedActual> GetSummarisedActuals()
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            const string sql = @"select * from [MonitoringDeliverables].[SummarisedActual]";

            return connection.Query<SummarisedActual>(sql).ToList();
        }
    }

        private string ConnectionString =>
            ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;
    }
}
