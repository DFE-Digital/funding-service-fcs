namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PayGenFundingStreamWriterTests : TestBase
    {
        private const string FundingStreamToInsert = "FundingStreamCodeToInsert";

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                var fundingStreamsToRemove = new List<FundingStream>
                {
                    context.FundingStreams.Find(FundingStreamToInsert)
                };

                foreach (var fs in fundingStreamsToRemove.Where(fs => fs != null))
                {
                    context.FundingStreams.Remove(fs);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewFundingStream_NewFundingStream_IsInserted_InPaasTable()
        {
            //arrange
            List<FundingStreamSheetType> testFundingStreams = CreateApprovedTestFundingStreams();

            // act
            PayGenFundingStreamWriter.WriteToPaaSDatabase(testFundingStreams, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                Assert.IsNotNull(context.FundingStreams.Find(FundingStreamToInsert));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedFundingStream_ExistingFundingStream_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = "UpdatedNameToInsert";

            //Setup data
            using (var context = new PaymentGenerationDbContext())
            {
                var originalTestFundingStreams = CreateApprovedTestFundingStreams();
                context.FundingStreams.AddRange(TypeTransformer.TransformCollection<FundingStreamSheetType, FundingStream>(originalTestFundingStreams));
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestFundingStreams = CreateApprovedTestFundingStreams();
            newTestFundingStreams[0].Name = updatedValue;

            // act
            PayGenFundingStreamWriter.WriteToPaaSDatabase(newTestFundingStreams, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var updatedRecord = context.FundingStreams.Find(FundingStreamToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue, updatedRecord.Name);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aFundingStreamToBeDeleted_TheFundingStream_IsDeleted_InPaasTable()
        {
            // arrange
            var testFundingStreams = CreateTestFundingStreamsToDelete();

            //Setup data to delete
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreams.AddRange(TypeTransformer.TransformCollection<FundingStreamSheetType, FundingStream>(testFundingStreams));
                context.SaveChanges();
            }

            // act
            PayGenFundingStreamWriter.WriteToPaaSDatabase(testFundingStreams, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var deletedRecord = context.FundingStreams.Find(FundingStreamToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<FundingStreamSheetType> CreateTestFundingStreamsToDelete()
        {
            return new List<FundingStreamSheetType>
            {
                new FundingStreamSheetType
                {
                    Code = FundingStreamToInsert,
                    AgencyCode = "AgencyCodeToInsert",
                    FinanceShortCode = "ShortCodeToInsert",
                    Name = "OriginalNameToInsert",
                    PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private static List<FundingStreamSheetType> CreateApprovedTestFundingStreams()
        {
            // arrange
            return new List<FundingStreamSheetType>
            {
                new FundingStreamSheetType
                {
                    Code = FundingStreamToInsert,
                    AgencyCode = "AgencyCodeToInsert",
                    FinanceShortCode = "ShortCodeToInsert",
                    Name = "NameToInsert",
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
