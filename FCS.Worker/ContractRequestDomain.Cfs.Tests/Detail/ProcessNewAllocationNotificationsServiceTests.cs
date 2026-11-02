namespace ContractRequestDomain.Cfs.Tests.Detail
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs.Detail.DTOs;
    using ContractRequestDomain.Cfs.Detail.Repositories;
    using ContractRequestDomain.Cfs.Detail.Services;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using ContractRequestDomain.Cfs.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ProcessNewAllocationNotificationsServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessNewAllocationNotificationsService_ShouldGetPopulatedNewAllocations()
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
            Mock<IAllocationNotificationRepository> mockAllocationRepository = new Mock<IAllocationNotificationRepository>();
            mockAllocationRepository
                .Setup(r => r.GetNewAllocationNotificationsThatAreNotInProgress(It.IsAny<ConnectionInfo>())).Returns(
                    Task.FromResult(GetAllocationNotifications(allocationId, version)));

            ProcessNewAllocationNotificationsService service = new ProcessNewAllocationNotificationsService(mockAllocationRepository.Object, new AllocationDetailServiceTestImpl());
            
            // act
            AllocationWithEntityId[] allocations = service.GetPopulatedNewAllocations(ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.AreEqual(1, allocations.Length);
        }

        private IReadOnlyCollection<AllocationNotification> GetAllocationNotifications(string allocationId, int version)
        {
            return new List<AllocationNotification>
            {
                new AllocationNotification
                {
                    AllocationId = allocationId,
                    VersionNumber = version
                }
            };
        }
    }

    
}
