using System;
using System.Text;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.ContractRequestDomain.DataStore;
using System.Globalization;
using FCT.Console.Config.ExcelTypes;
using FCT.Console.Config.Transformers;
using SFA.FCT.ContractRequestDomain.DataStore.Model;
using FCT.Console.Config.Synchronizers.Writers.PAAS;
using UnitTests.Common;

namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using Synchronizers.Writers;

    /// <summary>
    /// Summary description for ContractRequestFundingTypeFundingPeriodWriterTests
    /// </summary>
    [TestClass]
    public class ContractRequestFundingTypeFundingPeriodWriterTests:TestBase
    {
        private const string FundingTypeCodeToInsert = "FundingTypeCodeToInsert";
        private const string FundingPeriodNameToInsert = "FundingPeriodNameToInsert";

        private readonly DateTime _testContractingActivityCloseDateTime = DateTime.ParseExact("17/05/2017 00:00:00", "dd/MM/yyyy hh:mm:ss",
               CultureInfo.InvariantCulture);

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new ContractRequestDbContext())
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
            ContractRequestFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(testFundingTypeFundingPeriods, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractRequestDbContext())
            {
                FundingTypeFundingPeriod recordInserted =
                    context.FundingTypeFundingPeriods.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);

                Assert.IsNotNull(recordInserted);
                Assert.AreEqual(_testContractingActivityCloseDateTime, recordInserted.ContractingActivityCloseDate.Value);

            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedFundingTypePeriod_ExistingFundingTypePeriod_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = _testContractingActivityCloseDateTime.AddDays(1);

            //Setup data
            using (var context = new ContractRequestDbContext())
            {
                var originalTestFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();
                context.FundingTypeFundingPeriods.Add(TypeTransformer.Transform<FundingTypePeriodSheetType, FundingTypeFundingPeriod>(originalTestFundingTypeFundingPeriods[0]));
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestFundingStreams = CreateApprovedTestFundingTypeFundingPeriods();
            newTestFundingStreams[0].ContractingActivityCloseDate = updatedValue;

            // act
            ContractRequestFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(newTestFundingStreams, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractRequestDbContext())
            {
                var updatedRecord = context.FundingTypeFundingPeriods.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedRecord.ContractingActivityCloseDate, updatedValue, $"Expected Value {updatedValue.ToString()} doesn't match returned value {updatedRecord.ContractingActivityCloseDate.ToString()}");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aFundingStreamToBeDeleted_TheFundingStream_IsDeleted_InPaasTable()
        {
            // arrange
            var testFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();
            testFundingTypeFundingPeriods[0].PolicyStatus = PolicyStatus.Removed;
            //Setup data to delete
            using (var context = new ContractRequestDbContext())
            {
                context.FundingTypeFundingPeriods.Add(TypeTransformer.Transform<FundingTypePeriodSheetType, FundingTypeFundingPeriod>(testFundingTypeFundingPeriods[0]));
                context.SaveChanges();
            }

            // act
            ContractRequestFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(testFundingTypeFundingPeriods, WriterBehaviour.Delete);

            // assert
            using (var context = new ContractRequestDbContext())
            {
                var deletedRecord = context.FundingTypeFundingPeriods.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<FundingTypePeriodSheetType> CreateApprovedTestFundingTypeFundingPeriods()
        {
            // arrange
            return new List<FundingTypePeriodSheetType>
            {
                new FundingTypePeriodSheetType
                {
                    FundingTypeCode = FundingTypeCodeToInsert,
                    FundingPeriod = FundingPeriodNameToInsert,
                    ContractingActivityCloseDate = _testContractingActivityCloseDateTime
                }
            };
        }

    }
}
