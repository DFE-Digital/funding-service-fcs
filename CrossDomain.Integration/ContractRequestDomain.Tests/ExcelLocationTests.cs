namespace ContractRequestDomain.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Common;

    [TestClass]
    public class ExcelLocationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ToString_ReturnsAllLocationFields()
        {
            var location = new ExcelLocation
            {
                ContractRequestId = "request-1",
                CorrelationId = "correlation-2",
                ParentId = "parent-3",
                Sheet = "Allocations",
                Row = 17
            };

            var result = location.ToString();

            Assert.AreEqual(
                "ExcelLocation: ContractRequestId: [request-1] CorrelationId: [correlation-2] ParentId: parent-3] Sheet: [Allocations] Row: [17]",
                result);
        }
    }
}
