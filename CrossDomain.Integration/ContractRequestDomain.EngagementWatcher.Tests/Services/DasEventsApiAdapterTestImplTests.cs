namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Dtos;
    using EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class DasEventsApiAdapterTestImplTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DasEventsApiAdapterTestImpl_ShouldRetrieveSomeEventsFromStorage()
        {
            // arrange
            const string tableName = "DasCommitmentStub";
            IAzureTableStore azureTableStore = new AzureTableStore();
            IEnvironmentContext environmentContext = new EnvironmentContext();

            RemoveAllEventsFromStorage(azureTableStore, environmentContext, tableName);
            AddEventsToStorage(numRecordsToCreate: 200, "INITIATED", environmentContext, azureTableStore, currentEventId: 1, tableName);

            var adapterTestImpl = new DasEventsApiAdapterTestImpl(azureTableStore, environmentContext);

            // act
            IList<EngagementEvent> returnedEvents = adapterTestImpl.GetEngagementEventsAfterId(0, 100).ToList();

            // assert
            Assert.IsNotNull(returnedEvents, "No EngagementEvents were returned");
            Assert.IsTrue(returnedEvents.Count > 1, "More EngagementEvents where expected to be returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasEventsApiAdapterTestImpl_ShouldRetrieveSpecificEventWithIdOf20()
        {
            // arrange
            const string tableName = "DasCommitmentStub";
            IAzureTableStore azureTableStore = new AzureTableStore();
            IEnvironmentContext environmentContext = new EnvironmentContext();

            RemoveAllEventsFromStorage(azureTableStore, environmentContext, tableName);
            AddEventsToStorage(numRecordsToCreate: 200, "INITIATED", environmentContext, azureTableStore, currentEventId: 1, tableName);

            var adapterTestImpl = new DasEventsApiAdapterTestImpl(azureTableStore, environmentContext);

            // act
            EngagementEvent event20 = adapterTestImpl.GetEngagementEventsAfterId(20, 100).First();

            // assert
            Assert.IsNotNull(event20, "Expected EngagementEvent was not returned");
            Assert.AreEqual(20, event20.EventId, "EngagementEvent EventId 20 was not returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasEventsApiAdapterTestImpl_ShouldRetrieveOneEventAndBeDeserialisedCorrectly()
        {
            // arrange
            const string tableName = "DasCommitmentStub";
            const string eventType = "DESERIALISED";
            const string expectedProviderId = "10000000";
            const long eventId = 60;

            IAzureTableStore azureTableStore = new AzureTableStore();
            IEnvironmentContext environmentContext = new EnvironmentContext();

            RemoveAllEventsFromStorage(azureTableStore, environmentContext, tableName);
            AddEventsToStorage(numRecordsToCreate: 1, eventType, environmentContext, azureTableStore, eventId, tableName);

            var adapterTestImpl = new DasEventsApiAdapterTestImpl(azureTableStore, environmentContext);

            // act
            IList<EngagementEvent> returnedEvents = adapterTestImpl.GetEngagementEventsAfterId(0, 100).ToList();

            // assert
            Assert.IsNotNull(returnedEvents, "No EngagementEvents were returned");
            Assert.IsTrue(returnedEvents.Count == 1, "Expected one EngagementEvent to be returned");

            var engagementEvent = returnedEvents.First();
            Assert.AreEqual(eventId, engagementEvent.EventId, "Returned EngagementEvent has incorrect EventId");
            Assert.AreEqual(eventType, engagementEvent.EventType, "Returned EngagementEvent has incorrect EventType");
            Assert.AreEqual(expectedProviderId, engagementEvent.ProviderId, "Returned EngagementEvent has incorrect ProviderId");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasEventsApiAdapterTestImpl_ShouldRetrieve100EventsUsingFromEventId20()
        {
            // arrange
            const string tableName = "DasCommitmentStub";
            IAzureTableStore azureTableStore = new AzureTableStore();
            IEnvironmentContext environmentContext = new EnvironmentContext();

            RemoveAllEventsFromStorage(azureTableStore, environmentContext, tableName);
            AddEventsToStorage(numRecordsToCreate: 200, "INITIATED", environmentContext, azureTableStore, currentEventId: 1, tableName);

            var adapterTestImpl = new DasEventsApiAdapterTestImpl(azureTableStore, environmentContext);

            // act
            IList<EngagementEvent> returnedEvents = adapterTestImpl.GetEngagementEventsAfterId(20, 100).ToList();

            // assert
            Assert.IsNotNull(returnedEvents, "No EngagementEvents were returned");
            Assert.AreEqual(100, returnedEvents.Count, "Incorrect number of EngagementEvents returned");
            Enumerable.Range(20, 100).ToList().ForEach(i => Assert.IsNotNull(returnedEvents.SingleOrDefault(e => e.EventId == i), "Incorrect EventId returned"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasEventsApiAdapterTestImpl_ShouldNotExceptionWhenOutOfRangeParametersArePassed()
        {
            // arrange
            const string tableName = "DasCommitmentStub";
            IAzureTableStore azureTableStore = new AzureTableStore();
            IEnvironmentContext environmentContext = new EnvironmentContext();

            RemoveAllEventsFromStorage(azureTableStore, environmentContext, tableName);
            AddEventsToStorage(numRecordsToCreate: 200, "INITIATED", environmentContext, azureTableStore, currentEventId: 1, tableName);

            var adapterTestImpl = new DasEventsApiAdapterTestImpl(azureTableStore, environmentContext);

            // act
            IList<EngagementEvent> returnedEvents = adapterTestImpl.GetEngagementEventsAfterId(100000, 100).ToList();

            // assert
            Assert.IsNotNull(returnedEvents, "No EngagementEvents were returned");
            Assert.AreEqual(0, returnedEvents.Count, "Incorrect number of EngagementEvents returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DasEventsApiAdapterTestImpl_ShouldRetrieveAllEventsInPagesOf10ByIncrementingEventId()
        {
            // arrange
            const string tableName = "DasCommitmentStub";
            IAzureTableStore azureTableStore = new AzureTableStore();
            IEnvironmentContext environmentContext = new EnvironmentContext();

            RemoveAllEventsFromStorage(azureTableStore, environmentContext, tableName);
            AddEventsToStorage(numRecordsToCreate: 400, "INITIATED", environmentContext, azureTableStore, currentEventId: 1, tableName);

            var adapterTestImpl = new DasEventsApiAdapterTestImpl(azureTableStore, environmentContext);

            const int totalEvents = 400;
            var pagedEvents = new List<EngagementEvent>();
            long fromEventId = 1;
            const int pageSize = 100;

            // act
            do
            {
                IList<EngagementEvent> pageOfEvents = adapterTestImpl.GetEngagementEventsAfterId(fromEventId, 100).ToList();
                pagedEvents.AddRange(pageOfEvents);

                if (pageOfEvents.Count < pageSize)
                {
                    break;
                }

                fromEventId = pageOfEvents.Max(e => e.EventId) + 1;

            } while (true);

            // assert
            Assert.IsNotNull(pagedEvents, "No EngagementEvents were returned");
            Assert.AreEqual(totalEvents, pagedEvents.Count, "Incorrect total number of EngagementEvents returned");
            Assert.AreEqual(pagedEvents.Count, pagedEvents.Select(e => e.EventId).Distinct().Count(), 
                "Incorrect number of distinct EngagementEvents returned");
        }

        private static void AddEventsToStorage(int numRecordsToCreate, string eventType, IEnvironmentContext environmentContext, 
            IAzureTableStore azureTableStore, long currentEventId, string tableName)
        {
            var dasAgreementEntities = new List<DasAgreementEntity>();

            for (long i = 0; i < numRecordsToCreate; i++)
            {
                var agreement = new AgreementEventView
                {
                    Event = eventType,
                    Id = currentEventId,
                    ProviderId = (10000000 + i).ToString()
                };

                dasAgreementEntities.Add(new DasAgreementEntity(agreement.Id, JsonConvert.SerializeObject(agreement)));
                currentEventId++;
            }

            azureTableStore.CreateRows(tableName + environmentContext.StorageTableSuffix, dasAgreementEntities);
        }

        public void RemoveAllEventsFromStorage(IAzureTableStore azureTableStore, IEnvironmentContext environmentContext, string tableName)
        {
            azureTableStore.DeleteAllRows<DasAgreementEntity>(tableName + environmentContext.StorageTableSuffix);
        }
    }
}