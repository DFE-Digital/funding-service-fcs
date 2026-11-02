namespace Datafix.Tests.Tests
{
    using System;
    using ContractManagement.DataStore.Model;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class ContractInfoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractInfo_ShouldPopulateAmendmentTypeCorrectlyWhenAmendmentTypeVariation()
        {
            // arrange
            // act
            ContractInfo contractInfo = new ContractInfo("some number", 1, 0, DateTime.Now, (int)sfa_amendmenttype.Variation);

            // assert
            Assert.AreEqual(AmendmentType.Variation, contractInfo.AmendmentType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractInfo_ShouldPopulateAmendmentTypeCorrectlyWhenAmendmentTypeNull()
        {
            // arrange
            // act
            ContractInfo contractInfo = new ContractInfo("some number", 1, 0, DateTime.Now, null);

            // assert
            Assert.AreEqual(null, contractInfo.AmendmentType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractInfo_ShouldPopulateAmendmentTypeCorrectlyWhenAmendmentTypeNotification()
        {
            // arrange
            // act
            ContractInfo contractInfo = new ContractInfo("some number", 1, 0, DateTime.Now, (int)sfa_amendmenttype.Notification);

            // assert
            Assert.AreEqual(AmendmentType.Notification, contractInfo.AmendmentType);
        }
    }
}
