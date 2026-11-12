namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class SendRunReportCommandTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SendRunReportCommandsForErroredCdaReports()
        {
            /*
            CDA Last Approved Version Mainstream 17-18
            CDA Latest Version Mainstream 17-18
            CDA Last Approved Version Mainstream 18-19
            CDA Latest Version Mainstream 18-19
            */

            // arrange
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<RunReportCommand>();

            ReportInfo[] reportInfos =
            {
                new ReportInfo(fileName: "CDA Last Approved Version Mainstream 17-18.csv",
                    extractName: "Mainstream 17-18", isLatestVersion: false),
                new ReportInfo(fileName: "CDA Latest Version Mainstream 17-18.csv", extractName: "Mainstream 17-18",
                    isLatestVersion: true),
                new ReportInfo(fileName: "CDA Last Approved Version Mainstream 18-19.csv",
                    extractName: "Mainstream 18-19", isLatestVersion: false),
                new ReportInfo(fileName: "CDA Latest Version Mainstream 18-19.csv", extractName: "Mainstream 18-19",
                    isLatestVersion: true)
            };

            var commands = reportInfos.Select(ri =>
            {
                var fsps = GetFspsForCDA(ri.ExtractName);
                string fspsCsv = string.Join(",", fsps);
                string[] fspArray = {"FundingStreamPeriod", fspsCsv};
                
                return new RunReportCommand
                {
                    ReportName = "CDAExtract",
                    ReportParameters = new[]
                    {
                        fspArray,
                        new[] {"IsLatestVersion", ri.IsLatestVersion.ToString()}
                    },
                    ReportFormat = "CSV",
                    FileName = ri.FileName,
                    ReportPath = "/",
                    ArchiveChildFolderName = null
                };
            }).ToList();
            

            //RunReportCommand[] commands = {
            //    new RunReportCommand
            //    {
            //        ReportName = "CDAExtract",
            //        ReportParameters = new[]
            //        {
            //            new[] { "FundingStreamPeriod", "16-18APPS1718", "16-18NLA1718", "16-18NLAP2018", "16-18TRN1718", "AAPP1718", "AEBC1718", "AEB-CL1718", "AEB-LS1718", "AEBTO-CL1718", "AEB-TOL1718", "AEBTO-LS1718", "AEBTO-TOL1718", "ANLA1718", "ANLAP2018" },
            //            new[] { "IsLatestVersion", "False" }
            //        },
            //        ReportFormat = "CSV",
            //        FileName = "CDA Last Approved Version Mainstream 17-18.csv",
            //        ReportPath = "/",
            //        ArchiveChildFolderName = null
            //    },
            //    new RunReportCommand
            //    {
            //        ReportName = "CDAExtract",
            //        ReportParameters = new[]
            //        {
            //            new[] { "FundingStreamPeriod", "16-18APPS1718", "16-18NLA1718", "16-18NLAP2018", "16-18TRN1718", "AAPP1718", "AEBC1718", "AEB-CL1718", "AEB-LS1718", "AEBTO-CL1718", "AEB-TOL1718", "AEBTO-LS1718", "AEBTO-TOL1718", "ANLA1718", "ANLAP2018" },
            //            new[] { "IsLatestVersion", "True" }
            //        },
            //        ReportFormat = "CSV",
            //        FileName = "CDA Latest Version Mainstream 17-18.csv",
            //        ReportPath = "/",
            //        ArchiveChildFolderName = null
            //    },
            //    new RunReportCommand
            //    {
            //        ReportName = "CDAExtract",
            //        ReportParameters = new[]
            //        {
            //            new[] { "FundingStreamPeriod", "16-18NLAP2018", "16-18TRN1819", "AEBC1819", "AEB-CL1819", "AEB-LS1819", "AEBTO-CL1819", "AEB-TOL1819", "ALLB1819", "ALLBC1819", "ANLAP2018", "APPS1819" },
            //            new[] { "IsLatestVersion", "False" }
            //        },
            //        ReportFormat = "CSV",
            //        FileName = "CDA Last Approved Version Mainstream 18-19.csv",
            //        ReportPath = "/",
            //        ArchiveChildFolderName = null
            //    },
            //    new RunReportCommand
            //    {
            //        ReportName = "CDAExtract",
            //        ReportParameters = new[]
            //        {
            //            new[] { "FundingStreamPeriod", "16-18NLAP2018", "16-18TRN1819", "AEBC1819", "AEB-CL1819", "AEB-LS1819", "AEBTO-CL1819", "AEB-TOL1819", "ALLB1819", "ALLBC1819", "ANLAP2018", "APPS1819" },
            //            new[] { "IsLatestVersion", "True" }
            //        },
            //        ReportFormat = "CSV",
            //        FileName = "CDA Latest Version Mainstream 18-19.csv",
            //        ReportPath = "/",
            //        ArchiveChildFolderName = null
            //    }
            //};

            // act
            commands.ForEach(cmd =>
            {
                endpoint.Send("CrossDomain.Integration.ReportRunner", cmd).Wait();
            });
        }

        private class ReportInfo
        {
            public ReportInfo(string fileName, string extractName, bool isLatestVersion)
            {
                FileName = fileName;
                ExtractName = extractName;
                IsLatestVersion = isLatestVersion;
            }

            public string FileName { get; }

            public string ExtractName { get; }

            public bool IsLatestVersion { get; }
        }

        private static IList<string> GetFspsForCDA(string cdaExtractName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql = @"SELECT [FundingStreamPeriodCode] 
                            FROM [ContractManagement].[CdaReportFundingStreamPeriod]  where ExtractName = @extractName";

                return connection.Query<string>(sql, new
                {
                    extractName = cdaExtractName
                }).ToList();
            }
        }
    }
}