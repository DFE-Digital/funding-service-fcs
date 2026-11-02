namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ContractManagementService.Common;
    using System.Linq;

    [TestClass]
    public class ContractManagementLoggingEventsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NoDuplicateContractManagementDomainLoggingEventIds()
        {
            var loggingEvents = new ContractManagementLoggingEvents();

            var idNos = typeof(ContractManagementLoggingEvents).GetFields().Select(field => (int)field.GetValue(loggingEvents)).ToList();

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