namespace DocumentsDomain.Common.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Linq;
    using SFA.FCT.DocumentsDomain.Common;

    [TestClass]
    public class DocumentsDomainLoggingEventIdTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NoDuplicateDocumentsDomainLoggingEventIds()
        {
            var loggingEvents = new DocumentsDomainLoggingEventId();

            var idNos = typeof(DocumentsDomainLoggingEventId).GetFields().Select(field => (int)field.GetValue(loggingEvents)).ToList();

            var groupedIdNos = idNos.GroupBy(i => i).Select(x => new
            {
                IdNo = x.Key,
                Count = x.Count()
            }).ToList();

            groupedIdNos.ForEach(gi =>
            {
                Assert.IsTrue(gi.Count == 1, $"Duplicate Event Id for {gi.IdNo}");
            });
        }
    }
}
