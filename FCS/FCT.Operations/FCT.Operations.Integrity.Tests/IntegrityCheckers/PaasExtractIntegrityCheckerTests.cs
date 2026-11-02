namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using System;
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;
    using SFA.FCT.Operations.Integrity.Storage;

    [TestClass]
    public class PaasExtractIntegrityCheckerTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void AidanPaasExtract_CheckValues_ShouldReturnExpectedValues()
        {
            AidanPaasExtract aidanPaasExtract = new AidanPaasExtract(new ContractManagementDbContext());

            IntegrityCheckResult result = aidanPaasExtract.CheckValues();

            Assert.IsFalse(result.FoundIssues, "FoundIssues was not set to false.");
            Assert.IsNotNull(result.IssuesCsv, "IssueCsv was null.");
        }

        [TestMethod, TestCategory("DataDependent")]
        public void IntegrityCheckerRunner_RunningAidanPaasExtract_ShouldWriteExpectedOutputToBlobStorage()
        {
            IIntegrityCheckerRunner runner = new IntegrityCheckerRunner(
                new AidanPaasExtract(new ContractManagementDbContext()),
                new AzureDocumentStoreWriter(null),
                null,
                Mock.Of<ILogger>(),
                new IntegrityCheckChangeTrackingRepository(Mock.Of<IFcsConfiguration>()), new LocalConfig());

            runner.Run("AIDAN_PAAS_EXTRACT", DateTime.UtcNow);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void AnitaPaasExtract_CheckValues_ShouldReturnExpectedValues()
        {
            AnitaPaasExtract anitaPaasExtract = new AnitaPaasExtract(new PaasDeliverablePaymentLazyRepository(new ContractManagementDbContext().Database.Connection, new LoggerNullObject()));

            IntegrityCheckResult result = anitaPaasExtract.CheckValues();

            Assert.IsFalse(result.FoundIssues, "FoundIssues was not set to false.");
            Assert.IsNotNull(result.IssuesCsv, "IssueCsv was null.");
        }

        [TestMethod, TestCategory("DataDependent")]
        public void IntegrityCheckerRunner_RunningAnitaPaasExtract_ShouldWriteExpectedOutputToBlobStorage()
        {
            IIntegrityCheckerRunner runner = new IntegrityCheckerRunner(
                new AnitaPaasExtract(new PaasDeliverablePaymentLazyRepository(new ContractManagementDbContext().Database.Connection, new LoggerNullObject())),
                new AzureDocumentStoreWriter(new LocalConfig()),
                null,
                Mock.Of<ILogger>(),
                new IntegrityCheckChangeTrackingRepository(new LocalConfig()), new LocalConfig());

            runner.Run("ANITA_PAAS_EXTRACT", DateTime.UtcNow);
        }
    }
}
