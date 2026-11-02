namespace FCT.Console.Config.Tests.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Synchronizers.PaaS;

    [TestClass]
    public class PayGenFundingStreamSynchronizerTests : TestBase
    {
        private const string FundingStreamToInsert = "FundingStreamCodeToInsert";
        private const string SheetName = "Funding Stream";
        private WorkbookReader _reader;
        private PaymentGenerationDbContext _context;
        
        [TestInitialize]
        public void Setup()
        {
            _context = new PaymentGenerationDbContext();
        }

        [TestCleanup]
        public void CleanUp()
        {
            var fundingStreamsToRemove = new List<FundingStream>
            {
                _context.FundingStreams.Find(FundingStreamToInsert)
            };

            _context.FundingStreams.RemoveRange(fundingStreamsToRemove);

            _context.Dispose();
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewFundingStream_NewFundingStream_IsInserted_InPaasTable()
        {
            // arrange
            _reader = GetWorkbookReader();
            WorksheetReader worksheetReader = _reader.WorksheetReader(SheetName);

            // act
            new PayGenFundingStreamSynchronizer().SynchronizeConfig(worksheetReader);

            // assert
            Assert.IsNotNull(_context.FundingStreams.Find(FundingStreamToInsert));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedFundingStream_ExistingFundingStream_IsUpdated_InPaasTable()
        {
            // arrange
            var testFundingStream = "OLASS";

            _reader = GetWorkbookReader();
            WorksheetReader worksheetReader = _reader.WorksheetReader(SheetName);

            // Change some data on a record to test the insert.
            var recordToChange = _context.FundingStreams.Find(testFundingStream);
            var originalValue = recordToChange.Name;
            recordToChange.Name = "Incorrect name";
            _context.SaveChanges();

            // act
            new PayGenFundingStreamSynchronizer().SynchronizeConfig(worksheetReader);

            // assert
            //refresh context
            _context = new PaymentGenerationDbContext();

            var updatedRecord = _context.FundingStreams.Find(testFundingStream);
            Assert.IsNotNull(updatedRecord);
            Assert.AreEqual(originalValue, updatedRecord.Name);

        }

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void WhenConfigContains_aFundingStreamToBeDeleted_TheFundingStream_IsDeleted_InPaasTable()
        //{
        //    // arrange
        //    var testFundingStream = "FundingStreamToDelete";

        //    _reader = GetWorkbookReader();
        //    WorksheetReader worksheetReader = _reader.WorksheetReader(SheetName);

        //    // add record to remove
        //    _context.FundingStreams.Add(new FundingStream
        //    {
        //        Code = testFundingStream,
        //        AgencyCode = "AgencyCodeToDelete",
        //        FinanceShortCode = "ShortCodeToDelete",
        //        Name = "NameToDelete"
        //    });
        //    _context.SaveChanges();
            
        //    // act
        //    new PayGenFundingStreamSynchronizer().SynchronizeConfig(worksheetReader);

        //    // assert
        //    //refresh context
        //    _context = new PaymentGenerationDbContext();

        //    Assert.IsNull(_context.FundingStreams.Find(testFundingStream));
        //}
    }
}
