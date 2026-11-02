namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class FundingTypePeriodFundingStreamPeriodWriterTests
    {
        private ContractManagementDbContext _context;
        private const string FundingTypeCode = "TESTFTCODE";
        private const string FundingPeriodCode = "TESTFP1516";
        private const string FundingStreamCode = "TESTFSCODE";

        [TestInitialize]
        public void Setup()
        {
            _context = new ContractManagementDbContext();
            Cleanup();
        }

        [TestCleanup]
        public void Cleanup()
        {
            var testEntry = _context.FundingTypePeriodFundingStreamPeriodItems.Find(FundingTypeCode, FundingPeriodCode,
                FundingStreamCode);

            if (testEntry != null)
            { 
                _context.FundingTypePeriodFundingStreamPeriodItems.Remove(testEntry);
                _context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodWriter_NewFtpFsp_ShouldCreateNewEntryInPaas()
        {
            // arrange
            FundingTypePeriodFundingStreamPeriodSheetType sheet = new FundingTypePeriodFundingStreamPeriodSheetType()
            {
                PolicyStatus = PolicyStatus.Approved,
                FundingStreamCode = FundingStreamCode,
                FundingPeriodCode = FundingPeriodCode,
                FundingTypeCode = FundingTypeCode
            };

            List<FundingTypePeriodFundingStreamPeriodSheetType> sheets =
                new List<FundingTypePeriodFundingStreamPeriodSheetType> {sheet};

            // act
            FundingTypePeriodFundingStreamPeriodWriter.WriteToPaaSDatabase(sheets, WriterBehaviour.AddOrUpdate);

            // assert 
            FundingTypePeriodFundingStreamPeriod entry =
                _context.FundingTypePeriodFundingStreamPeriodItems.Find(FundingTypeCode, FundingPeriodCode,
                    FundingStreamCode);

            Assert.IsNotNull(entry);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodWriter_RemovedFtpFsp_ShouldDeleteEntryInPaas()
        {
            // arrange
            _context.FundingTypePeriodFundingStreamPeriodItems.Add(
                new FundingTypePeriodFundingStreamPeriod(FundingTypeCode, FundingPeriodCode, FundingStreamCode));
            _context.SaveChanges();

            FundingTypePeriodFundingStreamPeriodSheetType sheet = new FundingTypePeriodFundingStreamPeriodSheetType()
            {
                PolicyStatus = PolicyStatus.Removed,
                FundingStreamCode = FundingStreamCode,
                FundingPeriodCode = FundingPeriodCode,
                FundingTypeCode = FundingTypeCode
            };

            List<FundingTypePeriodFundingStreamPeriodSheetType> sheets =
                new List<FundingTypePeriodFundingStreamPeriodSheetType> { sheet };

            // act
            FundingTypePeriodFundingStreamPeriodWriter.WriteToPaaSDatabase(sheets, WriterBehaviour.Delete);

            // assert 
            // need to create new context as the FSPFTP entry is cached in the class instance
            // creating a new context drops that cache
            _context = new ContractManagementDbContext();
            FundingTypePeriodFundingStreamPeriod entry =
                _context.FundingTypePeriodFundingStreamPeriodItems.Find(FundingTypeCode, FundingPeriodCode,
                    FundingStreamCode);

            Assert.IsNull(entry);
        }

        [TestMethod,TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodWriter_DraftFtpFsp_ShouldCreateNewEntryInPaas()
        {
            // arrange
            FundingTypePeriodFundingStreamPeriodSheetType sheet = new FundingTypePeriodFundingStreamPeriodSheetType()
            {
                PolicyStatus = PolicyStatus.Draft,
                FundingStreamCode = FundingStreamCode,
                FundingPeriodCode = FundingPeriodCode,
                FundingTypeCode = FundingTypeCode
            };

            List<FundingTypePeriodFundingStreamPeriodSheetType> sheets =
                new List<FundingTypePeriodFundingStreamPeriodSheetType> { sheet };

            // act
            FundingTypePeriodFundingStreamPeriodWriter.WriteToPaaSDatabase(sheets, WriterBehaviour.AddOrUpdate);

            // assert 
            FundingTypePeriodFundingStreamPeriod entry =
                _context.FundingTypePeriodFundingStreamPeriodItems.Find(FundingTypeCode, FundingPeriodCode,
                    FundingStreamCode);

            Assert.IsNull(entry);
        }

    }
}