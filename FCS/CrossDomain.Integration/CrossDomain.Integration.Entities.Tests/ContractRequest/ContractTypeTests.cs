namespace CrossDomain.Integration.Entities.Tests.ContractRequest
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractTypeTests
    {
        
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocation_HasModificationDetails_ShouldReturnTrueWhenMandatoryModificationValuesArePresent()
        {
            // arrange
            contractAllocation allocation = new contractAllocation
            {
                StopNewStartsDate = DateTime.UtcNow.Date,
                NewStartsSuspendedReason = "Inadequate Financial Health"
            };

            // act
            bool hasModificationDetails = allocation.HasModificationDetails;

            // assert
            Assert.IsTrue(hasModificationDetails);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocation_HasModificationDetails_ShouldReturnFalseWhenMandatoryModificationValuesAreNotPresent()
        {
            // arrange
            contractAllocation allocation = new contractAllocation
            {
                StopNewStartsDate = null,
                NewStartsSuspendedReason = null
            };

            // act
            bool hasModificationDetails = allocation.HasModificationDetails;

            // assert
            Assert.IsFalse(hasModificationDetails);
        }
    }
}
