namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PolicyCachePolicyDeliverableWriterTests
    {
        private readonly List<string[]> _testedPolicyCachePolicyDeliverableCodes = new List<string[]>();
        private PaymentManagementPolicyContext _context;

        [TestInitialize]
        public void Setup()
        {
            _context = new PaymentManagementPolicyContext();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicyDeliverableWriter_NewPolicyCachePolicyDeliverable()
        {
            // Arrange
            int deliverableCode = 121212;
            string fundingStreamPeriod = "ASTO1516";
            bool isPayable = true;
            string cappingGroupName = "Apprenticeships";
            int parentDeliverableCode = 1;
            DateTime createdDate = DateTime.Now;
            int? cappingAppPriorityOrder = 1;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = fundingStreamPeriod,
                ParentDeliverableCode = parentDeliverableCode,
                IsPayable = isPayable,
                DeliverableCappingGroup = cappingGroupName,
                CreatedDate = createdDate,
                CappingApportionmentPriorityOrder  = cappingAppPriorityOrder,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> newPolicyCachePolicyDeliverable = new List<FundingStreamPeriodDeliverablesSheetType>();
            newPolicyCachePolicyDeliverable.Add(fundingStreamPeriodDeliverablesSheetTypeEntry);

            string[] keys = { deliverableCode.ToString(), fundingStreamPeriod };
            _testedPolicyCachePolicyDeliverableCodes.Add(keys);

            // Act
            PolicyCachePolicyDeliverableWriter.WriteToPaaSDatabase(newPolicyCachePolicyDeliverable, WriterBehaviour.AddOrUpdate);

            // Assert
            _context = new PaymentManagementPolicyContext();
            PolicyDeliverable testedPolicyCachePolicyDeliverable = _context.PolicyDeliverables.Find(deliverableCode, fundingStreamPeriod);

            Assert.IsNotNull(testedPolicyCachePolicyDeliverable);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.DeliverableCode, deliverableCode);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.FundingStreamPeriod, fundingStreamPeriod);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.ParentDeliverableCode, parentDeliverableCode);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.IsPayable, isPayable);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.CappingApportionmentPriorityOrder, cappingAppPriorityOrder);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicyDeliverableWriter_AmendedPolicyCachePolicyDeliverable()
        {
            // Arrange
            int deliverableCode = 121212;
            string fundingStreamPeriod = "ASTO1516";
            bool isPayable = true;
            string cappingGroupName = "Apprenticeships";
            string newCappingGroupName = "Other ASB";
            int parentDeliverableCode = 1;
            DateTime createdDate = DateTime.Now;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = fundingStreamPeriod,
                ParentDeliverableCode = parentDeliverableCode,
                IsPayable = isPayable,
                DeliverableCappingGroup = cappingGroupName,
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> newPolicyCachePolicyDeliverable = new List<FundingStreamPeriodDeliverablesSheetType>();
            newPolicyCachePolicyDeliverable.Add(fundingStreamPeriodDeliverablesSheetTypeEntry);
            PolicyCachePolicyDeliverableWriter.WriteToPaaSDatabase(newPolicyCachePolicyDeliverable, WriterBehaviour.AddOrUpdate);
            _context.SaveChanges();

            string[] keys = { deliverableCode.ToString(), fundingStreamPeriod };
            _testedPolicyCachePolicyDeliverableCodes.Add(keys);

            FundingStreamPeriodDeliverablesSheetType amendedFundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = fundingStreamPeriod,
                ParentDeliverableCode = parentDeliverableCode,
                IsPayable = false,
                DeliverableCappingGroup = newCappingGroupName,
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> amendedPolicyCachePolicyDeliverable = new List<FundingStreamPeriodDeliverablesSheetType>();
            amendedPolicyCachePolicyDeliverable.Add(amendedFundingStreamPeriodDeliverablesSheetTypeEntry);

            // Act
            PolicyCachePolicyDeliverableWriter.WriteToPaaSDatabase(amendedPolicyCachePolicyDeliverable, WriterBehaviour.AddOrUpdate);

            // Assert
            _context = new PaymentManagementPolicyContext();
            PolicyDeliverable testedPolicyCachePolicyDeliverable = _context.PolicyDeliverables.Find(deliverableCode, fundingStreamPeriod);

            Assert.IsNotNull(testedPolicyCachePolicyDeliverable);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.DeliverableCode, deliverableCode);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.FundingStreamPeriod, fundingStreamPeriod);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.ParentDeliverableCode, parentDeliverableCode);
            Assert.AreEqual(testedPolicyCachePolicyDeliverable.IsPayable, false);

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicyDeliverableWriter_DeletedPolicyCachePolicyDeliverable()
        {
            // Arrange
            int deliverableCode = 121212;
            string fundingStreamPeriod = "ASTO1516";
            bool isPayable = true;
            string cappingGroupName = "Apprenticeships";
            int parentDeliverableCode = 1;
            DateTime createdDate = DateTime.Now;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = fundingStreamPeriod,
                ParentDeliverableCode = parentDeliverableCode,
                IsPayable = isPayable,
                DeliverableCappingGroup = cappingGroupName,
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> newPolicyCachePolicyDeliverable = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            PolicyCachePolicyDeliverableWriter.WriteToPaaSDatabase(newPolicyCachePolicyDeliverable, WriterBehaviour.AddOrUpdate);
            _context.SaveChanges();

            string[] keys = { deliverableCode.ToString(), fundingStreamPeriod };
            _testedPolicyCachePolicyDeliverableCodes.Add(keys);

            FundingStreamPeriodDeliverablesSheetType deletedFundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = fundingStreamPeriod,
                ParentDeliverableCode = parentDeliverableCode,
                IsPayable = false,
                DeliverableCappingGroup = cappingGroupName,
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Removed
            };

            List<FundingStreamPeriodDeliverablesSheetType> deletedPolicyCachePolicyDeliverable = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                deletedFundingStreamPeriodDeliverablesSheetTypeEntry
            };

            // Act
            PolicyCachePolicyDeliverableWriter.WriteToPaaSDatabase(deletedPolicyCachePolicyDeliverable, WriterBehaviour.Delete);

            // Assert
            _context = new PaymentManagementPolicyContext();
            PolicyDeliverable testedPolicyCachePolicyDeliverable = _context.PolicyDeliverables.Find(deliverableCode, fundingStreamPeriod);
            Assert.IsNull(testedPolicyCachePolicyDeliverable);
        }

        [TestCleanup]
        public void CleanUp()
        {

            foreach (string[] code in _testedPolicyCachePolicyDeliverableCodes)
            {
                PolicyDeliverable fsp = _context.PolicyDeliverables.Find(int.Parse(code[0]), code[1] );
                if (fsp != null)
                {
                    _context.PolicyDeliverables.Remove(fsp);
                }
            }
            _context.SaveChanges();

            _context.Dispose();
        }
    }
}
