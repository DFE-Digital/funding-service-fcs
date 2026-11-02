namespace AllocationDeliveryDomain.Endpoint.Tests.ContractUnderTerminationEndpoint
{
    using System;
    using System.Collections.Generic;
    using AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;

    [TestClass]
    public class TerminationAllocationMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TerminationAllocationMapper_ToAllocationsUnderTermination_ShouldReturnAllocationsWithTerminationDates()
        {
            // arrange
            string contractNumber = "CONT-1234";
            List<TerminationAllocation> terminationAllocations = new List<TerminationAllocation>
            {
                new TerminationAllocation("Alloc", "FSPCode1", null),
                new TerminationAllocation("Alloc2", "FSPCode2", DateTime.Now),
                new TerminationAllocation("Alloc3", "FSPCode3", null),
                new TerminationAllocation("Alloc4", "FSPCode4",DateTime.Now),
            };

            // act
            IReadOnlyCollection<AllocationUnderTermination> allocationsUnderTermination = TerminationAllocationMapper.ToAllocationsUnderTermination(contractNumber, terminationAllocations);

            // assert
            Assert.AreEqual(2, allocationsUnderTermination.Count);
        }
    }
}
