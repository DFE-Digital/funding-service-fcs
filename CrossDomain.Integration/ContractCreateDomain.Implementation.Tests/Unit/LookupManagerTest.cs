//namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.Unit
//{
//    using System;
//    using System.Linq;
//    using Microsoft.VisualStudio.TestTools.UnitTesting;
//    using Microsoft.Xrm.Sdk;
//    using Moq;
//    using Persistence;
//    using CrossDomain.Integration.Entities.CorporateContract;
//    using Entities;

//    [TestClass()]
//    public class LookupManagerTest
//    {
//        [TestMethod, TestCategory("Fragile")]
//        public void ShouldLookupUnitOfProcurement()
//        {
//            var lm = GetLookupManager();

//            var guid = lm.GetMatchingEntity(CrmLookupType.UnitOfProcurement, "UWM");
//            Assert.IsTrue(guid == Guid.Empty, "Guid not returned");
//        }

//        private LookupManager GetLookupManager()
//        {
//            Mock<LookupManager> mockLookupManager = new Mock<LookupManager>();
//            return mockLookupManager.Object;
//        }
//    }
//}
