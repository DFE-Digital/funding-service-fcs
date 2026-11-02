namespace ContractRequestDomain.Cfs.Tests.Detail
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using ContractRequestDomain.Cfs.Detail.Services;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using ContractRequestDomain.Cfs.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class AllocationDetailServiceTestImplTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDetailServiceTestImpl_ShouldGetAllocationFromStub()
        {
            // arrange
            const string allocationId = "Test";
            const int version = 1;
            const int ukprn = 1234;
            const int month = 10;
            string stubTableName = $"CfsStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";

            AzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.CreateTableIfNotExists(stubTableName);

            azureTableStore.DeleteRows(stubTableName, allocationId);

            Allocation allocation = new Allocation
            {
                Id = allocationId,
                Ukprn = ukprn,
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        Month = month
                    }
                }
            };

            azureTableStore.InsertOrReplace(stubTableName,
                CfsStubEntity.Create(1, allocationId, version, 123, allocation));

            // act
            AllocationDetailServiceTestImpl testImpl= new AllocationDetailServiceTestImpl();
            Allocation allocationReturned = testImpl.GetAllocationDetail(allocationId, version).Result;

            // assert
            Assert.AreEqual(allocationId, allocationReturned.Id, "The id is incorrect");
            Assert.AreEqual(ukprn, allocationReturned.Ukprn, "The ukprn is incorrect");
            Assert.AreEqual(allocation.AllocationPeriods.Count, allocationReturned.AllocationPeriods.Count, "The AllocationPeriods count is incorrect");
            Assert.AreEqual(month, allocationReturned.AllocationPeriods.First().Month, "The AllocationPeriod month is incorrect");
        }
    }
}
