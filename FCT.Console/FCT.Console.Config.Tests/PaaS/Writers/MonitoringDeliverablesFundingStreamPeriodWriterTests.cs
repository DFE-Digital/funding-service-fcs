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
    public class MonitoringDeliverablesFundingStreamPeriodWriterTests
    {
        private FundingStreamPeriod _testedFundingStreamPeriod;
        private readonly IList<string> _testedFundingStreamCodes = new List<string>();
        private MonitoringDeliverablesDbContext _context;

        [TestInitialize]
        public void Setup()
        {
            _context = new MonitoringDeliverablesDbContext();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesFundingStreamPeriodWriter_UpdateMonitoringDeliverablesFundingStreamPeriod()
        {
            // Arrange
            string codeKey = "DGTEST1";
            string updatedName = "UpdatedName";
            bool updatedProcessFutureActuals = true;
            bool updatedPersistCurrentActuals = true;
            bool updatedZeroiseMissingActuals = true;
            string updatedPaymentMethod = "Pay on Profile";
            const bool multiCollectionReturns = true;

            FundingStreamPeriod monitoringDeliverablesFundingStreamPeriod = new FundingStreamPeriod
            {
                Code = codeKey,
                Name = "DGTEST1",
                ProcessFutureActuals = false,
                PersistCurrentActualsState = false,
                ZeroiseMissingActuals = false,
                PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnActuals,
                MultiCollectionReturns = false
            };

            _testedFundingStreamCodes.Add(codeKey);
            _context.FundingStreamPeriods.Add(monitoringDeliverablesFundingStreamPeriod);
            _context.SaveChanges();

            List<FundingStreamPeriodSheetType> updatedMonitoringDeliverablesFundingStreamPeriods = new List<FundingStreamPeriodSheetType>
            {
                 new FundingStreamPeriodSheetType
                 {
                        FundingStreamPeriodCode = codeKey,
                        Name = updatedName,
                        ProcessFutureActuals = updatedProcessFutureActuals,
                        PersistCurrentActualsState = updatedPersistCurrentActuals,
                        PolicyStatus = PolicyStatus.Approved,
                        ZeroiseMissingActuals = updatedZeroiseMissingActuals,
                        PaymentMethod = updatedPaymentMethod,
                        MultiCollectionReturns = multiCollectionReturns
                 }
            };

            // Act
            MonitoringDeliverablesFundingStreamPeriodWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesFundingStreamPeriods, WriterBehaviour.AddOrUpdate);
            _context = new MonitoringDeliverablesDbContext();

            // Assert
            _testedFundingStreamPeriod = _context.FundingStreamPeriods.Find(codeKey);

            Assert.IsNotNull(_testedFundingStreamPeriod);
            Assert.AreEqual(_testedFundingStreamPeriod.Name, updatedName);
            Assert.AreEqual(_testedFundingStreamPeriod.ProcessFutureActuals, updatedProcessFutureActuals);
            Assert.AreEqual(_testedFundingStreamPeriod.PersistCurrentActualsState, updatedPersistCurrentActuals);
            Assert.AreEqual(_testedFundingStreamPeriod.ZeroiseMissingActuals, updatedZeroiseMissingActuals, "Zeroise Missing Actuals not equal");
            Assert.AreEqual(_testedFundingStreamPeriod.PaymentMethod, FundingStreamPeriodPaymentMethod.PayOnProfile);
            Assert.AreEqual(_testedFundingStreamPeriod.MultiCollectionReturns, multiCollectionReturns);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesFundingStreamPeriodWriter_NewMonitoringDeliverablesFundingStreamPeriod()
        {
            // Arrange
            string codeKey = "DGTEST1";
            string name = "Name";
            bool processFutureActuals = true;
            bool persistCurrentActuals = true;
            bool persistZeroiseMissingActuals = true;
            string paymentMethod = "Pay on Instruction";
            const bool multiCollectionReturns = true;

            FundingStreamPeriodSheetType fundingStreamPeriodSheetTypeEntry = new FundingStreamPeriodSheetType
            {
                FundingStreamPeriodCode = codeKey,
                Name = name,
                ProcessFutureActuals = processFutureActuals,
                PersistCurrentActualsState = persistCurrentActuals,
                ZeroiseMissingActuals = persistZeroiseMissingActuals,
                PolicyStatus = PolicyStatus.Approved,
                PaymentMethod = paymentMethod,
                MultiCollectionReturns = multiCollectionReturns
            };

            List<FundingStreamPeriodSheetType> updatedMonitoringDeliverablesFundingStreamPeriods = new List<FundingStreamPeriodSheetType>
            {
                fundingStreamPeriodSheetTypeEntry
            };

            _testedFundingStreamCodes.Add(codeKey);

            // Act
            MonitoringDeliverablesFundingStreamPeriodWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesFundingStreamPeriods, WriterBehaviour.AddOrUpdate);
            _context = new MonitoringDeliverablesDbContext();

            // Assert
            FundingStreamPeriod fundingStreamPeriod = _context.FundingStreamPeriods.Find(codeKey);

            Assert.IsNotNull(fundingStreamPeriod);
            Assert.AreEqual(fundingStreamPeriod.Name, name);
            Assert.AreEqual(fundingStreamPeriod.PersistCurrentActualsState, persistCurrentActuals);
            Assert.AreEqual(fundingStreamPeriod.ProcessFutureActuals, processFutureActuals);
            Assert.AreEqual(fundingStreamPeriod.ZeroiseMissingActuals, persistZeroiseMissingActuals,"Zeroise Missing Actuals not equal");
            Assert.AreEqual(fundingStreamPeriod.PaymentMethod, FundingStreamPeriodPaymentMethod.PayOnInstruction);
            Assert.AreEqual(fundingStreamPeriod.MultiCollectionReturns, multiCollectionReturns);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesFundingStreamPeriodWriter_DeleteExistingMonitoringDeliverablesFundingStreamPeriod()
        {
            // Arrange
            string codeKey = "DGTEST1";
            string name = "Name";
            bool processFutureActuals = true;
            bool persistCurrentActuals = true;
            bool persistZeroiseMissingActuals = true;
            const bool multiCollectionReturns = true;

            FundingStreamPeriod monitoringDeliverablesFundingStreamPeriod = new FundingStreamPeriod
            {
                Code = codeKey,
                Name = name,
                ProcessFutureActuals = processFutureActuals,
                PersistCurrentActualsState = persistCurrentActuals,
                ZeroiseMissingActuals = persistZeroiseMissingActuals,
                PaymentMethod = FundingStreamPeriodPaymentMethod.PaidExternally,
                MultiCollectionReturns = multiCollectionReturns
            };

            _testedFundingStreamCodes.Add(codeKey);
            _context.FundingStreamPeriods.Add(monitoringDeliverablesFundingStreamPeriod);
            _context.SaveChanges();

            FundingStreamPeriodSheetType fundingStreamPeriodSheetTypeEntry = new FundingStreamPeriodSheetType
            {
                FundingStreamPeriodCode = codeKey,
                Name = name,
                ProcessFutureActuals = processFutureActuals,
                PersistCurrentActualsState = persistCurrentActuals,
                ZeroiseMissingActuals = persistZeroiseMissingActuals,
                PolicyStatus = PolicyStatus.Removed,
                PaymentMethod = "Paid Externally",
                MultiCollectionReturns = multiCollectionReturns
            };

            List<FundingStreamPeriodSheetType> updatedMonitoringDeliverablesFundingStreamPeriods = new List<FundingStreamPeriodSheetType>();
            updatedMonitoringDeliverablesFundingStreamPeriods.Add(fundingStreamPeriodSheetTypeEntry);

            _testedFundingStreamCodes.Add(codeKey);

            // Act
            MonitoringDeliverablesFundingStreamPeriodWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesFundingStreamPeriods, WriterBehaviour.Delete);
            _context = new MonitoringDeliverablesDbContext();

            // Assert
            FundingStreamPeriod fundingStreamPeriod = _context.FundingStreamPeriods.Find(codeKey);
            Assert.IsNull(fundingStreamPeriod);
        }

        [TestCleanup]
        public void CleanUp()
        {
            foreach (string code in _testedFundingStreamCodes)
            {
                FundingStreamPeriod fsp = _context.FundingStreamPeriods.Find(code);
                if (fsp != null)
                {
                    _context.FundingStreamPeriods.Remove(fsp);
                }
            }

            _context.SaveChanges();
            _context.Dispose();
        }
    }
}
