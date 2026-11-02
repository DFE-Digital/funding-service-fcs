namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    [TestClass]
    public class EnduringCacheManagerTests
    {
        private int _numTimesCalled = 0;
        [TestMethod, TestCategory("UnitTest")]
        public void EnduringCacheManager_ShouldOnlyExecuteFuctionWhenKeyNotFound()
        {
            EnduringCacheManager cacheManager = new EnduringCacheManager();

            OptionSetKey optionSetKey = new OptionSetKey("XX", "YY");
            cacheManager.GetOptionSetValue(optionSetKey, GetDataMock);
            cacheManager.GetOptionSetValue(optionSetKey, GetDataMock);
            Assert.IsTrue(_numTimesCalled == 1);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnduringCacheManager_ShouldOnlyExecuteGetEntitiesForLookupTypeWhenKeyNotFound()
        {
            EnduringCacheManager cacheManager = new EnduringCacheManager();

            cacheManager.GetEntitiesForLookupType(CrmLookupType.ContractType, GetDataMockReturningEntityCollection);
            cacheManager.GetEntitiesForLookupType(CrmLookupType.ContractType, GetDataMockReturningEntityCollection);
            Assert.IsTrue(_numTimesCalled == 1);
        }

        private int? GetDataMock(OptionSetKey optionSetKey)
        {
            _numTimesCalled++;
            return 1;
        }

        private EntityCollection GetDataMockReturningEntityCollection()
        {
            _numTimesCalled++;
            return new EntityCollection();
        }
    }
}
