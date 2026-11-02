namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    [TestClass]
    public class LookupWithColumnFilterKeyTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldReturnTrueWhenLookupWithColumnFilterKeyObjectAreEqual()
        {
            string[] statuses = new string[] {"some status", "some other status"};
            const string pkColumn = "sfa_statusid";

            LookupWithColumnFilterKey key1 = new LookupWithColumnFilterKey(CrmLookupType.SubStatus, pkColumn, statuses);
            LookupWithColumnFilterKey key2 = new LookupWithColumnFilterKey(CrmLookupType.SubStatus, pkColumn, statuses);

            Assert.IsTrue(key1.Equals(key2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldReturnFalseWhenLookupWithColumnFilterKeyObjectArNoteEqual()
        {
            string[] statuses = new string[] { "some status", "some other status" };
            string[] otherStatuses = new string[] { "some status", "some other status1" };
            const string pkColumn = "sfa_statusid";

            LookupWithColumnFilterKey key1 = new LookupWithColumnFilterKey(CrmLookupType.SubStatus, pkColumn, statuses);
            LookupWithColumnFilterKey key2 = new LookupWithColumnFilterKey(CrmLookupType.SubStatus, pkColumn, otherStatuses);
            LookupWithColumnFilterKey key3 = new LookupWithColumnFilterKey(CrmLookupType.PeriodType, pkColumn, statuses);

            Assert.IsFalse(key1.Equals(key2));
            Assert.IsFalse(key1.Equals(key3));
        }
    }
}
