using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Events;
using Moq;
using SFA.FCT.CrossDomain.Integration.Common;
using ADMonitoringDomain.Endpoint.BusinessLogic.EventExtensions;
using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
using System.Globalization;

namespace ADMonitoringDomain.Endpoint.Tests.Unit.EventExtensions
{
    [TestClass]
    public class IPaymentAggregatedEventExtensionsTests
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

        [TestMethod,TestCategory("UnitTest")]
        public void ToAllocationDeliveryEventReceived_ShouldMap_IPaymentAggregatedEvent_To_AllocationDeliveryEventReceived()
        {
            var dateServiceMock = new Mock<IDate>();
            dateServiceMock.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));
            var category = "Cat1";
            var aggregatedEvent = new PaymentAggregatedEvent()
            {
                Allocation = new Allocation()
                {
                    AllocationNumber="A101",
                    VersionNumber = 1
                }
            };
            var result = aggregatedEvent.ToAllocationDeliveryEventReceived(dateServiceMock.Object, category);
            Assert.IsTrue(result.AllocationNumber == "A101" &&
                result.CategoryName == "Cat1" &&
                result.EventName == "PaymentAggregatedEvent" &&
                result.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture) &&
                result.Object == aggregatedEvent &&
                result.ObjectType == aggregatedEvent.GetType().AssemblyQualifiedName &&
                result.VersionNumber == 1, "ToAllocationDeliveryEventReceived didn't map the object correctly");

        }
    }
}
