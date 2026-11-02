namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PolicyCachePolicySubnominalWriterTests
    {
        private const string TestDescription = "TEST_DESCRIPTION";
        private const int TestSubnominalCode = 1234567890;
        private const PaymentType TestPaymentType = PaymentType.Capping;

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var subnominalsToRemove = new List<PolicySubnominal>
                {
                    context.PolicySubnominals.Find(TestSubnominalCode, TestPaymentType)
                };


                foreach (var subnominal in subnominalsToRemove.Where(s => s != null))
                {
                    context.PolicySubnominals.Remove(subnominal);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicySubnominalWriter_ShouldInsertANewRowWhenTheKeyDoesNotExist()
        {
            //arrange
            IEnumerable<SubnominalsSheetType> testSubnominals = CreateRows(TestDescription, PolicyStatus.Approved);

            // act
            PolicyCachePolicySubnominalWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                Assert.IsNotNull(context.PolicySubnominals.Find(TestSubnominalCode, TestPaymentType));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicySubnominalWriter_ShouldUpdateARowWhenARowWithTheSameKeyExists()
        {
            //arrange
            IEnumerable<SubnominalsSheetType> testSubnominals = CreateRows("Some Desc", PolicyStatus.Approved);
            PolicyCachePolicySubnominalWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);
            IEnumerable<SubnominalsSheetType> updateSubnominals = CreateRows(TestDescription, PolicyStatus.Approved);

            // act
            PolicyCachePolicySubnominalWriter.WriteToPaaSDatabase(updateSubnominals, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicySubnominal updatedPolicySubnominal = context.PolicySubnominals.Find(TestSubnominalCode, TestPaymentType);
                Assert.AreEqual(TestDescription, updatedPolicySubnominal.PaymentSubnominalDesc);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicySubnominalWriter_ShouldDeleteARowWhenARowWithTheSameKeyExists()
        {
            //arrange
            IEnumerable<SubnominalsSheetType> testSubnominals = CreateRows(TestDescription, PolicyStatus.Approved);
            PolicyCachePolicySubnominalWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);

            IEnumerable<SubnominalsSheetType> deletedSubnominals = CreateRows(TestDescription, PolicyStatus.Removed);

            // act
            PolicyCachePolicySubnominalWriter.WriteToPaaSDatabase(deletedSubnominals, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicySubnominal deletedPolicySubnominal = context.PolicySubnominals.Find(TestSubnominalCode, TestPaymentType);
                Assert.IsNull(deletedPolicySubnominal);
            }
        }

        private IEnumerable<SubnominalsSheetType> CreateRows(string shortDescription, PolicyStatus policyStatus)
        {
            return new List<SubnominalsSheetType>
            {
                new SubnominalsSheetType
                {
                    PolicyStatus = policyStatus,
                    PaymentType = TestPaymentType.ToString(), 
                    ShortDescription = shortDescription,
                    SubnominalCode = TestSubnominalCode.ToString()
                }
            };
        }
    }
}
