namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DasRequestServiceTests
    {
        private Mock<IEngagementEventRepository> _engagementEventRepositoryMock;
        private Mock<IFundingTypeFundingPeriodQueryRepository> _fundingTypeFundingPeriodQueryRepository;
        private Mock<IDasEventsApiAdapter> _dasEventsApiAdapter;
        private Mock<ILogger> _logger;
        private List<EngagementEvent> _dasApiEngagementEvents;
        private IDasRequestService _dasRequestService;

        [TestInitialize]
        public void TestInitialize()
        {
            _logger = new Mock<ILogger>();
            _engagementEventRepositoryMock = new Mock<IEngagementEventRepository>();
            _engagementEventRepositoryMock
                .Setup(m => m.GetMaxEventId(It.IsAny<ConnectionInfo>()))
                .Returns(50000);

            _fundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            _fundingTypeFundingPeriodQueryRepository
                .Setup(m => m.Get(It.Is<string>(s => s == "LEVY"), It.Is<string>(s => s == "LEVY1799")))
                .Returns(new FundingTypeFundingPeriod
                {
                    FundingTypeCode = "LEVY",
                    FundingPeriodName = "LEVY1799",
                    DefaultContractStartDate = new DateTime(2017, 05, 01, 0, 0, 0, DateTimeKind.Utc)
                });

            _dasEventsApiAdapter = new Mock<IDasEventsApiAdapter>();
            _dasApiEngagementEvents = new List<EngagementEvent>
            {
                new EngagementEvent(eventId: 1, eventType: "CREATED", providerId: "12345"),
                new EngagementEvent(eventId: 2, eventType: "INITIATED", providerId: "23456"),
                new EngagementEvent(eventId: 3, eventType: "INITIATED", providerId: "34567"),
                new EngagementEvent(eventId: 4, eventType: "CREATED", providerId: "45678")
            };
            _dasEventsApiAdapter
                .Setup(m => m.GetEngagementEventsAfterId(It.IsAny<long>(), It.IsAny<int>()))
                .Returns(_dasApiEngagementEvents);

            _engagementEventRepositoryMock.Setup(
                r => r.FindProvidersAlreadyInFlight(It.IsAny<IReadOnlyCollection<EngagementEvent>>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<string>());

            _engagementEventRepositoryMock.Setup(m => m.GetById(It.IsAny<long>(), It.IsAny<ConnectionInfo>()))
                                          .ReturnsAsync(new EngagementEvent(1234, "INITIATED", "12345678"));

            _dasRequestService = new DasRequestService(
                _engagementEventRepositoryMock.Object,
                _fundingTypeFundingPeriodQueryRepository.Object,
                _dasEventsApiAdapter.Object,
                _logger.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_ShouldInvokeDasEventsApiAdapterWithMaxStoredEventIdIncrementedByOne()
        {
            // act
            _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateDefault());

            // assert
            _dasEventsApiAdapter.Verify(
                m => m.GetEngagementEventsAfterId(It.Is<long>(l => l == 50001), It.IsAny<int>()),
                Times.Once,
                "DasEventsApiAdapter was not called with max stored EventId incremented by 1.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_ShouldInvokeDasEventsApiAdapterWithGivenPageSize()
        {
            // act
            _dasRequestService.GetLatestDasRequests(75, ConnectionInfo.CreateDefault());

            // assert
            _dasEventsApiAdapter.Verify(
                m => m.GetEngagementEventsAfterId(It.IsAny<long>(), It.Is<int>(i => i == 75)),
                Times.Once,
                "DasEventsApiAdapter was not called with given page size.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_ShouldCallRepositoryWithEngagementEventsReturnedFromDasEventsApiAdapter()
        {
            // arrange
            IEnumerable<EngagementEvent> eventsPassedToRepositoryToStore = new List<EngagementEvent>();

            _engagementEventRepositoryMock
                .Setup(m => m.AddRange(It.IsAny<IEnumerable<EngagementEvent>>(), It.IsAny<ConnectionInfo>()))
                .Callback((IEnumerable<EngagementEvent> events, ConnectionInfo ci) => eventsPassedToRepositoryToStore = events);
            
            // act
            _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(_dasApiEngagementEvents.Count, eventsPassedToRepositoryToStore.Count(),
                "EngagementEventRepository was not given the same number of events returned from the DasEventsApiAdapter.");

            Assert.IsTrue(_dasApiEngagementEvents.All(e => eventsPassedToRepositoryToStore.Contains(e)),
                 "An event retrieved from DAS Api was not given to repository to store.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_ShouldReturnInitiatedDasRequestsCorrectlyTransformedFromEngagementEventsReturnedFromDasEventsApiAdapterWithPolicyConfigApplied()
        {
            // act
            DasRequestsResult returnedDasRequests = _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.AreEqual(_dasApiEngagementEvents.Count(e => e.EventType == "INITIATED"), returnedDasRequests.InitiatedEngagementEventsReceived.Count,
                "GetLatestDasRequests did not return the same number of INITIATED events returned from the DasEventsApiAdapter.");

            _dasApiEngagementEvents
                .Where(e => e.EventType == "INITIATED")
                .ForEach(eventRetrievedFromDasApi =>
                {
                    DasRequest correspondingDasRequest = returnedDasRequests.InitiatedEngagementEventsReceived.SingleOrDefault(dr =>
                        dr.FundingType == "LEVY" &&
                        dr.StartDate == new DateTime(2017, 05, 01, 0, 0, 0, DateTimeKind.Utc) &&
                        dr.Ukprn == int.Parse(eventRetrievedFromDasApi.ProviderId));
                    Assert.IsNotNull(correspondingDasRequest, "An INITIATED event retrieved from DAS Api was not returned from GetLatestDasRequests.");
                });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_ShouldReturnInitiatedDasRequestsAndATotalOfAllRequestsReceived()
        {
            // act
            IReadOnlyCollection<DasRequest> returnedDasRequests = _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateDefault()).Result.InitiatedEngagementEventsReceived;

            // assert
            Assert.AreEqual(_dasApiEngagementEvents.Count(e => e.EventType == "INITIATED"), returnedDasRequests.Count,
                "GetLatestDasRequests did not return the same number of INITIATED events returned from the DasEventsApiAdapter.");

            _dasApiEngagementEvents
                .Where(e => e.EventType == "INITIATED")
                .ForEach(eventRetrievedFromDasApi =>
                {
                    DasRequest correspondingDasRequest = returnedDasRequests.SingleOrDefault(dr =>
                        dr.FundingType == "LEVY" &&
                        dr.StartDate == new DateTime(2017, 05, 01, 0, 0, 0, DateTimeKind.Utc) &&
                        dr.Ukprn == int.Parse(eventRetrievedFromDasApi.ProviderId));
                    Assert.IsNotNull(correspondingDasRequest, "An INITIATED event retrieved from DAS Api was not returned from GetLatestDasRequests.");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasRequestService_GetLatestDasRequests_ShouldReturnAListWithoutDuplicates()
        {
            // arrange
            _dasApiEngagementEvents = new List<EngagementEvent>
            {
                new EngagementEvent(eventId: 3, eventType: "CREATED", providerId: "12345"),
                new EngagementEvent(eventId: 4, eventType: "INITIATED", providerId: "23456"),
                new EngagementEvent(eventId: 5, eventType: "INITIATED", providerId: "34568"),
                new EngagementEvent(eventId: 6, eventType: "INITIATED", providerId: "34568"),
                new EngagementEvent(eventId: 7, eventType: "INITIATED", providerId: "34567"),
                new EngagementEvent(eventId: 8, eventType: "CREATED", providerId: "45678")
            };
            _dasEventsApiAdapter
                .Setup(m => m.GetEngagementEventsAfterId(It.IsAny<long>(), It.IsAny<int>()))
                .Returns(_dasApiEngagementEvents);

            var eventsInDatabase = new List<EngagementEvent>
            {
                new EngagementEvent(eventId: 1, eventType: "INITIATED", providerId: "34567"), // this is a duplicate
                new EngagementEvent(eventId: 2, eventType: "INITIATED", providerId: "2345678"),
            };

            IReadOnlyCollection<DasRequest> returnedDasRequests = null;
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");
                IEngagementEventRepository repository = new EngagementEventRepository(context);
                repository.AddRange(eventsInDatabase, ConnectionInfo.CreateFrom(context.Database.Connection));
                _dasRequestService = new DasRequestService(repository, _fundingTypeFundingPeriodQueryRepository.Object, _dasEventsApiAdapter.Object,
                    _logger.Object);

                var connectionInfo = ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));
                
                // act
                returnedDasRequests = _dasRequestService.GetLatestDasRequests(100, connectionInfo).Result.InitiatedEngagementEventsReceived;
            }

            // assert
            Assert.AreEqual(2, returnedDasRequests.Count,  "The number of requests returned is not correct");
            IReadOnlyCollection<int> ukprnsReturned = returnedDasRequests.Select(dr => dr.Ukprn).ToList();

            Assert.IsTrue(ukprnsReturned.Contains(23456) && ukprnsReturned.Contains(34568) , "The request returned ehe wrong providers");

            List<int> countOfUkprnGroups = returnedDasRequests.GroupBy(dr => dr.Ukprn).Select(g => g.Count()).ToList();

            Assert.IsTrue(countOfUkprnGroups.All(c => c == 1), "we have a group with more than 1");

            // now check the database has the right events flagged as duplicate
            using (var context = new ContractManagementDbContext())
            {
                var duplicateEvents = context.EngagementEvents.Where(ee => ee.ProcessingState == EngagementEventProcessingState.Duplicate).ToList();
                var duplicateProviders = duplicateEvents.Select(de => de.ProviderId).ToList();
                Assert.AreEqual(2, duplicateEvents.Count, "The wrong number of duplicate events is in the ee table");
                Assert.IsTrue(duplicateProviders.Contains("34568") && duplicateProviders.Contains("34567"), "The wrong providers have been marked with duplicate");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasRequestService_GetLatestDasRequests_ShouldMarkInvalidEventsInTheTable()
        {
            // arrange
            _dasApiEngagementEvents = new List<EngagementEvent>
            {
                new EngagementEvent(eventId: 3, eventType: "Initiated", providerId: "12345"),
                new EngagementEvent(eventId: 4, eventType: "INITIATED", providerId: "23456"),
                new EngagementEvent(eventId: 5, eventType: "INITIATED", providerId: "34568"),
                new EngagementEvent(eventId: 6, eventType: "INITIATED", providerId: "34568"),
                new EngagementEvent(eventId: 7, eventType: "INITIATED", providerId: "34567"),
                new EngagementEvent(eventId: 8, eventType: "CREATED", providerId: "45678")
            };
            _dasEventsApiAdapter
                .Setup(m => m.GetEngagementEventsAfterId(It.IsAny<long>(), It.IsAny<int>()))
                .Returns(_dasApiEngagementEvents);

            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");
                IEngagementEventRepository repository = new EngagementEventRepository(context);
                _dasRequestService = new DasRequestService(repository, _fundingTypeFundingPeriodQueryRepository.Object, _dasEventsApiAdapter.Object,
                    _logger.Object);
                // act
                _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateFrom(context.Database.Connection)).Wait();
            }

            // assert
            using (var context = new ContractManagementDbContext())
            {
                var invalidEvents = context.EngagementEvents.Where(ee => ee.ProcessingState == EngagementEventProcessingState.Invalid).ToList();
                var invalidEventIds = invalidEvents.Select(ie => ie.EventId).ToList();
                Assert.AreEqual(2, invalidEvents.Count, "The wrong number of invalid events is in the ee table");
                Assert.IsTrue(invalidEventIds.Contains(3) && invalidEventIds.Contains(8), "The wrong events have been marked with invalid");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_ShouldResolveSuccessfullyFromEngagementWatcherEndpointContainer()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new IoC.WindsorInstaller(new LoggerFactory())))
            {
                using (container.BeginScope())
                {
                    container.Resolve<IDasRequestService>();
                }
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_WhenHighestStoredEventIdLessThan33844_ShouldRequestEngagementEventsFrom33844Onwards()
        {
            const int highestStoredEventId = 15593;

            // arrange
            _engagementEventRepositoryMock
                .Setup(m => m.GetMaxEventId(It.IsAny<ConnectionInfo>()))
                .Returns(highestStoredEventId);

            // act
            _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateDefault());

            // assert
            _dasEventsApiAdapter.Verify(
                m => m.GetEngagementEventsAfterId(33844, It.IsAny<int>()),
                "DasEventsApiAdapter was not called with expected fromEventId");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_WhenHighestStoredEventIdGreaterThan33844_ShouldRequestEngagementEventsFromStoredMaximumEventIdPlusOne()
        {
            const int highestStoredEventId = 40000;

            // arrange
            _engagementEventRepositoryMock
                .Setup(m => m.GetMaxEventId(It.IsAny<ConnectionInfo>()))
                .Returns(highestStoredEventId);

            // act
            _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateDefault());

            // assert
            _dasEventsApiAdapter.Verify(
                m => m.GetEngagementEventsAfterId(highestStoredEventId + 1, It.IsAny<int>()),
                "DasEventsApiAdapter was not called with expected fromEventId");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetLatestDasRequests_WhenHighestStoredEventIdEqualTo33844_ShouldRequestEngagementEventsFromStoredMaximumEventIdPlusOne()
        {
            const int highestStoredEventId = 33844;

            // arrange
            _engagementEventRepositoryMock
                .Setup(m => m.GetMaxEventId(It.IsAny<ConnectionInfo>()))
                .Returns(highestStoredEventId);

            // act
            _dasRequestService.GetLatestDasRequests(100, ConnectionInfo.CreateDefault());

            // assert
            _dasEventsApiAdapter.Verify(
                m => m.GetEngagementEventsAfterId(highestStoredEventId + 1, It.IsAny<int>()),
                "DasEventsApiAdapter was not called with expected fromEventId");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetProviderNotFoundEvents_ShouldNotIncludeDuplicates()
        {
            const string newProvider1 = "101";
            const string newProvider2 = "103";
            // arrange
            _engagementEventRepositoryMock
                .Setup(m => m.FindEventsWhereProviderIsNotFound(It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<EngagementEvent>
                {
                    new EngagementEvent(-100, "INITIATED", newProvider1),
                    new EngagementEvent(-101, "INITIATED", newProvider1),
                    new EngagementEvent(-102, "INITIATED", newProvider1),
                    new EngagementEvent(-103, "INITIATED", newProvider2),
                });

            // act
            DasRequestsResult dasRequestsResult = _dasRequestService.GetProviderNotFoundEvents(ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.AreEqual(2, dasRequestsResult.TotalEventsReceived, "The number of events for provider not found is incorrect");
            Assert.IsTrue(dasRequestsResult.InitiatedEngagementEventsReceived.Any(e => e.Ukprn == int.Parse(newProvider1)), $"The provider: {newProvider1} is not found");
            Assert.IsTrue(dasRequestsResult.InitiatedEngagementEventsReceived.Any(e => e.Ukprn == int.Parse(newProvider2)), $"The provider: {newProvider2} is not found");
            Assert.AreEqual(2, dasRequestsResult.DuplicateEvents.Count, "The number of DuplicateEvents is incorrect");
            Assert.IsTrue(dasRequestsResult.DuplicateEvents.Contains(-101), "The DuplicateEvents are not correct, -101 not present");
            Assert.IsTrue(dasRequestsResult.DuplicateEvents.Contains(-102), "The DuplicateEvents are not correct, -102 not present");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetProviderNotFoundEvents_ShouldWorkWhenThereIsJustOne()
        {
            const string newProvider1 = "101";
            // arrange
            _engagementEventRepositoryMock
                .Setup(m => m.FindEventsWhereProviderIsNotFound(It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<EngagementEvent>
                {
                    new EngagementEvent(-100, "INITIATED", newProvider1),
                });

            // act
            DasRequestsResult dasRequestsResult = _dasRequestService.GetProviderNotFoundEvents(ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.AreEqual(1, dasRequestsResult.TotalEventsReceived, "The number of events for provider not found is incorrect");
            Assert.IsTrue(dasRequestsResult.InitiatedEngagementEventsReceived.Any(e => e.Ukprn == int.Parse(newProvider1)), $"The provider: {newProvider1} is not found");
            Assert.AreEqual(0, dasRequestsResult.DuplicateEvents.Count, "The number of DuplicateEvents is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_GetProviderNotFoundEvents_ShouldWorkWhenThereAreMany()
        {
            const string newProvider1 = "101";
            const string newProvider2 = "102";
            const string newProvider3 = "103";


            // arrange
            _engagementEventRepositoryMock
                .Setup(m => m.FindEventsWhereProviderIsNotFound(It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<EngagementEvent>
                {
                    new EngagementEvent(-100, "INITIATED", newProvider1),
                    new EngagementEvent(-101, "INITIATED", newProvider2),
                    new EngagementEvent(-102, "INITIATED", newProvider3),
                });

            // act
            DasRequestsResult dasRequestsResult = _dasRequestService.GetProviderNotFoundEvents(ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.AreEqual(3, dasRequestsResult.TotalEventsReceived, "The number of events for provider not found is incorrect");
            Assert.IsTrue(dasRequestsResult.InitiatedEngagementEventsReceived.Any(e => e.Ukprn == int.Parse(newProvider1)), $"The provider: {newProvider1} is not found");
            Assert.IsTrue(dasRequestsResult.InitiatedEngagementEventsReceived.Any(e => e.Ukprn == int.Parse(newProvider2)), $"The provider: {newProvider2} is not found");
            Assert.IsTrue(dasRequestsResult.InitiatedEngagementEventsReceived.Any(e => e.Ukprn == int.Parse(newProvider3)), $"The provider: {newProvider3} is not found");
            Assert.AreEqual(0, dasRequestsResult.DuplicateEvents.Count, "The number of DuplicateEvents is incorrect");
        }
    }
}
