namespace ContractCreateDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class CorpContractValueTypeFieldSetterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SetSpecifiedValuesToTrue_ContractWithoutChildren_DoesNotThrow()
        {
            var corpContract = new contract
            {
                contractor = new contractor(),
                contracts = new List<contractType>()
            };
            FillNullableValues(corpContract);
            FillNullableValues(corpContract.contractor);

            CorpContractValueTypeFieldSetter.SetSpecifiedValuesToTrue(corpContract);

            Assert.AreEqual(0, corpContract.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SetSpecifiedValuesToTrue_FullHierarchy_WalksAllLevelsWithoutChangingValues()
        {
            var period = new contractDeliverablePeriodsTypeContractDeliverablePeriod();
            var deliverable = new contractDeliverablesTypeContractDeliverable
            {
                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod> { period }
            };
            var allocation = new contractAllocationsContractAllocation
            {
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable> { deliverable }
            };
            var subContract = new contractType
            {
                contractVersionNumber = 3,
                contractor = new contractor(),
                contractAllocations = new List<contractAllocationsContractAllocation> { allocation }
            };
            var corpContract = new contract
            {
                contractVersionNumber = 2,
                contractor = new contractor(),
                contracts = new List<contractType> { subContract }
            };

            FillNullableValues(corpContract);
            FillNullableValues(corpContract.contractor);
            FillNullableValues(subContract);
            FillNullableValues(subContract.contractor);
            FillNullableValues(allocation);
            FillNullableValues(deliverable);
            FillNullableValues(period);

            CorpContractValueTypeFieldSetter.SetSpecifiedValuesToTrue(corpContract);

            Assert.AreEqual(2, corpContract.contractVersionNumber);
            Assert.AreEqual(3, subContract.contractVersionNumber);
        }

        private static void FillNullableValues(object obj)
        {
            foreach (var prop in obj.GetType().GetProperties())
            {
                var underlying = Nullable.GetUnderlyingType(prop.PropertyType);
                if (underlying != null && prop.CanWrite && prop.GetValue(obj, null) == null)
                {
                    prop.SetValue(obj, Activator.CreateInstance(underlying), null);
                }
            }
        }
    }
}
