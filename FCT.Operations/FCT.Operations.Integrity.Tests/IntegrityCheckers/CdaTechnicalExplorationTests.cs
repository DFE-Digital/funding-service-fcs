namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using ContractManagement.DataStore;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Threading;

    [TestClass]
    public class CdaTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CdaTechnicalExploration_ShouldCallCrmForEachFsp()
        {
            string fspTimings = "";
            List<string> fsps = GetFsps();
            DateTime start;
            DateTime end;
            TimeSpan duration;

            fsps.ForEach(f =>
                {
                    List<string> fsp = new List<string>();
                    fsp.Add(f);

//                    fsp.Add("NCS-C1718");
                    start = DateTime.Now;
                    //var rows = new List<CdaRow>();
                    //rows.Add(new CdaRow());
                    var rows = GetData(fsp);
//                    var rows = GetDataForOneFsp(f);
                    end = DateTime.Now;
                    duration = end - start;
                    fspTimings += $"For fsp {f}, this has taken {duration.TotalMinutes} minutes. {rows.Count} Rows returned. {rows.Count} fsps processed." + Environment.NewLine;
                }
            );
            //TimeSpan duration = end - start;
            Assert.Fail(fspTimings);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CdaTechnicalExploration_ShouldCallCrmForCdaExtractWithActiveFsps()
        {
            var activeFsps = GetActiveFspsInOneGroup().SelectMany(f => f.Fsps).ToList();

            DateTime start = DateTime.Now;
            var rows = GetData(activeFsps);
            DateTime end = DateTime.Now;

            var duration = end - start;
            Assert.Fail($"This has taken {duration.TotalMinutes} minutes and {duration.Seconds} seconds. {rows.Count} Rows returned. {activeFsps.Count} fsps processed.");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CdaTechnicalExploration_ShouldCallCrmForCdaExtractForActiveFspsExceptMainstream1819()
        {
            var activeFspsExceptMainstream1819 = GetActiveFspsInOneGroupExceptMainstream1819().SelectMany(f => f.Fsps).ToList();

            DateTime start = DateTime.Now;
            var rows = GetData(activeFspsExceptMainstream1819);
            DateTime end = DateTime.Now;

            var duration = end - start;
            Assert.Fail($"This has taken {duration.TotalMinutes} minutes and {duration.Seconds} seconds. {rows.Count} Rows returned. {activeFspsExceptMainstream1819.Count} fsps processed.");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CdaTechnicalExploration_ShouldCallCrmForCdaExtractForActiveFspsOnlyMainstream1819()
        {
            var activeFspsInOneGroupOnlyMainstream1819 = GetActiveFspsInOneGroupOnlyMainstream1819().SelectMany(f => f.Fsps).ToList();

            DateTime start = DateTime.Now;
            var rows = GetData(activeFspsInOneGroupOnlyMainstream1819);
            DateTime end = DateTime.Now;

            var duration = end - start;
            Assert.Fail($"This has taken {duration.TotalMinutes} minutes and {duration.Seconds} seconds. {rows.Count} Rows returned. {activeFspsInOneGroupOnlyMainstream1819.Count} fsps processed.");
        }


        private IReadOnlyCollection<CdaRow> GetDataForOneFsp(string fsp)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

            string sqlResourceName = @"FCT.Operations.Integrity.Tests.Sql.CrmCdaQuery.sql";

            using (var connection = new SqlConnection(connectionString))
            {
                string sqlQuery = GetSqlScriptFromResource(sqlResourceName);

                return connection.Query<CdaRow>(sqlQuery, new { fsps = fsp }, commandTimeout: 1200).ToList();
            }
        }


        private IReadOnlyCollection<CdaRow> GetData(IEnumerable<string> fsps)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

            string sqlResourceName = @"FCT.Operations.Integrity.Tests.Sql.CrmCdaQuery.sql";

            using (var connection = new SqlConnection(connectionString))
            {
                string sqlQuery = GetSqlScriptFromResource(sqlResourceName);

                return connection.Query<CdaRow>(sqlQuery, new {fsps = fsps}, commandTimeout: 1200).ToList();
            }
        }

        private List<FspGroup> GetActiveFspsInOneGroupExceptMainstream1819()
        {
            List<string> goodExtracts = null;
            using (var context = new ContractManagementDbContext())
            {
                goodExtracts = context.CdaExtracts
                    .Where(e => !e.ReportingCloseDate.HasValue || e.ReportingCloseDate >= DateTime.Now)
                    .Select(r => r.ExtractName)
                    .ToList();
            }
            

            using (var context = new ContractManagementDbContext())
            {
                return Enumerable.Range(0, 1).Select(e => new FspGroup("CDAExtractGroupName",
                    context.CdaReportFundingStreamPeriods
                    .Where(c => c.ExtractName != "Mainstream 18-19" && goodExtracts.Contains(c.ExtractName))
                    .Select(c => c.FundingStreamPeriodCode).ToList())).ToList();
            }
        }

        private List<FspGroup> GetActiveFspsInOneGroupOnlyMainstream1819()
        {
            List<string> goodExtracts = null;
            using (var context = new ContractManagementDbContext())
            {
                goodExtracts = context.CdaExtracts
                    .Where(e => !e.ReportingCloseDate.HasValue || e.ReportingCloseDate >= DateTime.Now)
                    .Where(e => e.ExtractName == "Mainstream 18-19")
                    .Select(r => r.ExtractName)
                    .ToList();
            }

            using (var context = new ContractManagementDbContext())
            {
                return Enumerable.Range(0, 1).Select(e => new FspGroup("CDAExtractGroupName",
                    context.CdaReportFundingStreamPeriods
                        .Where(c => goodExtracts.Contains(c.ExtractName))
                        .Select(c => c.FundingStreamPeriodCode).ToList())
                ).ToList();
            }
        }

        private List<FspGroup> GetActiveFspsInOneGroup()
        {
            List<string> goodExtracts = null;
            using (var context = new ContractManagementDbContext())
            {
                goodExtracts = context.CdaExtracts
                    .Where(e => !e.ReportingCloseDate.HasValue || e.ReportingCloseDate >= DateTime.Now)
                    .Select(r => r.ExtractName)
                    .ToList();
            }

            using (var context = new ContractManagementDbContext())
            {
                return Enumerable.Range(0, 1).Select(e => new FspGroup("CDAExtractGroupName", 
                    context.CdaReportFundingStreamPeriods
                        .Where(c => goodExtracts.Contains(c.ExtractName))
                        .Select(c => c.FundingStreamPeriodCode).ToList())
                    ).ToList();
            }
        }

        private static string GetSqlScriptFromResource(string sqlResourceName)
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(sqlResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }



        private static List<string> GetFsps()
        {
            var fspList = new List<string>
            {
                "16-18TRN1819",
                "1619LR1718",
                "NMF1718",
                "SSF1718",
                "1619LR1819",
                "NMF1819",
                "SSF1819",
                "AEBC1819",
                "AEB-CL1819",
                "AEB-LS1819",
                "AEBTO-CL1819",
                "AEB-TOL1819",
                "AGE1516",
                "AGE1617",
                "AGE1718",
                "24+ALLB1516",
                "24+ALLBC1516",
                "24+ALLF1516",
                "ALLB1617",
                "ALLBC1617",
                "ALLF1617",
                "ALLB1718",
                "ALLBC1718",
                "ALLF1718",
                "ALLB1819",
                "ALLBC1819",
                "ALLF1819",
                "CLP1819",
                "ALLF1920",
                "APPS1819",
                "EOF1417",
                "EOP1517",
                "ESF1420",
                "LEVY1799",
                "16-18APPS1718",
                "16-18NLA1718",
                "16-18NLAP2018",
                "16-18TRN1718",
                "AAPP1718",
                "AEBC1718",
                "AEB-CL1718",
                "AEB-LS1718",
                "AEBTO-CL1718",
                "AEB-TOL1718",
                "AEBTO-LS1718",
                "AEBTO-TOL1718",
                "ANLA1718",
                "ANLAP2018",
                "16-18APPS1516",
                "24+ALLB1516",
                "24+ALLBC1516",
                "24+ALLF1516",
                "ASC1516",
                "ASTO1516",
                "CL1516",
                "DLS1516",
                "OLASS1516",
                "16-18APPS1617",
                "16-18NLA1617",
                "AAC1617",
                "AATO1617",
                "AEBC1617",
                "AEBTO-CL1617",
                "AEBTO-LS1617",
                "AEBTO-TOL1617",
                "ALLB1617",
                "ALLBC1617",
                "ALLF1617",
                "ANLA1617",
                "OLASS1617",
                "NCS-ASIST1718",
                "NCS-C1718",
                "NCS-EA1718",
                "NCS-FWL1718",
                "NCS-I1718",
                "NCS-IC1718",
                "NCS-P1718",
                "NCS-SEEDIC1718",
                "NCS-C1819",
                "NCS-DEV1819",
                "NCS-C1920",
                "NCS-C2018",
                "NCS-I2018",
                "16-18NLAP2018",
                "ANLAP2018"
            };


            return fspList;

        }


        private class CdaRow
        {
            public string FundingStreamPeriodCode { get; set; }
        }

        private class FspGroup
        {
            public FspGroup(string groupName, IReadOnlyCollection<string> fsps)
            {
                GroupName = groupName;
                Fsps = fsps;
            }

            public string GroupName { get; }

            public IReadOnlyCollection<string> Fsps { get; }
        }
    }
}
