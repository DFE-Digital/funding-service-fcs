namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Entities;
    using Persistence;

    [TestClass]
    public class LookupCacheCriteriaTests
    {
        private LookupCacheCriteria objectOne;
        private LookupCacheCriteria objectTwo;

        [TestInitialize]
        public void Startup()
        {
            objectOne = new LookupCacheCriteria
            {
                LookupType = CrmLookupType.BusinessUnit,
                LookupValues = new List<string> {"Apples", "Bananas"}
            };

            objectTwo = new LookupCacheCriteria
            {
                LookupType = CrmLookupType.BusinessUnit,
                LookupValues = new List<string> {"Apples", "Grapes"}
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ObjectsCanBeCompared_ForDifferentLookupValues()
        {
            Assert.IsFalse(objectOne.Equals(objectTwo));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ObjectsCanBeCompared_ForDifferentLookupValues_IncludingAHashSet()
        {
            objectTwo.LookupValues = new HashSet<CrmCompositeKey>
            {
                CreateCompositeKeyWithValues("Strawberrys")
            };
            
            Assert.IsFalse(objectOne.Equals(objectTwo));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ObjectsCanBeCompared_ForDifferentLookupValues_WithTwoHashSet()
        {
            objectOne.LookupValues = new HashSet<CrmCompositeKey>
            {
                CreateCompositeKeyWithValues("Pineapples")
            };

            objectTwo.LookupValues = new HashSet<CrmCompositeKey>
            {
                CreateCompositeKeyWithValues("Strawberrys")
            };

            Assert.IsFalse(objectOne.Equals(objectTwo));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ObjectsCanBeCompared_ForDifferentLookupValues_WithTwoMatchingHashSets()
        {
            objectOne.LookupValues = new HashSet<CrmCompositeKey>
            {
                CreateCompositeKeyWithValues("Pineapples")
            };

            objectTwo.LookupValues = objectOne.LookupValues;

            Assert.IsTrue(objectOne.Equals(objectTwo));
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ObjectsCanBeCompared_ForDifferentLookupTypes()
        {
            objectTwo.LookupType = CrmLookupType.LocalEnterprisePartnership;
            objectTwo.LookupValues = objectOne.LookupValues;
            Assert.IsFalse(objectOne.Equals(objectTwo));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_UniqueHashKeysAreReturned_ForDifferentLookupValues()
        {
            Assert.IsFalse(objectOne.GetHashCode().Equals(objectTwo.GetHashCode()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_IdenticalObjectsAreComparedCorrectly()
        {
            objectTwo = objectOne;
            Assert.IsTrue(objectOne.Equals(objectTwo));
            Assert.IsTrue(objectOne.GetHashCode().Equals(objectTwo.GetHashCode()));
        }
        
        private CrmCompositeKey CreateCompositeKeyWithValues(string value)
        {
            CrmCompositeKey crmCompositeKey = new CrmCompositeKey();
            crmCompositeKey.KeyFields.Add(new ColumnValue
            {
                Column = "sfa_some_col",
                Value = value
            });

            crmCompositeKey.KeyFields.Add(new ColumnValue
            {
                Column = "sfa_some_col2",
                Value = value
            });

            return crmCompositeKey;
        }

    }
}
