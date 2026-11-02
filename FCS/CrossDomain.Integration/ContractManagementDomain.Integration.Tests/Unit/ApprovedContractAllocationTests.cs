namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ApprovedContractAllocationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAllocation_ShouldDetermineAllocHasDeliveryOrgIfItHasDeliveryOrgFieldsSet()
        {
            // arrange
            var allocation = new ApprovedContractAllocation
            {
                DeliveryOrganisationId = "NOT NULL",
                DeliveryOrganisationUkprn = 1234
            };

            Assert.IsTrue(allocation.HasDeliveryOrg(), "HasDeliveryOrg should be true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAllocation_ShouldDetermineAllocHasNoDeliveryOrgIfItHasNoDeliveryOrgFieldsSet()
        {
            // arrange
            var allocation = new ApprovedContractAllocation
            {
                DeliveryOrganisationId = null,
                DeliveryOrganisationUkprn = null
            };

            Assert.IsFalse(allocation.HasDeliveryOrg(), "HasDeliveryOrg should be false");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAllocation_ShouldDetermineAllocHasNoDeliveryOrgIfItHasOnlyUkprnSet()
        {
            // arrange
            var allocation = new ApprovedContractAllocation
            {
                DeliveryOrganisationId = null,
                DeliveryOrganisationUkprn = 1234
            };

            Assert.IsFalse(allocation.HasDeliveryOrg(), "HasDeliveryOrg should be false");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractAllocation_ShouldDetermineAllocHasNoDeliveryOrgIfItHasOnlyDeliveryOrgIdSet()
        {
            // arrange
            var allocation = new ApprovedContractAllocation
            {
                DeliveryOrganisationId = "NOT NULL",
                DeliveryOrganisationUkprn = null
            };

            Assert.IsFalse(allocation.HasDeliveryOrg(), "HasDeliveryOrg should be false");
        }
    }
}