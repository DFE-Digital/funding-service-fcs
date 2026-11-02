namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
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
    public class PayGenFundingStreamPeriodWriterTests : TestBase
    {
        private const string FspCodeToInsert = "FspCodeToInsert";
        
        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                var fundingStreamsPeriodsToRemove = new List<FundingStreamPeriod>
                {
                    context.FundingStreamPeriods.Find(FspCodeToInsert)
                };

                foreach (var fsp in fundingStreamsPeriodsToRemove.Where(fs => fs != null))
                {
                    context.FundingStreamPeriods.Remove(fsp);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewFundingStreamPeriod_NewFundingStreamPeriod_IsInserted_InPaasTable()
        {
            // arrange
            var testFundingStreamPeriods = CreateApprovedTestFundingStreamPeriods();

            // act
            PayGenFundingStreamPeriodWriter.WriteToPaaSDatabase(testFundingStreamPeriods, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                Assert.IsNotNull(context.FundingStreamPeriods.Find(FspCodeToInsert));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayGenFundingStreamPeriodWriter_ShouldUpdate()
        {
            // arrange
            var updatedValue = "UpdatedNameToInsert";

            //Setup data
            using (var context = new PaymentGenerationDbContext())
            {
                List<FundingStreamPeriodSheetType> originalTestFundingStreamPeriods = CreateApprovedTestFundingStreamPeriods();
                originalTestFundingStreamPeriods.First().GeneratePayments = true;

                context.FundingStreamPeriods.AddRange(TypeTransformer.TransformCollection<FundingStreamPeriodSheetType, FundingStreamPeriod>(originalTestFundingStreamPeriods));
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestFundingStreamPeriods = CreateApprovedTestFundingStreamPeriods();
            newTestFundingStreamPeriods[0].Name = updatedValue;
            newTestFundingStreamPeriods[0].GeneratePayments = false;

            // act
            PayGenFundingStreamPeriodWriter.WriteToPaaSDatabase(newTestFundingStreamPeriods, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var updatedRecord = context.FundingStreamPeriods.Find(FspCodeToInsert);
                Assert.IsNotNull(updatedRecord, "We have not found the record we were looking for");
                Assert.AreEqual(updatedValue, updatedRecord.Name, "Name has not been updated");
            }
        }

        private List<FundingStreamPeriodSheetType> CreateTestFundingStreamsToDelete()
        {
            return new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = FspCodeToInsert,
                    FundingStreamCode = "AGE",
                        Name = "OriginalNameToInsert",
                        ControlAccountCode = 1,
                        DummyAccountCode = "X",
                        Element1DefaultValue = "X",
                        EndDate = new DateTime(2016, 3, 31),
                        GeneratePayments = true,
                        StartDate = new DateTime(2015, 4, 1),
                        PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private static List<FundingStreamPeriodSheetType> CreateApprovedTestFundingStreamPeriods()
        {
            return new List<FundingStreamPeriodSheetType>
                {
                    new FundingStreamPeriodSheetType
                    {
                        FundingStreamPeriodCode = FspCodeToInsert,
                        FundingStreamCode = "AGE",
                        Name = "OriginalNameToInsert",
                        ControlAccountCode = 1,
                        DummyAccountCode = "X",
                        Element1DefaultValue = "X",
                        EndDate = new DateTime(2016, 3, 31),
                        GeneratePayments = false,
                        StartDate = new DateTime(2015, 4, 1),
                        PolicyStatus = PolicyStatus.Approved
                    }
                };
        }
    }
}
