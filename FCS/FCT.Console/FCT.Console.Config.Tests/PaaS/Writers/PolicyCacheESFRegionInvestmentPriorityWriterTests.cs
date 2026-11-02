namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PolicyCacheESFRegionInvestmentPriorityWriterTests
    {
        private const string TestFsp = "TEST_FSP";
        private const string TestRegionType = "LessDeveloped";
        private const decimal TestInvestmentPriority = 1.1m;
        private const string TestSubnominalCode = "TEST_SUBNOMINAL_CODE";

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var subnominalsToRemove = new List<ESFRegionInvestmentPriority>
                {
                    context.ESFRegionInvestmentPriorities.Find(TestRegionType, TestInvestmentPriority)
                };


                foreach (var subnominal in subnominalsToRemove.Where(s => s != null))
                {
                    context.ESFRegionInvestmentPriorities.Remove(subnominal);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheESFRegionInvestmentPriorityWriter_ShouldInsertANewRowWhenTheKeyDoesNotExist()
        {
            //arrange
            IEnumerable<ESFRegionInvestmentPrioritySheetType> testSubnominals = CreateRows(PolicyStatus.Approved);

            // act
            PolicyCacheESFRegionInvestmentPriorityWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                Assert.IsNotNull(context.ESFRegionInvestmentPriorities.Find(TestRegionType, TestInvestmentPriority));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheESFRegionInvestmentPriorityWriterr_ShouldUpdateARowWhenARowWithTheSameKeyExists()
        {
            //arrange
            string updatedValue = "UPDATED_SUBNOMINAL";
            List<ESFRegionInvestmentPrioritySheetType> testSubnominals = CreateRows(PolicyStatus.Approved).ToList();
            PolicyCacheESFRegionInvestmentPriorityWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);
            testSubnominals[0].SubnominalCode = updatedValue;

            // act
            PolicyCacheESFRegionInvestmentPriorityWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                ESFRegionInvestmentPriority updatedPolicySubnominal = context.ESFRegionInvestmentPriorities.Find(TestRegionType, TestInvestmentPriority);
                Assert.AreEqual(updatedValue, updatedPolicySubnominal.SubnominalCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheESFRegionInvestmentPriorityWriter_ShouldDeleteARowWhenARowWithTheSameKeyExists()
        {
            //arrange
            IEnumerable<ESFRegionInvestmentPrioritySheetType> testSubnominals = CreateRows(PolicyStatus.Approved);
            PolicyCacheESFRegionInvestmentPriorityWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);

            IEnumerable<ESFRegionInvestmentPrioritySheetType> deletedSubnominals = CreateRows(PolicyStatus.Removed);

            // act
            PolicyCacheESFRegionInvestmentPriorityWriter.WriteToPaaSDatabase(deletedSubnominals, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                ESFRegionInvestmentPriority deletedPolicySubnominal = context.ESFRegionInvestmentPriorities.Find(TestRegionType, TestInvestmentPriority);
                Assert.IsNull(deletedPolicySubnominal);
            }
        }

        private IEnumerable<ESFRegionInvestmentPrioritySheetType> CreateRows(PolicyStatus policyStatus)
        {
            return new List<ESFRegionInvestmentPrioritySheetType>
            {
                new ESFRegionInvestmentPrioritySheetType
                {
                    PolicyStatus = policyStatus,
                    RegionType = TestRegionType,
                    InvestmentPriorityString = TestInvestmentPriority.ToString(CultureInfo.InvariantCulture),
                    SubnominalCode = TestSubnominalCode
                }
            };
        }
    }
}
