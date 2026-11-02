namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.unit
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Persistence;

    [TestClass]
    public class FieldMapperTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldGetMappingForContractField()
        {
            var mappings = CrmFieldMapper.GetMappings("contract", "startDate");
            Assert.IsTrue(mappings != null);
            Assert.IsTrue(mappings.ToArray().Length > 0 );
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldGetTwoMappingsForDeliveryOrganisation()
        {
            var mappings = CrmFieldMapper.GetMappings("contractAllocationsContractAllocation", "DeliveryOrganisation");
            Assert.AreEqual(2, mappings.Count());
        }
    }
}
