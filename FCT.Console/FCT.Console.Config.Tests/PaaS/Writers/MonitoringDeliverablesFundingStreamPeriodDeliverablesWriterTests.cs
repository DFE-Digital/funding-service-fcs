namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class MonitoringDeliverablesFundingStreamPeriodDeliverablesWriterTests
    {
        private FundingStreamPeriodDeliverable _testedFundingStreamPeriodDeliverable;
        private readonly List<string[]> _testedFundingStreamPeriodDeliverableCodes = new List<string[]>();
        private MonitoringDeliverablesDbContext _context;

        [TestInitialize]
        public void Setup()
        {
            _context = new MonitoringDeliverablesDbContext();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesFundingStreamPeriodDeliverableWriter_NewMonitoringDeliverablesFundingStreamPeriodDeliverable()
        {
            // Arrange
            string codeKey = "MCHTEST1";
            int deliverableCode = 1;
            int parentDeliverableCode = 1;
            string name = "Name";
            bool updatedAllowProfile = true;
            bool updatedAllowActuals = true;
            bool updatedAllowPayment = true;
            int displayOrder = 1;
            DateTime createdDate = DateTime.Now;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                FundingStreamPeriodCode = codeKey,
                DeliverableCode = deliverableCode,
                ParentDeliverableCode = parentDeliverableCode,
                DeliverableName = name,
                AllowProfile = updatedAllowProfile,
                AllowActuals = updatedAllowActuals,
                AllowPayment = updatedAllowPayment,
                DisplayOrder = displayOrder,
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> updatedMonitoringDeliverablesFundingStreamPeriodDeliverables = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            string[] keys = { codeKey, deliverableCode.ToString() };
            _testedFundingStreamPeriodDeliverableCodes.Add(keys);

            // Act
            MonitoringDeliverablesFundingStreamPeriodDeliverableWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesFundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);

            // Assert
            _context = new MonitoringDeliverablesDbContext();
            FundingStreamPeriodDeliverable testedFundingStreamPeriodDeliverable = _context.FundingStreamPeriodDeliverables.Find(codeKey,deliverableCode);

            Assert.IsNotNull(testedFundingStreamPeriodDeliverable);
            Assert.AreEqual(testedFundingStreamPeriodDeliverable.DeliverableName, name);
            Assert.AreEqual(testedFundingStreamPeriodDeliverable.DeliverableCode, deliverableCode);
            Assert.AreEqual(testedFundingStreamPeriodDeliverable.ParentDeliverableCode, parentDeliverableCode);
            Assert.AreEqual(testedFundingStreamPeriodDeliverable.AllowProfile, updatedAllowProfile);
            Assert.AreEqual(testedFundingStreamPeriodDeliverable.AllowActuals, updatedAllowActuals);
            Assert.AreEqual(testedFundingStreamPeriodDeliverable.AllowPayment, updatedAllowPayment);
            Assert.AreEqual(testedFundingStreamPeriodDeliverable.DisplayOrder,displayOrder);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesFundingStreamPeriodDeliverableWriter_ShouldNotWriteDeliverableWhenAllowActualsIsFalse()
        {
            // Arrange
            string codeKey = "MCHTEST1";
            int deliverableCode = 1;
            int parentDeliverableCode = 1;
            string name = "Name";
            bool updatedAllowProfile = true;
            bool updatedAllowActuals = false;
            bool updatedAllowPayment = true;
            DateTime createdDate = DateTime.Now;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                FundingStreamPeriodCode = codeKey,
                DeliverableCode = deliverableCode,
                ParentDeliverableCode = parentDeliverableCode,
                DeliverableName = name,
                AllowProfile = updatedAllowProfile,
                AllowActuals = updatedAllowActuals,
                AllowPayment = updatedAllowPayment,
                CreatedDate = createdDate,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> updatedMonitoringDeliverablesFundingStreamPeriodDeliverables = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            string[] keys = { codeKey, deliverableCode.ToString() };
            _testedFundingStreamPeriodDeliverableCodes.Add(keys);

            // Act
            MonitoringDeliverablesFundingStreamPeriodDeliverableWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesFundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);

            // Assert
            _context = new MonitoringDeliverablesDbContext();
            FundingStreamPeriodDeliverable testedFundingStreamPeriodDeliverable = _context.FundingStreamPeriodDeliverables.Find(codeKey, deliverableCode);

            Assert.IsNull(testedFundingStreamPeriodDeliverable);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesFundingStreamPeriodDeliverableWriter_UpdateMonitoringDeliverablesFundingStreamPeriodDeliverable()
        {
            // Arrange
            string codeKey = "MCHTEST1";
            int deliverableCode = 0;
            int updatedParentDeliverableCode = 2;
            string updatedName = "UpdatedName";
            bool updatedAllowProfile = true;
            bool updatedAllowActuals = true;
            bool updatedAllowPayment = true;
            int displayOrder = 2;

            FundingStreamPeriodDeliverable monitoringDeliverablesFundingStreamPeriodDeliverable = new FundingStreamPeriodDeliverable
            {
                FundingStreamPeriodCode = codeKey,
                DeliverableCode = deliverableCode,
                ParentDeliverableCode = 1,
                DeliverableName = "MCHTEST1",
                AllowProfile = false,
                AllowActuals = false,
                AllowPayment = false,
                DisplayOrder = displayOrder

            };

            string[] keys = { codeKey, deliverableCode.ToString() };
            _testedFundingStreamPeriodDeliverableCodes.Add(keys);
            _context.FundingStreamPeriodDeliverables.Add(monitoringDeliverablesFundingStreamPeriodDeliverable);
            _context.SaveChanges();

            List<FundingStreamPeriodDeliverablesSheetType> updatedMonitoringDeliverablesFundingStreamPeriodDeliverables = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                 new FundingStreamPeriodDeliverablesSheetType {
                        FundingStreamPeriodCode = codeKey,
                        DeliverableCode = deliverableCode,
                        ParentDeliverableCode = updatedParentDeliverableCode,
                        DeliverableName = updatedName,
                        AllowProfile = updatedAllowProfile,
                        AllowActuals = updatedAllowActuals,
                        AllowPayment = updatedAllowPayment,
                        DisplayOrder = displayOrder,
                        PolicyStatus = PolicyStatus.Approved
                 }
            };

            // Act
            MonitoringDeliverablesFundingStreamPeriodDeliverableWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesFundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);

            // Assert
            _context = new MonitoringDeliverablesDbContext();
            _testedFundingStreamPeriodDeliverable = _context.FundingStreamPeriodDeliverables.Find(codeKey, deliverableCode);

            Assert.IsNotNull(_testedFundingStreamPeriodDeliverable);
            Assert.AreEqual(_testedFundingStreamPeriodDeliverable.DeliverableName, updatedName);
            Assert.AreEqual(_testedFundingStreamPeriodDeliverable.ParentDeliverableCode, updatedParentDeliverableCode);
            Assert.AreEqual(_testedFundingStreamPeriodDeliverable.AllowProfile, updatedAllowProfile);
            Assert.AreEqual(_testedFundingStreamPeriodDeliverable.AllowActuals, updatedAllowActuals);
            Assert.AreEqual(_testedFundingStreamPeriodDeliverable.AllowPayment, updatedAllowPayment);
            Assert.AreEqual(_testedFundingStreamPeriodDeliverable.DisplayOrder, displayOrder);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesFundingStreamPeriodDeliverablesWriter_DeleteExistingMonitoringDeliverablesFundingStreamPeriodDeliverable()
        {
            // Arrange
            string codeKey = "MCHTEST1";
            string name = "Name";
            int deliverableCode = 0;
            int parentDeliverableCode = 1;
            bool updatedAllowProfile = true;
            bool updatedAllowActuals = true;
            bool updatedAllowPayment = true;
            int displayOrder = 1;

            FundingStreamPeriodDeliverable monitoringDeliverablesFundingStreamPeriodDeliverable = new FundingStreamPeriodDeliverable
            {
                FundingStreamPeriodCode = codeKey,
                DeliverableCode = deliverableCode,
                ParentDeliverableCode = parentDeliverableCode,
                DeliverableName = "MCHTEST1",
                AllowProfile = false,
                AllowActuals = false,
                AllowPayment = false,
                DisplayOrder = displayOrder
            };

            string[] keys = { codeKey, deliverableCode.ToString() };
            _testedFundingStreamPeriodDeliverableCodes.Add(keys);
            _context.FundingStreamPeriodDeliverables.Add(monitoringDeliverablesFundingStreamPeriodDeliverable);
            _context.SaveChanges();

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                FundingStreamPeriodCode = codeKey,
                DeliverableName = name,
                AllowProfile = updatedAllowProfile,
                AllowActuals = updatedAllowActuals,
                AllowPayment = updatedAllowPayment,
                DisplayOrder = displayOrder,
                PolicyStatus = PolicyStatus.Removed
            };

            List<FundingStreamPeriodDeliverablesSheetType> updatedMonitoringDeliverablesFundingStreamPeriodDeliverables = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            // Act
            MonitoringDeliverablesFundingStreamPeriodDeliverableWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesFundingStreamPeriodDeliverables, WriterBehaviour.Delete);

            // Assert
            _context = new MonitoringDeliverablesDbContext();
            FundingStreamPeriodDeliverable testedfundingStreamPeriodDeliverable = _context.FundingStreamPeriodDeliverables.Find(codeKey, deliverableCode);
            Assert.IsNull(testedfundingStreamPeriodDeliverable);
        }

        [TestCleanup]
        public void CleanUp()
        {
            foreach (string[] code in _testedFundingStreamPeriodDeliverableCodes)
            {
                FundingStreamPeriodDeliverable fsp = _context.FundingStreamPeriodDeliverables.Find(code[0], int.Parse(code[1]));
                if (fsp != null)
                {
                    _context.FundingStreamPeriodDeliverables.Remove(fsp);
                }
            }

            _context.SaveChanges();
            _context.Dispose();
        }
    }
}
