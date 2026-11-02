using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using ADMonitoringDomain.Endpoint.BusinessLogic;
using ADMonitoringDomain.DataStore.Model;
using ADMonitoringDomain.DataStore;
using Moq;
using System.Data.Entity;

namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    [TestClass]
    public class ADMonitoringDeliveryEventStoreTests
    {
        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod, TestCategory("UnitTest")]
        public void StoreEvent_ShouldAttemptAnInsertOfTheEvent()
        {
            var data = new List<AllocationDeliveryEventReceived>();
            var dbSetMock = GetMockDbSet(data);
            var contextMock = new Mock<IAllocationDeliveryMonitoringDbContext>();
            contextMock.SetupGet(x => x.AllocationDeliveryEventsReceived).Returns(dbSetMock.Object);
            var eventItem = new AllocationDeliveryEventReceived()
            {
                EventName = "Test1"
            };
            var store = new ADMonitoringDeliveryEventStore(contextMock.Object);

            store.StoreEvent(eventItem, eventItem.GetType());

            Assert.IsTrue(contextMock.Object.AllocationDeliveryEventsReceived.Count() == 1
                && contextMock.Object.AllocationDeliveryEventsReceived.First().EventName == "Test1",
                "StoreEvent didn't add the event to the store");
            contextMock.Verify(x => x.SaveChanges(), Times.Once(), "StoreEvent didn't commit the event to te store");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StoreEvent_ShouldAttemptAnUpdateOfTheEvent_WhenAPrimaryKeyDuplicateSqlExceptionOccurs()
        {
            var data = new List<AllocationDeliveryEventReceived>();
            var dbSetMock = GetMockDbSet(data);
            var contextMock = new Mock<IAllocationDeliveryMonitoringDbContext>();
            contextMock.SetupGet(x => x.AllocationDeliveryEventsReceived).Returns(dbSetMock.Object);
            int i = 0;
            contextMock.Setup(x => x.SaveChanges()).Callback(
                () =>
                {
                    if (i == 0)
                    {
                        i++;
                        var innerException =
                        new SqlExceptionBuilder()
                            .WithErrorMessage("Cool Sql Exception")
                            .WithErrorNumber(2627) //<--Primary key duplicate error number
                            .BuildComplete();
                        var exception = new Exception("Top level cool exception",innerException);
                        throw exception;
                    }
                    
                }

                );
            var eventItem = new AllocationDeliveryEventReceived()
            {
                EventName = "Test1"
            };
            
            var store = new ADMonitoringDeliveryEventStore(contextMock.Object);

            store.StoreEvent(eventItem, eventItem.GetType());

            contextMock.Verify(x=>x.SetModified(eventItem, It.IsAny<Type>()), "StoreEvent didn't update the event");
            contextMock.Verify(x => x.SaveChanges(), Times.Exactly(1), "StoreEvent didn't commit the event to te store");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(System.Exception))]
        public void StoreEvent_ShouldReThrowError_WhenAnyOtherExceptionOccurs()
        {
            var data = new List<AllocationDeliveryEventReceived>();
            var dbSetMock = GetMockDbSet(data);
            var contextMock = new Mock<IAllocationDeliveryMonitoringDbContext>();
            contextMock.SetupGet(x => x.AllocationDeliveryEventsReceived).Returns(dbSetMock.Object);
            int i = 0;
            contextMock.Setup(x => x.SaveChanges()).Callback(
                () =>
                {
                    if (i == 0)
                    {
                        i++;
                        var innerException = new Exception("cool inner exception");

                        var exception = new Exception("Top level cool exception", innerException);
                        throw exception;
                    }

                }

                );
            var eventItem = new AllocationDeliveryEventReceived()
            {
                EventName = "Test1"
            };

            var store = new ADMonitoringDeliveryEventStore(contextMock.Object);

            try
            {
                store.StoreEvent(eventItem, eventItem.GetType());
            }
            catch (Exception ex)
            {
                Assert.IsTrue(ex.Message=="Top level cool exception","StoreEvent didn't throw the correct exception");
                throw;
            }
        }
        private static Mock<DbSet<T>> GetMockDbSet<T>(List<T> data) where T : class
        {
            var dbsetMock = new Mock<DbSet<T>>();
            dbsetMock.As<IQueryable<T>>().Setup(m => m.Provider).Returns(data.AsQueryable().Provider);
            dbsetMock.As<IQueryable<T>>().Setup(m => m.Expression).Returns(data.AsQueryable().Expression);
            dbsetMock.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(data.AsQueryable().ElementType);
            dbsetMock.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(data.AsQueryable().GetEnumerator());
            dbsetMock.Setup(x => x.Add(It.IsAny<T>())).Callback<T>(t => data.Add(t));
            //dbsetMock.As<DbSet<T>>().Setup(x => x.AddRange(It.IsAny<IEnumerable<T>>())).Callback<IEnumerable<T>>(data.AddRange);
            dbsetMock.Setup(x => x.Remove(It.IsAny<T>())).Callback<T>(t => data.Remove(t));
            //dbsetMock.As<DbSet<T>>().Setup(x => x.RemoveRange(It.IsAny<IEnumerable<T>>())).Callback<IEnumerable<T>>(
            //    ts =>
            //    {
            //        foreach (var t in ts)
            //        {
            //            data.Remove(t);
            //        }
            //    });
            return dbsetMock;
        }
    }
}
