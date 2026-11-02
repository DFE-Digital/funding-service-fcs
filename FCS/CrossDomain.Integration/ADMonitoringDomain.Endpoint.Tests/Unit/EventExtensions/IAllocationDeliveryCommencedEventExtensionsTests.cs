using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Events;
using Moq;
using SFA.FCT.CrossDomain.Integration.Common;
using ADMonitoringDomain.Endpoint.BusinessLogic.EventExtensions;
using System.Globalization;
using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

namespace ADMonitoringDomain.Endpoint.Tests.Unit.EventExtensions
{
    [TestClass]
    public class IAllocationDeliveryCommencedEventExtensionsTests
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
        public void ToAllocationDeliveryEventReceived_ShouldMap_IAllocationDeliveryCommencedEvent_To_AllocationDeliveryEventReceived()
        {
            //Arrange
            var dateServiceMock = new Mock<IDate>();
            dateServiceMock.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));
            var category = Constants.CATEGORY_AMENDED_CONTRACT_ALLOCATION_APPROVED;
            var allocationDeliveryCommencedEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType()
                {
                    contractAllocationNumber = "A101",
                    contractReference = new contractReferenceType()
                    {
                        contractVersionNumber = 3
                    }
                }
            };

            //Act
            var result = allocationDeliveryCommencedEvent.ToAllocationDeliveryEventReceived(dateServiceMock.Object, category);

            //Assert
            Assert.IsTrue(result.AllocationNumber == "A101" &&
                result.CategoryName == Constants.CATEGORY_AMENDED_CONTRACT_ALLOCATION_APPROVED &&
                result.EventName == "AllocationDeliveryCommencedEvent" &&
                result.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture) &&
                result.Object == allocationDeliveryCommencedEvent &&
                result.ObjectType == allocationDeliveryCommencedEvent.GetType().AssemblyQualifiedName &&
                result.VersionNumber == 3, "ToAllocationDeliveryEventReceived didn't map the object correctly");

        }
    }
}
