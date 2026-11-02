namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using UnitTests.Common;

    [TestClass]
    public class DasMissingEventsTests
    {
        private const string ConnectionString =
            "#connectionstring#";
        [TestMethod, TestCategory("DataFix_R19c")]
        public void ShouldPopulateMissingEvents()
        {
            IEnumerable<EngagementEvent> allDasEvents = GetAllDasEvents();

            IEnumerable<EngagementEvent> paasDasEvents = GetEventsFromPaasDatabase();

            IEnumerable<EngagementEvent>  missingEvents = allDasEvents.Where(d => !paasDasEvents.Contains(d)).ToList();

            Assert.AreEqual(59, missingEvents.Count());

            missingEvents.ForEach(me => me.ProcessingState = EngagementEventProcessingState.ProviderNotFound);

            AddEventsToPaasDatabase(missingEvents);
        }

        private static IEnumerable<EngagementEvent> GetEventsFromPaasDatabase()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.Connection.ConnectionString = ConnectionString;
                return context.EngagementEvents.ToList();
            }
        }

        private static void AddEventsToPaasDatabase(IEnumerable<EngagementEvent> events)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.Connection.ConnectionString = ConnectionString;
                events.ForEach(e => context.EngagementEvents.Add(e));

                context.SaveChanges();
            }
        }

        private IEnumerable<EngagementEvent> GetAllDasEvents()
        {
            using (
                var resource = new TestResource("ContractRequestDomain.EngagementWatcher.Tests",
                    @"Resources.AllDasEvents.csv"))
            {
                StreamReader reader = new StreamReader(resource.Stream);
                reader.ReadLine();
                IList<string[]> dasEventLines = new List<string[]>();
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    dasEventLines.Add(line.Split(','));
                }

                return dasEventLines.Select(dasLine => new EngagementEvent(long.Parse(dasLine[0]), EngagementEvent.ValidEventType, dasLine[2]));
            }
        } 
    }
}
