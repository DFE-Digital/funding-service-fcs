namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.Test.ObjectComparison;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;

    [TestClass]
    // ReSharper disable once InconsistentNaming
    public class contractRequestTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestType_GetFundingPeriod_ShouldGetFundingPeriod()
        {
            // arrange
            contractRequestType contractRequest = TestResource.FromJson<contractRequestType>(
                "CrossDomain.Integration.Entities.Tests.Resources", "contractRequestType.json");

            // act
            string fundingPeriod = contractRequest.GetFundingPeriod();

            // assert
            Assert.AreEqual("AY1718", fundingPeriod);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestType_ConvertObjectToByteArray_ShouldSerializeAndDeserializeUsingBinaryFormatter()
        {
            // arrange
            contractRequestType contractRequest = TestResource.FromJson<contractRequestType>(
                "CrossDomain.Integration.Entities.Tests.Resources", "contractRequestType.json");

            // act
            byte[] serializedInstance = contractRequest.ConvertObjectToByteArray();
            contractRequestType deserializedInstance = serializedInstance.ConvertByteArrayToObject<contractRequestType>();

            // assert
            IReadOnlyCollection<ObjectComparisonMismatch> mismatches = ObjectComparison.CompareObjects(contractRequest, deserializedInstance);

            Assert.AreEqual(0, mismatches.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestType_IsNewRevisedNewOrUpdateDraft_ShouldReturnTrueForNew()
        {
            // arrange
            contractRequestType contractRequest = TestResource.FromJson<contractRequestType>(
                "CrossDomain.Integration.Entities.Tests.Resources", "contractRequestType.json");

            // act
            var result = contractRequest.IsNewRevisedNewOrUpdateDraft();

            // assert
            Assert.AreEqual(true, result);
        }
    }
}
