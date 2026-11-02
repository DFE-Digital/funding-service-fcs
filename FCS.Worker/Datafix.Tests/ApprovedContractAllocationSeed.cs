namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Automation;
    using Dapper;
    using Dtos;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ApprovedContractAllocationSeed //: IApplyDataFix
    {
        public string Release => "R67";
        public int StoryNumber => 26143;
        public string Name => "ApprovedContractAllocation PopulatePlannedValues";
        public int Order => 1;
        public void ApplyDataFix()
        {
            ApprovedContractAllocationSeed_PopulatePlannedValues();
        }

        [TestMethod, TestCategory("DataFix_R67")]
        public void ApprovedContractAllocationSeed_PopulatePlannedValues()
        {
            var allocations = GetApprovedContractAllocationsToBeIncludedOnSummaryOfFunding();

            allocations.ForEach(ProcessAllocationToBeIncludedOnSummeryOfFunding);

            allocations = GetApprovedContractAllocationsNotToBeIncludedOnSummaryOfFunding();

            allocations.ForEach(ProcessAllocationNotToBeIncludedOnSummeryOfFunding);
        }

        private void ProcessAllocationToBeIncludedOnSummeryOfFunding(ContractAllocationInfo allocationInfo)
        {
            List<DeliverablePeriodPlannedValue> deliverablePeriods = GetDeliverablePeriodsForAllocation(allocationInfo.AllocationNumber, allocationInfo.VersionNumber);

            string fspFromPaymentSchedule = GetFspForAllocationFromPaymentSchedule(allocationInfo.AllocationNumber, allocationInfo.VersionNumber);

            if (deliverablePeriods.Any())
            {
                int startYear = deliverablePeriods.GetStartYear();

                decimal firstEnvelopePlannedValue = deliverablePeriods.GetFirstEnvelope(startYear);

                decimal totalPlannedValue = deliverablePeriods.Sum(dp => dp.PlannedValue);

                decimal secondEnvelopePlannedValue = totalPlannedValue - firstEnvelopePlannedValue;

                UpdateApprovedContractAllocation(
                    allocationNumber: allocationInfo.AllocationNumber,
                    contractId: allocationInfo.ApprovedContractId,
                    totalPlannedValue: totalPlannedValue,
                    plannedValueEnvelope1: firstEnvelopePlannedValue,
                    plannedValueEnvelope2: secondEnvelopePlannedValue,
                    fundingStreamPeriodCode: fspFromPaymentSchedule);
            }
            else
            {
                UpdateApprovedContractAllocation(
                    allocationNumber: allocationInfo.AllocationNumber,
                    contractId: allocationInfo.ApprovedContractId,
                    fundingStreamPeriodCode: fspFromPaymentSchedule); 
            }
        }

        private void ProcessAllocationNotToBeIncludedOnSummeryOfFunding(ContractAllocationInfo allocationInfo)
        {
            List<DeliverablePeriodPlannedValue> deliverablePeriods = GetDeliverablePeriodsForAllocation(allocationInfo.AllocationNumber, allocationInfo.VersionNumber);
            string fspFromPaymentSchedule = GetFspForAllocationFromPaymentSchedule(allocationInfo.AllocationNumber, allocationInfo.VersionNumber);

            if (deliverablePeriods.Any())
            {
                decimal totalPlannedValue = deliverablePeriods.Sum(dp => dp.PlannedValue);

                UpdateApprovedContractAllocation(
                    allocationNumber: allocationInfo.AllocationNumber,
                    contractId: allocationInfo.ApprovedContractId,
                    totalPlannedValue: totalPlannedValue,                 
                    fundingStreamPeriodCode: fspFromPaymentSchedule);
            }
            else
            {
                if (!string.IsNullOrEmpty(fspFromPaymentSchedule))
                {
                    UpdateApprovedContractAllocation(
                        allocationNumber: allocationInfo.AllocationNumber,
                        contractId: allocationInfo.ApprovedContractId,
                        fundingStreamPeriodCode: fspFromPaymentSchedule);
                }
                else
                {
                    // for some Levy contracts we haven't got a payment schedule
                    if (allocationInfo.AllocationNumber.Contains("LEVY"))
                    {
                        UpdateApprovedContractAllocation(
                            allocationNumber: allocationInfo.AllocationNumber,
                            contractId: allocationInfo.ApprovedContractId,
                            fundingStreamPeriodCode: "LEVY1799");
                    }
                }
            }
        }

        private static List<ContractAllocationInfo> GetApprovedContractAllocationsToBeIncludedOnSummaryOfFunding()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"select ca.ContractAllocationNumber as allocationNumber, c.ContractVersionNumber as versionNumber, c.ApprovedContractId, c.FundingType, c.FundingPeriod 
                        from  [ContractManagement].[ApprovedContractAllocation] ca,
                              [ContractManagement].[ApprovedContract] c,
                              [ContractManagement].[FundingTypeFundingPeriod] ftfp
                        where ca.ApprovedContractId = c.ApprovedContractId
                        and c.FundingType = ftfp.FundingTypeCode
                        and c.FundingPeriod = ftfp.FundingPeriodName
                        and ftfp.IncludeAllContractsOnSummaryOfFunding = 1";

                return connection.Query<ContractAllocationInfo>(sql).ToList();
            }
        }

        private static List<ContractAllocationInfo> GetApprovedContractAllocationsNotToBeIncludedOnSummaryOfFunding()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"select ca.ContractAllocationNumber as allocationNumber, c.ContractVersionNumber as versionNumber, c.ApprovedContractId, c.FundingType, c.FundingPeriod 
                        from  [ContractManagement].[ApprovedContractAllocation] ca,
                              [ContractManagement].[ApprovedContract] c,
                              [ContractManagement].[FundingTypeFundingPeriod] ftfp
                        where ca.ApprovedContractId = c.ApprovedContractId
                        and c.FundingType = ftfp.FundingTypeCode
                        and c.FundingPeriod = ftfp.FundingPeriodName
                        and ftfp.IncludeAllContractsOnSummaryOfFunding = 0";

                return connection.Query<ContractAllocationInfo>(sql).ToList();
            }
        }

        private static string GetFspForAllocationFromPaymentSchedule(string allocationNumber, int versionNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"select [FundingStreamPeriodCode] from [PaymentSchedule].[Allocation] where [AllocationNumber] = @allocationNumber and [VersionNumber] = @versionNumber";

                return connection.ExecuteScalar<string>(sql, new { allocationNumber, versionNumber });
            }
        }

        private static List<DeliverablePeriodPlannedValue> GetDeliverablePeriodsForAllocation(string allocationNumber, int versionNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"select  Period, SUM(PlannedValue) as plannedValue from [PaymentSchedule].[DeliverablePayment]
                    where [AllocationNumber] = @allocationNumber
                    and VersionNumber =  @versionNumber
                    group by Period";

                return connection.Query<DeliverablePeriodPlannedValue>(sql, new {allocationNumber, versionNumber}).ToList();
            }
        }

        private static void UpdateApprovedContractAllocation(
            string allocationNumber,
            int contractId,
            decimal totalPlannedValue,
            decimal plannedValueEnvelope1,
            decimal plannedValueEnvelope2,
            string fundingStreamPeriodCode)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"  update [ContractManagement].[ApprovedContractAllocation]
                    set [TotalPlannedValue] = @totalPlannedValue, [PlannedValueEnvelope1] = @plannedValueEnvelope1, [PlannedValueEnvelope2] = @plannedValueEnvelope2,[FundingStreamPeriodCode] = @fundingStreamPeriodCode
                    where [ContractAllocationNumber] = @allocationNumber
                    and [ApprovedContractId] = @contractId";

                connection.Execute(sql, new { allocationNumber, contractId, totalPlannedValue, plannedValueEnvelope1, plannedValueEnvelope2, fundingStreamPeriodCode });
            }
        }

        private static void UpdateApprovedContractAllocation(
            string allocationNumber,
            int contractId,
            decimal totalPlannedValue,
            string fundingStreamPeriodCode)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"  update [ContractManagement].[ApprovedContractAllocation]
                    set [TotalPlannedValue] = @totalPlannedValue, [FundingStreamPeriodCode] = @fundingStreamPeriodCode
                    where [ContractAllocationNumber] = @allocationNumber
                    and [ApprovedContractId] = @contractId";

                connection.Execute(sql, new { allocationNumber, contractId, totalPlannedValue, fundingStreamPeriodCode });
            }
        }

        private static void UpdateApprovedContractAllocation(
            string allocationNumber,
            int contractId,
            string fundingStreamPeriodCode)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"  update [ContractManagement].[ApprovedContractAllocation]
                    set [FundingStreamPeriodCode] = @fundingStreamPeriodCode
                    where [ContractAllocationNumber] = @allocationNumber
                    and [ApprovedContractId] = @contractId";

                connection.Execute(sql, new { allocationNumber, contractId, fundingStreamPeriodCode });
            }
        }
    }
}
