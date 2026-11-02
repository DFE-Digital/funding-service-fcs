namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    
    [TestClass]
    public class DocumentsDomainFundingTypeFundingPeriodWriterTests : TestBase
    {
        private const string FundingTypeCodeToInsert = "FundingTypeCodeToInsert";
        private const string FundingPeriodNameToInsert = "FundingPeriodNameToInsert";
        private const bool OnlyGenerateFundingAgreementForNewOrUpdatedAllocationsToInsert = true;

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingTypeFundingPeriods.RemoveByKey(FundingTypeCodeToInsert, FundingPeriodNameToInsert);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewFundingTypePeriod_NewFundingTypePeriod_IsInserted_InPaasTable()
        {
            //arrange
            List<FundingTypePeriodSheetType> testFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();

            // act
            DocumentsDomainFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(testFundingTypeFundingPeriods, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                FundingTypeFundingPeriod recordInserted =
                    context.FundingTypeFundingPeriods.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);

                Assert.IsNotNull(recordInserted);
                Assert.AreEqual(OnlyGenerateFundingAgreementForNewOrUpdatedAllocationsToInsert, 
                    recordInserted.OnlyGenerateFundingAgreementForNewOrUpdatedAllocations);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedFundingTypePeriod_ExistingFundingTypePeriod_IsUpdated_InPaasTable()
        {
            // arrange
            //Setup data
            using (var context = new DocumentsDomainDbContext())
            {
                var originalTestFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();
                context.FundingTypeFundingPeriods.Add(TypeTransformer.Transform<FundingTypePeriodSheetType, 
                    FundingTypeFundingPeriod>(originalTestFundingTypeFundingPeriods[0]));
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestFundingStreams = CreateApprovedTestFundingTypeFundingPeriods();
            newTestFundingStreams[0].OnlyGenerateFundingAgreementForNewOrUpdatedAllocations = false;

            // act
            DocumentsDomainFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(newTestFundingStreams, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var updatedRecord = context.FundingTypeFundingPeriods.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(false, updatedRecord.OnlyGenerateFundingAgreementForNewOrUpdatedAllocations);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aFundingStreamToBeDeleted_TheFundingStream_IsDeleted_InPaasTable()
        {
            // arrange
            var testFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();
            testFundingTypeFundingPeriods[0].PolicyStatus = PolicyStatus.Removed;
            //Setup data to delete
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingTypeFundingPeriods.Add(TypeTransformer.Transform<FundingTypePeriodSheetType, FundingTypeFundingPeriod>(testFundingTypeFundingPeriods[0]));
                context.SaveChanges();
            }

            // act
            DocumentsDomainFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(testFundingTypeFundingPeriods, WriterBehaviour.Delete);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var deletedRecord = context.FundingTypeFundingPeriods.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private static List<FundingTypePeriodSheetType> CreateApprovedTestFundingTypeFundingPeriods()
        {
            // arrange
            return new List<FundingTypePeriodSheetType>
            {
                new FundingTypePeriodSheetType
                {
                    FundingTypeCode = FundingTypeCodeToInsert,
                    FundingPeriod = FundingPeriodNameToInsert,
                    OnlyGenerateFundingAgreementForNewOrUpdatedAllocations = true
                }
            };
        }
    }
}