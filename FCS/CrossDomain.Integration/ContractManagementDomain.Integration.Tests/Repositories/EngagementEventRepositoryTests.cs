namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Validation;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Optional;

    [TestClass]
    public class EngagementEventRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_ShouldGetMaxEventId()
        {
            try
            {
                // arrange
                const int numEventstoAdd = 43;
                int eventId = 42;
                using (var context = new ContractManagementDbContext())
                {
                    context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");
                    for (int numEventsAdded = 0; numEventsAdded < numEventstoAdd; numEventsAdded++)
                    {
                        context.EngagementEvents.Add(new EngagementEvent(++eventId, "ET", "p1"));
                    }

                    context.SaveChanges();
                }

                long maxEventId = 0;
                using (var context = new ContractManagementDbContext())
                {
                    IEngagementEventRepository repository = new EngagementEventRepository(context);
                    // act
                    maxEventId = repository.GetMaxEventId(ConnectionInfo.CreateFrom(context.Database.Connection));
                }

                // assert
                Assert.AreEqual(eventId, maxEventId);
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                var fullErrorMessage = String.Join("; ", errorMessages);

                var exceptionMessage = String.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                Assert.Fail(exceptionMessage);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_ShouldGetMaxEventIdOfZeroWhenThereAreNoEventsStored()
        {
            // arrange      
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");
            }

            long maxEventId = 0;
            using (var context = new ContractManagementDbContext())
            {
                IEngagementEventRepository repository = new EngagementEventRepository(context);
                // act
                maxEventId = repository.GetMaxEventId(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.AreEqual(0, maxEventId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_ShouldAddRange()
        {
            try
            {
                // arrange
                const int numEventstoAdd = 43;
                using (var context = new ContractManagementDbContext())
                {
                    context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");
                }
                                  
                IList<EngagementEvent> engagementEvents = new List<EngagementEvent>();
                for (int eventId = 0; eventId < numEventstoAdd; eventId++)
                {
                    engagementEvents.Add(new EngagementEvent(eventId, "ET", "p1"));
                }
                using (var context = new ContractManagementDbContext())
                {
                    // act
                    IEngagementEventRepository repository = new EngagementEventRepository(context);
                    repository.AddRange(engagementEvents, ConnectionInfo.CreateFrom(context.Database.Connection));
                }

                // assert
                using (var context = new ContractManagementDbContext())
                {
                    Assert.AreEqual(numEventstoAdd, context.EngagementEvents.Count());
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                var fullErrorMessage = String.Join("; ", errorMessages);

                var exceptionMessage = String.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                Assert.Fail(exceptionMessage);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_ShouldFindMatchingUkprnsAlreadyInFlight()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");
                
                context.EngagementEvents.Add(new EngagementEvent(1, EngagementEvent.ValidEventType, "1234567"));
                context.EngagementEvents.Add(new EngagementEvent(2, EngagementEvent.ValidEventType, "1234568"));
                context.EngagementEvents.Add(new EngagementEvent(3, EngagementEvent.ValidEventType, "1234569"));
                context.EngagementEvents.Add(new EngagementEvent(4, EngagementEvent.ValidEventType, "1234568"));
                context.EngagementEvents.Add(new EngagementEvent(5, EngagementEvent.ValidEventType, "1234569"));
                context.EngagementEvents.Add(new EngagementEvent(6, EngagementEvent.ValidEventType, "1234560"));
                context.EngagementEvents.Add(new EngagementEvent(7, "Some other", "1234561"));
                context.SaveChanges();
            }

            IReadOnlyCollection<string> matchingProvidersInFlight = null;
            using (var context = new ContractManagementDbContext())
            {
                List<EngagementEvent> engagementEvents = new List<EngagementEvent>
                {
                    new EngagementEvent(4, EngagementEvent.ValidEventType, "1234568"),
                    new EngagementEvent(5, EngagementEvent.ValidEventType, "1234569"),
                    new EngagementEvent(6, EngagementEvent.ValidEventType, "1234560"),
                    new EngagementEvent(7, "Some Other", "1234561"),
                };

                IEngagementEventRepository repository = new EngagementEventRepository(context);
                // act
                matchingProvidersInFlight = repository.FindProvidersAlreadyInFlight(engagementEvents, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.AreEqual(2, matchingProvidersInFlight.Count, "The number of matching engagments is not correct");
            
            Assert.IsTrue(matchingProvidersInFlight.Contains("1234568") && matchingProvidersInFlight.Contains("1234569"), "The matching providers are not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_ShouldFindEngagementEventsWhereProviderWasNotFound()
        {
            // arrange
            IReadOnlyCollection<EngagementEvent> engagementEvents;

            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");

                context.EngagementEvents.Add(new EngagementEvent(1, EngagementEvent.ValidEventType, "1234567"));
                context.EngagementEvents.Add(new EngagementEvent(2, EngagementEvent.ValidEventType, "1234568") {ProcessingState = EngagementEventProcessingState.ProviderNotFound});
                context.EngagementEvents.Add(new EngagementEvent(3, EngagementEvent.ValidEventType, "1234569") { ProcessingState = EngagementEventProcessingState.ProviderNotFound });

                context.SaveChanges();

                IEngagementEventRepository repository = new EngagementEventRepository(context);

                // act
                using (var context2 = new ContractManagementDbContext())
                {
                    engagementEvents = repository.FindEventsWhereProviderIsNotFound(ConnectionInfo.CreateFrom(context2.Database.Connection)).Result;
                }
            }

            Assert.AreEqual(2, engagementEvents.Count, "The number of matching engagments is not correct");
            Assert.IsTrue(engagementEvents.Any(e => e.EventId == 2) && engagementEvents.Any(e => e.EventId == 3), "The matching engagements are not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_ShouldMarkEventsAsDuplicate()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");

                context.EngagementEvents.Add(new EngagementEvent(1, EngagementEvent.ValidEventType, "1234567"));
                context.EngagementEvents.Add(new EngagementEvent(2, EngagementEvent.ValidEventType, "1234568")
                    {ProcessingState = EngagementEventProcessingState.ProviderNotFound});
                context.EngagementEvents.Add(new EngagementEvent(3, EngagementEvent.ValidEventType, "1234569")
                    {ProcessingState = EngagementEventProcessingState.ProviderNotFound});

                context.SaveChanges();
            }

            var eventIdsToMarkAsDuplicate = new List<long>{1, 2};
            using (var context = new ContractManagementDbContext())
            {
                IEngagementEventRepository repository = new EngagementEventRepository(context);

                // act
                repository.MarkEventsAsDuplicate(eventIdsToMarkAsDuplicate, ConnectionInfo.CreateFrom(context.Database.Connection)).Wait();
            }

            // assert
            using (var context = new ContractManagementDbContext())
            {
                var duplicates = context.EngagementEvents.Where(ee => ee.ProcessingState == EngagementEventProcessingState.Duplicate).ToList();
                Assert.AreEqual(eventIdsToMarkAsDuplicate.Count, duplicates.Count, "The number of duplicates is not right");
                Assert.IsTrue(eventIdsToMarkAsDuplicate.All(d => duplicates.Select(e => e.EventId).Contains(d)), "Not all the expected duplicates are present");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_MarkEventsAsDuplicate_ShouldNotThrowExceptionIfThereAreNoDuplicates()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[EngagementEvent]");

                context.EngagementEvents.Add(new EngagementEvent(1, EngagementEvent.ValidEventType, "1234567"));
                context.EngagementEvents.Add(new EngagementEvent(2, EngagementEvent.ValidEventType, "1234568")
                    { ProcessingState = EngagementEventProcessingState.ProviderNotFound });
                context.EngagementEvents.Add(new EngagementEvent(3, EngagementEvent.ValidEventType, "1234569")
                    { ProcessingState = EngagementEventProcessingState.ProviderNotFound });

                context.SaveChanges();
            }

            var eventIdsToMarkAsDuplicate = new List<long>();
            using (var context = new ContractManagementDbContext())
            {
                IEngagementEventRepository repository = new EngagementEventRepository(context);

                // act
                repository.MarkEventsAsDuplicate(eventIdsToMarkAsDuplicate, ConnectionInfo.CreateFrom(context.Database.Connection)).Wait();
            }

            // assert
            using (var context = new ContractManagementDbContext())
            {
                var duplicates = context.EngagementEvents.Where(ee => ee.ProcessingState == EngagementEventProcessingState.Duplicate).ToList();
                Assert.AreEqual(eventIdsToMarkAsDuplicate.Count, duplicates.Count, "The number of duplicates is not right");
            }
        }
    }
}
