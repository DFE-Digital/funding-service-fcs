using SFA.FCT.ContractCreateDomain.Implementation.Entities;
using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

namespace ContractCreateDomain.Implementation.Tests.unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    [TestClass()]
    public class CrmCompositeKeyTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldEqualTrueForCrmCompositeKeyWhenObjectsAreIdentical()
        {
            const string someValue = "some val";
            CrmCompositeKey crmCompositeKey1 = CreateCompositeKeyWithValues(someValue);
            CrmCompositeKey crmCompositeKey2 = CreateCompositeKeyWithValues(someValue);
            Assert.IsTrue(crmCompositeKey1.Equals(crmCompositeKey2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldHashToSameNumberForCrmCompositeKeyWhenObjectsAreIdentical()
        {
            const string someValue = "some val";
            CrmCompositeKey crmCompositeKey1 = CreateCompositeKeyWithValues(someValue);
            CrmCompositeKey crmCompositeKey2 = CreateCompositeKeyWithValues(someValue);
            Assert.IsTrue(crmCompositeKey1.GetHashCode() == crmCompositeKey2.GetHashCode());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldEqualFalseForCrmCompositeKeyWhenObjectsAreDifferent()
        {
            const string someValue = "some val";
            const string someOtherValue = "some other val";
            CrmCompositeKey crmCompositeKey1 = CreateCompositeKeyWithValues(someValue);
            CrmCompositeKey crmCompositeKey2 = CreateCompositeKeyWithValues(someOtherValue);
            Assert.IsFalse(crmCompositeKey1.Equals(crmCompositeKey2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldHashToDifferentNumberForCrmCompositeKeyWhenObjectsAreDifferent()
        {
            const string someValue = "some val";
            const string someOtherValue = "some other val";
            CrmCompositeKey crmCompositeKey1 = CreateCompositeKeyWithValues(someValue);
            CrmCompositeKey crmCompositeKey2 = CreateCompositeKeyWithValues(someOtherValue);
            Assert.IsTrue(crmCompositeKey1.GetHashCode() != crmCompositeKey2.GetHashCode());
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
