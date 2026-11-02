namespace FCT.Operations.Tests.FundingConfirmationReport.Services
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Operations.FundingConfirmationReport.DTOs;
    using Operations.FundingConfirmationReport.Services;

    [TestClass]
    public class ExcelGeneratorFundingConfirmationReportTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ExcelGeneratorFundingConfirmationReport_ShouldCreateSpreadsheet()
        {
            // arrange
            ExcelGeneratorFundingConfirmationReport excelGenerator = new ExcelGeneratorFundingConfirmationReport();
            List<ReportRow> reportRows = new List<ReportRow>
            {
                new ReportRow(1, "P1", "PT", CreateFspValues(new List<(string fspDec, int order)>
                {
                    ("Adult Education Budget including Community Learning", 1),
                    ("COVID-19 Skills Offer", 2)
                })),
                new ReportRow(2, "P2", "PT2", CreateFspValues(new List<(string fspDec, int order)>
                {
                    ("Adult Education Budget including Community Learning", 1),
                    ("COVID-19 Skills Offer", 2)
                })),
                new ReportRow(3, "P3", "PT3", CreateFspValues(new List<(string fspDec, int order)>
                {
                    ("COVID-19 Skills Offer", 2)
                })),
            };

            // act
            string title = $"College Funding Confirmation - {new Period(2021)}";
            var workbook = excelGenerator.GenerateWorkbook(reportRows, title);
            workbook.Save($"FundingConfirmation_{DateTime.Now.Ticks}.xlsx");

        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ExcelGeneratorFundingConfirmationReport_ShouldCreateSpreadsheetFromJson()
        {
            // arrange
            ExcelGeneratorFundingConfirmationReport excelGenerator = new ExcelGeneratorFundingConfirmationReport();
            List<ReportRow> reportRows = FromJson("FCT.Operations.Tests", "Resources.ReportRows.json");
            string title = $"College Funding Confirmation - {new Period(1920)}";
            // act
            var workbook = excelGenerator.GenerateWorkbook(reportRows, title);
            workbook.Save($"FundingConfirmation_{DateTime.Now.Ticks}.xlsx");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ExcelGeneratorFundingConfirmationReport_ShouldCreateSpreadsheetFromJson2021()
        {
            // arrange
            ExcelGeneratorFundingConfirmationReport excelGenerator = new ExcelGeneratorFundingConfirmationReport();
            List<ReportRow> reportRows = FromJson("FCT.Operations.Tests", "Resources.ReportRows2021.json");
            string title = $"College Funding Confirmation - {new Period(2021)}";
            // act
            var workbook = excelGenerator.GenerateWorkbook(reportRows, title);
            workbook.Save($"FundingConfirmation_{DateTime.Now.Ticks}.xlsx");
        }

        private List<FspAllocationAndFunded> CreateFspValues(IReadOnlyCollection<(string fspDec, int order)> fspNames)
        {
            return fspNames.Select(fsp => new FspAllocationAndFunded(fsp.fspDec, fsp.fspDec, 10, 11, fsp.order, PaymentMethod.PayOnProfile))
                .ToList();

        }

        public static List<ReportRow> FromJson(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<ReportRow>>(streamReader.ReadToEnd());
            }
        }
    }
}
