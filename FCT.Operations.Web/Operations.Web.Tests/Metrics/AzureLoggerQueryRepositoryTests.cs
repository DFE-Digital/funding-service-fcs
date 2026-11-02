namespace Operations.Web.Tests.Metrics
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Repositories;

    [TestClass]
    public class AzureLoggerQueryRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AzureLoggerQueryRepository_GetLogEntriesBetweenDates_ShouldGetEntries()
        {
            AzureLoggerQueryRepository repository = new AzureLoggerQueryRepository();
            DateTime start = new DateTime(2019, 12,1, 0,0,0, DateTimeKind.Utc);
            DateTime end = start.AddDays(1);

            IReadOnlyCollection<StorageLogEntry>[] entries = repository.GetLogEntriesBetweenDates(start, end).Result;

            Assert.AreEqual(61478, entries.Sum(e => e.Count));
        }
    }
}
