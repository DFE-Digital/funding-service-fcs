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
    public class PolicyCachePolicyDeliverableToSubnominalsWriterTests
    {
        private readonly List<object[]> _testedPolicyCachePolicyDeliverableToSubnominalsCodes = new List<object[]>();
        private PaymentManagementPolicyContext _context;

        [TestInitialize]
        public void Setup()
        {
            _context = new PaymentManagementPolicyContext();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicyDeliverableToSubnominalsWriter_NewPolicyCachePolicyDeliverableToSubnominals()
        {
            // Arrange
            int deliverableCode = 1;
            string fundingStreamPeriod = "24+ALLBC1516";
            int subnominalCode = 2303900;
            DateTime createdDate = DateTime.Now;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = fundingStreamPeriod,
                PaymentSubnominalCodeProfile = subnominalCode.ToString(),
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> newPolicyCachePolicyDeliverableToSubnominal = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            object[] keys = { deliverableCode, fundingStreamPeriod, subnominalCode, PaymentType.Profile };
            _testedPolicyCachePolicyDeliverableToSubnominalsCodes.Add(keys);

            // Act
            PolicyCachePolicyDeliverableToSubnominalsWriter.WriteToPaaSDatabase(newPolicyCachePolicyDeliverableToSubnominal, WriterBehaviour.AddOrUpdate);

            // Assert
            _context = new PaymentManagementPolicyContext();
            PolicyDeliverableToSubnominals testedPolicyCachePolicyDeliverableToSubnominals = _context.PolicyDeliverableToSubnominals.Find(deliverableCode, fundingStreamPeriod, subnominalCode, PaymentType.Profile);

            Assert.IsNotNull(testedPolicyCachePolicyDeliverableToSubnominals);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCachePolicyDeliverableToSubnominalsWriter_DeletePolicyCachePolicyDeliverableToSubnominals()
        {
            // Arrange
            int deliverableCode = 1;
            string fundingStreamPeriod = "24+ALLBC1516";
            int subnominalCode = 2303900;
            DateTime createdDate = DateTime.Now;

            PolicyDeliverableToSubnominals newPolicyDeliverableToSubnominals = new PolicyDeliverableToSubnominals()
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriod = fundingStreamPeriod,
                SubnominalCode = subnominalCode,
                PaymentType = PaymentType.Profile
            };

            object[] keys = { deliverableCode, fundingStreamPeriod, subnominalCode, PaymentType.Profile };
            _testedPolicyCachePolicyDeliverableToSubnominalsCodes.Add(keys);
            _context.PolicyDeliverableToSubnominals.Add(newPolicyDeliverableToSubnominals);
            _context.SaveChanges();

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType()
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = fundingStreamPeriod,
                PaymentSubnominalCodeProfile = subnominalCode.ToString(),
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Removed
            };

            List<FundingStreamPeriodDeliverablesSheetType> deletePolicyCachePolicyDeliverableToSubnominal = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            // Act
            PolicyCachePolicyDeliverableToSubnominalsWriter.WriteToPaaSDatabase(deletePolicyCachePolicyDeliverableToSubnominal, WriterBehaviour.Delete);

            // Assert
            _context = new PaymentManagementPolicyContext();
            PolicyDeliverableToSubnominals testedPolicyCachePolicyDeliverableToSubnominals = _context.PolicyDeliverableToSubnominals.Find(deliverableCode, fundingStreamPeriod, subnominalCode, PaymentType.Profile);

            Assert.IsNull(testedPolicyCachePolicyDeliverableToSubnominals);
        }

        [TestCleanup]
        public void CleanUp()
        {
            foreach (object[] code in _testedPolicyCachePolicyDeliverableToSubnominalsCodes)
            {
                PolicyDeliverableToSubnominals pds = _context.PolicyDeliverableToSubnominals.Find(code[0], code[1], code[2], code[3]);
                if (pds != null)
                {
                    _context.PolicyDeliverableToSubnominals.Remove(pds);
                }
            }
            _context.SaveChanges();

            _context.Dispose();
        }
    }
}
