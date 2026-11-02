namespace ADMonitoringDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Linq;
    using BusinessLogic;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    [TestClass]
    public class AllocationDeliveryMonitoringRepositoryTest
    {
        private IWindsorContainer _container;
        private int? _id;

        public AllocationDeliveryMonitoringRepositoryTest()
        {
            var loggerMock = new Mock<ILogger>();

            _container = new WindsorContainer();

            _container.Register(Component.For<ILogger>().Instance(loggerMock.Object));
            _container.Register(Component.For<IAllocationDeliveryMonitoringRepository>().ImplementedBy<AllocationDeliveryMonitoringRepository>());
            _container.Register(Component.For<IAllocationDeliveryDbContext>().ImplementedBy<AllocationDeliveryDbContext>());
            _container.Register(Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>());
            _container.Register(Component.For<IAllocationDeliveryMonitoringDbContext>().ImplementedBy<AllocationDeliveryMonitoringDbContext>());
            _container.Register(Component.For<IDate>().ImplementedBy<SystemDate>());

        }

        [TestInitialize]
        public virtual void Initialize()
        {
            ClearAllocationDeliveryEntries();
        }

        [TestCleanup]
        public virtual void Cleanup()
        {
            ClearAllocationDeliveryEntries();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CanPersist_AllocationDeliveryPerformanceEntity()
        {
            var allocDeliveryPerf = CreateAllocationDeliveryPerformance();
            var allocationDeliveryMonitoringRepository = _container.Resolve<IAllocationDeliveryMonitoringRepository>();
            _id = allocationDeliveryMonitoringRepository.StoreEvent(allocDeliveryPerf, AllocationDeliveryEntryCategory.NewContractAllocationApproved,
                ConnectionInfo.CreateFrom(new AllocationDeliveryMonitoringDbContext().Database.Connection));

            var addedItem = GetAllocationDeliveryEntry(_id.Value);
            Assert.IsNotNull(addedItem);
            Assert.AreEqual(AllocationDeliveryEntryCategory.NewContractAllocationApproved, addedItem.AllocationDeliveryCategory);
            Assert.AreEqual(allocDeliveryPerf.Contract.contractNumber, addedItem.ContractNumber);
            Assert.AreEqual(allocDeliveryPerf.contractAllocationNumber, addedItem.AllocationNumber);
            Assert.AreEqual(allocDeliveryPerf.Contract.contractVersionNumber, addedItem.VersionNumber);
            Assert.AreEqual(allocDeliveryPerf.Contract.contractSubVersionNumber, addedItem.SubVersionNumber);
            Assert.AreEqual(allocDeliveryPerf.Contract.contractNumber, addedItem.ContractNumber);

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CanRemove_AllAllocationDeliveryEventReceived()
        {
            // Arrange
            var testAllocNum = "ASC-001";

            var newEventAllocationDeliveryCommenced = new AllocationDeliveryEventReceived
            {
                AllocationNumber = testAllocNum,
                VersionNumber = 1,
                CategoryName = "NewContractAllocationApproved",
                EventName = "AllocationDeliveryCommenced",
                EventReceived = DateTime.Now,
                ObjectType = typeof (AllocationDeliveryCommencedEvent).AssemblyQualifiedName,
                Object = new AllocationDeliveryCommencedEvent
                {
                    Allocation = new allocationType
                    {
                        contractAllocationNumber = testAllocNum,
                        contractReference = new contractReferenceType
                        {
                            contractVersionNumber = 1
                        }
                    }
                }
            };

            var newEventPaymentCalculated = new AllocationDeliveryEventReceived
            {
                AllocationNumber = testAllocNum,
                VersionNumber = 1,
                CategoryName = "NewContractAllocationApproved",
                EventName = "PaymentCalculated",
                EventReceived = DateTime.Now,
                ObjectType = typeof(PaymentScheduleEvent).AssemblyQualifiedName,
                Object = new PaymentScheduleEvent
                {
                    PaymentScheduleAllocation = new SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                    {
                        AllocationNumber = testAllocNum,
                        VersionNumber = 1
                    }
                }
            };

            var newEventPaymentAggregated = new AllocationDeliveryEventReceived
            {
                AllocationNumber = testAllocNum,
                VersionNumber = 1,
                CategoryName = "NewContractAllocationApproved",
                EventName = "PaymentAggregated",
                EventReceived = DateTime.Now,
                ObjectType = typeof(PaymentAggregatedEvent).AssemblyQualifiedName,
                Object = new PaymentAggregatedEvent
                {
                    Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                    {
                        AllocationNumber = testAllocNum,
                        VersionNumber = 1
                    }
                }
            };
            
            var context = new AllocationDeliveryMonitoringDbContext();

            context.AllocationDeliveryEventsReceived.Add(newEventAllocationDeliveryCommenced);
            context.AllocationDeliveryEventsReceived.Add(newEventPaymentCalculated);
            context.AllocationDeliveryEventsReceived.Add(newEventPaymentAggregated);

            context.SaveChanges();

            var repo = _container.Resolve<IAllocationDeliveryMonitoringRepository>();

            // Act

            repo.ClearEvents("NewContractAllocationApproved", testAllocNum, 1,
                ConnectionInfo.CreateFrom(new AllocationDeliveryMonitoringDbContext().Database.Connection));
            
            // Assert

            Assert.IsFalse(context.AllocationDeliveryEventsReceived.Any(e => e.CategoryName == "NewContractAllocationApproved" && e.AllocationNumber == testAllocNum));   

        }


        private AllocationDeliveryEntry GetAllocationDeliveryEntry(int id)
        {
            var allocationDeliveryDBContext = _container.Resolve<IAllocationDeliveryDbContext>();
            return allocationDeliveryDBContext.AllocationDeliveryEntries.FirstOrDefault(x => x.ID == id);
        }

        private void ClearAllocationDeliveryEntries()
        {
            if (_id.HasValue)
            {
                var allocDeliveryPerf = CreateAllocationDeliveryPerformance();
                var allocationDeliveryDBContext = _container.Resolve<IAllocationDeliveryDbContext>();
                var itemToDelete = GetAllocationDeliveryEntry(_id.Value);
                if (itemToDelete != null)
                {
                    allocationDeliveryDBContext.AllocationDeliveryEntries.Remove(itemToDelete);
                    allocationDeliveryDBContext.SaveChanges();
                }
            }
        }

        private AllocationDeliveryPerformance CreateAllocationDeliveryPerformance()
        {
            var result = new AllocationDeliveryPerformance();
            result.contractAllocationNumber = "1";
            result.Contract = new contractReferenceTYPE() { contractNumber = "2", contractVersionNumber = 3 };
            result.schemaVersion = 4M;
            return result;
        }
    }
}
