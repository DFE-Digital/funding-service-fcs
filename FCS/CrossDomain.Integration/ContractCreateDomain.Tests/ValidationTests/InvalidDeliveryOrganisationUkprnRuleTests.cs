namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using contractor = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractor;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;

    [TestClass]
    public class InvalidDeliveryOrganisationUkprnRuleTests : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDeliveryOrganisationUkprnRule_WhenAnAllocationExistsWithANonExistentDeliveryOrganisation_ShouldReturnFailureItems()
        {
            // Arrange
            const string invalidCorrelationId = "12345678";
            const string validCorrelationId = "99999999";

            contractType master = Contract.GetAllContracts().First();
            contractType child = Contract.GetAllContracts().First().contracts[0];
            contractAllocation allocationWithExistingDelOrg = child.contractAllocations[0];
            contractAllocation allocationWithNonExistentDelOrg = child.contractAllocations[1];
            List<contractAllocation> allocations = new List<contractAllocation>()
            {
                allocationWithExistingDelOrg,
                allocationWithNonExistentDelOrg
            };
            child.contractAllocations = allocations;
            contractRequestType request = new contractRequestType()
            {
                contract = master,
            };

            allocationWithExistingDelOrg.correlationId = validCorrelationId;
            allocationWithExistingDelOrg.DeliveryOrganisationDetail = new contractor()
            {
                legalName = "Legal Name"
            };
            allocationWithNonExistentDelOrg.correlationId = invalidCorrelationId;
            allocationWithNonExistentDelOrg.DeliveryOrganisation = "Test Org";
            allocationWithNonExistentDelOrg.DeliveryOrganisationDetail = new contractor()
            {
                legalName = string.Empty
            };

            // Act
            InvalidDeliveryOrganisationUkprnRule rule = new InvalidDeliveryOrganisationUkprnRule();
            IEnumerable<string> failuresForItem = rule.GetFailuresForItem(request).ToList();

            // Assert
            Assert.AreEqual(1, failuresForItem.Count(), "Wrong number of errors were returned");
            Assert.AreEqual(invalidCorrelationId, failuresForItem.First(), "List of failures returned contained the wrong item");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDeliveryOrganisationUkprnRule_WhenAllAllocationsHaveExistingDeliveryOrganisations_ShouldNotReturnFailureItems()
        {
            // Arrange
            const string validCorrelationId1 = "12345678";
            const string validCorrelationId2 = "18742075";

            contractType master = Contract.GetAllContracts().First();
            contractType child = Contract.GetAllContracts().First().contracts[0];

            contractAllocation allocationWithExistingDelOrg = child.contractAllocations[0];
            contractAllocation allocationWithExistingDelOrg2 = child.contractAllocations[1];
            List<contractAllocation> allocations = new List<contractAllocation>()
            {
                allocationWithExistingDelOrg,
                allocationWithExistingDelOrg2
            };
            child.contractAllocations = allocations;

            allocationWithExistingDelOrg.correlationId = validCorrelationId1;
            allocationWithExistingDelOrg.DeliveryOrganisation = string.Empty;

            allocationWithExistingDelOrg.DeliveryOrganisationDetail = new contractor
            {
                legalName = string.Empty
            };

            allocationWithExistingDelOrg2.correlationId = validCorrelationId2;
            allocationWithExistingDelOrg2.DeliveryOrganisationDetail = new contractor()
            {
                legalName = "Legal Name"
            };

            contractRequestType request = new contractRequestType()
            {
                contract = master
            };

            // Act
            InvalidDeliveryOrganisationUkprnRule rule = new InvalidDeliveryOrganisationUkprnRule();
            IEnumerable<string> failuresForItem = rule.GetFailuresForItem(request);

            // Assert
            Assert.AreEqual(0, failuresForItem.Count(), "Wrong number of failure items were returned");
        }
    }
}