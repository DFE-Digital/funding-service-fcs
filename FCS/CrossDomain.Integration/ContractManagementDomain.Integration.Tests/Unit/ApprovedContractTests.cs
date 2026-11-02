namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ApprovedContractTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContract_ShouldGetRelatedAllocationByNumber()
        {
            // arrange
            var contract = new ApprovedContract(
                contractNumber: "TEST123",
                contractVersionNumber: 1,
                contractSubVersionNumber: 0,
                fundingType: "TEST",
                fundingPeriod: "AY1718",
                ukprn: 102030405,
                organisationId: "ORG0000001",
                masterContractNumber:string.Empty, 
                startDate: DateTime.Now.AddDays(7).Date, 
                endDate: DateTime.Now.AddYears(1).Date)
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation {ContractAllocationNumber = "ABC-1"},
                    new ApprovedContractAllocation {ContractAllocationNumber = "ABC-2", DeliveryOrganisationId = "ORG" },
                    new ApprovedContractAllocation {ContractAllocationNumber = "ABC-3"},
                }
            };

            // act
            var allocation = contract.GetAllocationByNumber("ABC-2");

            // assert
            Assert.IsNotNull(allocation, "Allocation was not retrieved from the contract");
            Assert.AreEqual("ORG", allocation.DeliveryOrganisationId, "Incorrect allocation data was returned");
        }
    }
}