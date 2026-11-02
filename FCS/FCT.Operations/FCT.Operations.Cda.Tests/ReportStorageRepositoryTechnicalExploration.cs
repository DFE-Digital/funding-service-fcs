namespace FCT.Operations.Cda.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using Cda.Repositories;
    using Dtos;
    using Infrastructure.Csv;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReportStorageRepositoryTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ReportStorageRepository_ShouldGetAndCreateReportFile()
        {
            ReportStorageRepository repository = new ReportStorageRepository();

            // CDA Mainstream 18/19 Last Approved is now split into these:
            List<string> reportNames = new List<string>
            {
                "CDA Last Approved Version 16-18 Traineeships 18-19.csv",
                "CDA Last Approved Version AEB 18-19.csv",
                "CDA Last Approved Version All Loans 18-19.csv",
                "CDA Last Approved Version Apprenticeships Carry-In 18-19.csv",
                "CDA Last Approved Version Procured Non-Levy Apprenticeships.csv",
            };
            
            reportNames.ForEach(reportName =>
            {
                Report report = repository.Get(reportName);
                List<string> csvRows = new CsvCreator<CdaRow>().CreateFileLines(report.Rows);

                File.WriteAllLines($"{Directory.GetCurrentDirectory()}//{reportName}", csvRows);
            });
        }
    }
}
