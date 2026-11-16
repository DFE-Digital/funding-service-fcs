namespace FCT.Operations.Tests.FundingAllocationExtract
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using FCT.Operations.FundingAllocationExtract;
    using FCT.Operations.FundingAllocationExtract.DTOs;
    using FCT.Operations.FundingAllocationExtract.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    [TestClass]
    public class ExcelGeneratorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationExtract_ExcelGenerator_ShouldGetWorkBook()
        {
            // arrange 
            var excelGenerator = new ExcelGenerator();

            // act
            var workbook = excelGenerator.GenerateWorkbook(new ExtractRow[0], new ExtractRow[0]);

            // assert
            Assert.IsNotNull(workbook);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingAllocationExtract_ExcelGenerator_ShouldGenerateWorkbookAndAndPopulateRowsInBothTabs()
        {
            // arrange
            var excelGenerator = new ExcelGenerator();

            // act
            var workbook = excelGenerator.GenerateWorkbook(GetParkedExtractDummyRows(), GetDiscardedExtractDummyRows());

            workbook.Save("FundingAllocationExtractTest.xlsx");
            Assert.IsNotNull(workbook);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingAllocationExtract_ExcelGenerator_ShouldGenerateWorkbookAndAndPopulateOatRowsUsingRepository()
        {
            // arrange
            var excelGenerator = new ExcelGenerator();

            // act
            var workbook = excelGenerator.GenerateWorkbook(
                GetExtractRowsFromRepository(FundingAllocationExtractType.Parked),
                GetExtractRowsFromRepository(FundingAllocationExtractType.Discarded));

            workbook.Save("FundingAllocationExtractTestUsingRepository.xlsx");
            Assert.IsNotNull(workbook);
        }

        private static IReadOnlyCollection<ExtractRow> GetExtractRowsFromRepository(FundingAllocationExtractType fundingAllocationExtractType)
        {
            // arrange
            const string sqlConnectionString = "Data Source=gy2thhzgc4.database.windows.net;Initial Catalog=fct-database-oat;Persist Security Info=True;User ID=fctsa;Password=PPPassword@9";

            var repository = new FundingAllocationExtractRepository();

            // act
            using (var context = new PaymentSchedulePolicyContext(new SqlConnection(sqlConnectionString)))
            {
                var rows = repository.GetExtract(fundingAllocationExtractType,
                    new ConnectionInfo(null, context.Database.Connection)).Result;

                return rows;
            }
        }

        private static List<ExtractRow> GetParkedExtractDummyRows()
        {
            var lastParked = new DateTime(2021, 5, 11);
            var lastDiscarded = new DateTime(2021, 6, 11);
            var willProbablyBeRemovedFromDto = string.Empty;

            return new List<ExtractRow>
            {
                new ExtractRow(lastParked, lastDiscarded, "1619-AS-2122-Contract-LocalAuthoritySSF-10007697-3_0", "10007697", "Local", "10LAU", "1619", "AS2122", "3_0", 3000234M, "ABC Council", "AY2122", "Education and Skills Funding", "16-19ED2122", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Parked", "Awaiting Outcome", willProbablyBeRemovedFromDto, "Conditions of Funding (Grant) (LA)", willProbablyBeRemovedFromDto),
                new ExtractRow(lastParked, lastDiscarded, "1619-AS-2122-Contract-Provider-10009999-1_0", "10009999", "Furth", "03SFC", "1619", "AS2122", "1_0", 234567M, "Outlier Training", "AY2122", "Education and Skills Funding", "16-19ED2122", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Parked", "Awaiting Contract Type Config", willProbablyBeRemovedFromDto, "", willProbablyBeRemovedFromDto),
                new ExtractRow(lastParked, lastDiscarded, "NLG-AS-2122-Contract-Provider-10001234-1_0", "10001234","Furth", "01GFE", "NLG", "AS2122", "1_0", 234567M,"XYZ Training", "AY2122", "", "NLG2122", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Parked", "Awaiting Funding Line Config", willProbablyBeRemovedFromDto, "Non Learning Grant", willProbablyBeRemovedFromDto),
                new ExtractRow(lastParked, lastDiscarded, "DADA-AS-2122-Contract-Provider-10009876-1_0", "10009876", "Furth","02IPP", "DADA", "AS2122", "1_0", 1234M, "Jelly Dance!", "", "", "", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Parked", "Awaiting Funding Allocation Config", willProbablyBeRemovedFromDto, "", willProbablyBeRemovedFromDto), 
                new ExtractRow(lastParked, lastDiscarded, "NLG-AS-2122-Contract-Provider-11111234-2_0", "11111234", "Furth","06SDC", "NLG", "AS2122", "2_0", 1234567M, "", "", "", "", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Parked", "Awaiting Provider Data", willProbablyBeRemovedFromDto, "", willProbablyBeRemovedFromDto),
                new ExtractRow(lastParked, lastDiscarded, "NMSS-AS-2122-Contract-Provider-10016972-2_0", "10016972", "Schoo","21NMS", "NMSS", "AS2122", "2_0", 1100000M, "St Catherines School", "AY2122", "Education and Skills Funding", "16-19ED2122", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Parked", "Awaiting Outcome", willProbablyBeRemovedFromDto, "Conditions of Funding (Grant) (NMSS)", willProbablyBeRemovedFromDto),
            };
        }

        private static List<ExtractRow> GetDiscardedExtractDummyRows()
        {
            var lastParked = new DateTime(2021, 5, 11);
            var lastDiscarded = new DateTime(2021, 6, 11);
            var willProbablyBeRemovedFromDto = string.Empty;

            return new List<ExtractRow>
            {
                new ExtractRow(new DateTime(2021, 5, 11), lastDiscarded, "1619-AS-2122-Contract-LocalAuthoritySSF-10007697-2_0", "10007697", "Local", "10LAU", "1619", "AS2122", "2_0", 2345654M, "ABC Council", "AY2122", "Education and Skills Funding", "16-19ED2122", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Discarded", "Superseded", willProbablyBeRemovedFromDto, "Conditions of Funding (Grant) (LA)", willProbablyBeRemovedFromDto),
                new ExtractRow(new DateTime(2021, 4, 30), lastDiscarded, "1619-AS-2122-Contract-Provider-12222333-3_0", "12222333", "Furth", "01GFE", "1619", "AS2122", "3_0", 35000M, "Instant Skill", "AY2122", "Education and Skills Funding", "16-19ED2122", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Discarded", "Non-Material Update", willProbablyBeRemovedFromDto, "Contract for Services (ITP)", willProbablyBeRemovedFromDto),
                new ExtractRow(new DateTime(2021, 5, 11), lastDiscarded, "NLG-AS-2122-Contract-Provider-11111234-1_0", "11111234","Furth", "06SDC", "NLG", "AS2122", "1_0", 1234567M,"", "", "", "", willProbablyBeRemovedFromDto, willProbablyBeRemovedFromDto, "Discarded", "Superseded", willProbablyBeRemovedFromDto, "", willProbablyBeRemovedFromDto),
            };
        }
    }
}