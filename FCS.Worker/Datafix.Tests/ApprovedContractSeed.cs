namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Configuration;
    using System.Data.SqlClient;
    using Automation;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class ApprovedContractSeed //: IApplyDataFix
    {
        public string Release => "R67";
        public int StoryNumber => 26143;
        public string Name => "ApprovedContract PopulateMasterContractNumberAndStartDateAndEndDate";
        public int Order => 1;
        public void ApplyDataFix()
        {
            ApprovedContractSeed_PopulateMasterContractNumberAndStartDateAndEndDate();
        }

        [TestMethod, TestCategory("DataFix_R67")]
        public void ApprovedContractSeed_PopulateMasterContractNumberAndStartDateAndEndDate()
        {
            var contractNumbers = GetApprovedContractNumbersThatNeedToBeSeeded();

            contractNumbers
                .Batch(100)
                .ForEach(batchOfIds =>
                {
                    var contractInfos = GetContractInfosFromCrm(batchOfIds);

                    var areAnyContractsOnMoreThanOneMaster = contractInfos
                        .GroupBy(n => n.ContractNumber)
                        .Any(g => g.Count() > 1);

                    Assert.IsFalse(areAnyContractsOnMoreThanOneMaster, "There are contract numbers with more than one master contract number");

                    Assert.AreEqual(batchOfIds.Count(), contractInfos.Count, "Incorrect number of records returned from CRM");

                    contractInfos.ForEach(UpdateApprovedContractWithMasterContractNumberAndStartDateAndEndDate);
                });

            var approvedContractNumbersThatStillNeedToBeSeeded = GetApprovedContractNumbersThatNeedToBeSeeded();
            Assert.AreEqual(0, approvedContractNumbersThatStillNeedToBeSeeded.Count, "After the update there are still ApprovedContracts that still need to seeded");
        }

        private static IReadOnlyCollection<string> GetApprovedContractNumbersThatNeedToBeSeeded()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT [ContractNumber]
                                     FROM[ContractManagement].[ApprovedContract]
                                     WHERE (MasterContractNumber IS NULL OR RTRIM(MasterContractNumber) = '')
                                     OR StartDate IS NULL";

                return connection.Query<string>(sql).ToList();
            }
        }

        private static IReadOnlyCollection<ContractInfo> GetContractInfosFromCrm(IEnumerable<string> contractNumbers)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT DISTINCT child.sfa_number contractNumber, parent.sfa_number masterContractNumber
                                     , child.sfa_startdate startDate, child.sfa_enddate endDate
                                     FROM [dbo].[sfa_contractBase] child
                                     INNER JOIN [dbo].[sfa_contractBase] parent
                                     ON child.sfa_ParentContractId = parent.sfa_contractId
                                     WHERE child.sfa_LastApprovedVersion = 1
									 AND (   child.sfa_ContractStatus = 229660001 
										  OR child.sfa_ContractStatus = 229660005)
                                     AND child.sfa_number IN @ContractIds";

                // Note:- 229660001 represents CRM status 'Approved'
                //    and 229660005 represents CRM status 'Closed'

                return connection.Query<ContractInfo>(sql, new
                {
                    ContractIds = contractNumbers
                }).ToList();
            }
        }

        private static void UpdateApprovedContractWithMasterContractNumberAndStartDateAndEndDate(ContractInfo contractInfo)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"UPDATE [ContractManagement].[ApprovedContract]
                                     SET MasterContractNumber = @MasterContractNumber,
                                     StartDate = @StartDate,
                                     EndDate =  @EndDate
                                     WHERE ContractNumber = @ContractNumber";

                connection.Execute(sql, new
                {
                    contractInfo.MasterContractNumber,
                    contractInfo.ContractNumber,
                    contractInfo.StartDate,
                    contractInfo.EndDate
                });
            }
        }

        private class ContractInfo
        {
            public ContractInfo(string contractNumber, string masterContractNumber, DateTime? startDate, DateTime? endDate)
            {
                ContractNumber = contractNumber;
                MasterContractNumber = masterContractNumber;
                StartDate = startDate;
                EndDate = endDate;
            }

            public string ContractNumber { get; }

            public string MasterContractNumber { get; }

            public DateTime? StartDate { get; }

            public DateTime? EndDate { get; }

        }
    }
}
