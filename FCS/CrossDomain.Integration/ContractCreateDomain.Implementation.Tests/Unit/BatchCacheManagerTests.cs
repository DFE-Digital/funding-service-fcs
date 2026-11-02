namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using System;
    using System.Collections.Generic;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;

    [TestClass]
    public class BatchCacheManagerTests
    {
        private readonly BatchCacheManager CacheManager = new BatchCacheManager();
        private readonly string _batchId = Guid.NewGuid().ToString();
        
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldReturnTheSameInstanceWhenCalledWithTheSameParamsForGetEntities()
        {
            IList<string> values = new[] { "CC", "YY" };
            var entityCollection =  new EntityCollection();
            var entities = CacheManager.GetEntities(_batchId, CrmLookupType.FundingType, values, () => entityCollection);
            var entities2 = CacheManager.GetEntities(_batchId, CrmLookupType.FundingType, values, () => new EntityCollection());

            Assert.IsTrue(entities == entities2);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldReturnADifferenrInstanceWhenCalledWithDifferentParamsForGetEntities()
        {
            IList<string> values1 = new[] { "CC", "YY" };
            IList<string> values2 = new[] { "CA", "YY" };
            var entityCollection = new EntityCollection();
            var entities = CacheManager.GetEntities(_batchId, CrmLookupType.FundingType, values1, () => entityCollection);
            var entities2 = CacheManager.GetEntities(_batchId, CrmLookupType.FundingType, values2, () => new EntityCollection());

            Assert.IsTrue(entities != entities2);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldReturnADifferentInstanceForADiffentBatchIdForGetEntities()
        {
            IList<string> values = new[] { "CC", "YY" };
            var entityCollection = new EntityCollection();
            var entities = CacheManager.GetEntities(_batchId, CrmLookupType.FundingType, values, () => entityCollection);
            var entities2 = CacheManager.GetEntities("HH", CrmLookupType.FundingType, values, () => new EntityCollection());

            Assert.IsTrue(entities != entities2);
        }
    }
}
