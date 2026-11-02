using System;
using System.Globalization;
using ADMonitoringDomain.Endpoint.BusinessLogic.EventExtensions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.CrossDomain.Integration.Common;
using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
using SFA.FCT.CrossDomain.Integration.Events;

namespace ADMonitoringDomain.Endpoint.Tests.Unit.EventExtensions
{
    [TestClass]
    public class IPaymentScheduleEventExtensionsTests
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
        public void ToAllocationDeliveryEventReceived_ShouldMap_IPaymentScheduleEvent_To_AllocationDeliveryEventReceived()
        {
            var dateServiceMock = new Mock<IDate>();
            dateServiceMock.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));
            var category = Constants.CATEGORY_AMENDED_CONTRACT_ALLOCATION_APPROVED;
            var paymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationNumber   = "A202",
                    ContractVersionNumber = 4
                }
            };
            var result = paymentScheduleEvent.ToAllocationDeliveryEventReceived(dateServiceMock.Object, category);
            Assert.IsTrue(result.AllocationNumber == "A202" &&
                result.CategoryName == Constants.CATEGORY_AMENDED_CONTRACT_ALLOCATION_APPROVED &&
                result.EventName == "PaymentScheduleEvent" &&
                result.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture) &&
                result.Object == paymentScheduleEvent &&
                result.ObjectType == paymentScheduleEvent.GetType().AssemblyQualifiedName &&
                result.VersionNumber == 4, "ToAllocationDeliveryEventReceived didn't map the object correctly");

        }
    }
}
