namespace FCT.Operations.Maintenance.Endpoint.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Maintenance.Endpoint.Repositories;
    using System.Linq;
    using System.Collections.Generic;

    [TestClass]
    public class SchemaQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SchemaQueryRepository_GetSchemaNamesWithProcessedMessageTable_ShouldGetSomeSchemaNames()
        {
            // arrange
            var schemaNamesExpected = new List<string> { "AllocationDelivery", "PaymentSchedule", "ContractManagement"};
            var repository = new SchemaQueryRepository(new LocalConfig());

            // act
            var schemaNamesReturned = repository.GetSchemaNamesWithProcessedMessageTable().Result;

            // assert
            Assert.IsTrue(schemaNamesReturned.Count >= 3, "At least 3 schema names should have been returned");
            Assert.IsTrue(schemaNamesExpected.All(sn => schemaNamesReturned.Contains(sn)), "Not all expected schema names were returned");
        }
    }
}