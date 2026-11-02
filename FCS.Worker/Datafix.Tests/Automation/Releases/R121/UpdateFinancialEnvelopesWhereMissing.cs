namespace Datafix.Tests.Automation.Releases.R121
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Datafix.Tests.Extensions;
    using Dtos;

    public class UpdateFinancialEnvelopesWhereMissing : IApplyDataFix
    {
        public string Release => "R121";
        public int StoryNumber => 36925;
        public string Name => "Update Financial Envelopes WhereMissing and for certain fsps";
        public int Order => 1;
        public void ApplyDataFix()
        {
            var contractAllocationInfosWithMissingPlannedValueEnvelopes =
                GetApprovedContractAllocationsToBeIncludedOnSummaryOfFunding(fundingTypeCode: "AEB2021", fundingPeriodName: "AY2122");

            var allocationWithTheWrongVals = GetApprovedContractAllocationsThatMayHaveTheWrongEnvelopes(new List<string>
            {
                "19TRN2020-2122", "AEB-CSO2021",
                "19TRN2020-LS2021", "19TRN2020-2021",
                "AEB-19TRLS2021", "AEB-19TRN1920", // these extra 5 have FE2 as zero when shouldn't be
                "AEB-AS1920", "AEB-ASLS2021",
                "AEB-TOL1819"
            });

            var allocationsToCalculatePlannedVals =
                contractAllocationInfosWithMissingPlannedValueEnvelopes.Concat(allocationWithTheWrongVals);

            allocationsToCalculatePlannedVals.ToList().ForEach(ProcessAllocationToBeIncludedOnSummeryOfFunding);
        }

        private void ProcessAllocationToBeIncludedOnSummeryOfFunding(AllocationInfo allocationInfo)
        {
            var deliverablesToInclude = GetLegalDeliverableCodesForFsp(allocationInfo.FspCode);

            var deliverablePeriods = GetDeliverablePeriodsForAllocation(
                allocationInfo.AllocationNumber,
                allocationInfo.VersionNumber,
                deliverablesToInclude);

            if (deliverablePeriods.Any())
            {
                int startYear = allocationInfo.StartDate.Value.Year;
                int endYear = allocationInfo.EndDate.Value.Year;

                decimal firstEnvelopePlannedValue = deliverablePeriods.GetFirstEnvelope(startYear);

                decimal totalPlannedValue = deliverablePeriods.Sum(dp => dp.PlannedValue);

                decimal secondEnvelopePlannedValue = deliverablePeriods.GetSecondEnvelope(endYear);

                UpdateApprovedContractAllocation(
                    allocationNumber: allocationInfo.AllocationNumber,
                    contractId: allocationInfo.ApprovedContractId,
                    plannedValueEnvelope1: firstEnvelopePlannedValue,
                    plannedValueEnvelope2: secondEnvelopePlannedValue,
                    totalPlannedValue: totalPlannedValue);
            }
        }

        private static void UpdateApprovedContractAllocation(
            string allocationNumber,
            int contractId,
            decimal plannedValueEnvelope1,
            decimal plannedValueEnvelope2,
            decimal totalPlannedValue)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"  update [ContractManagement].[ApprovedContractAllocation]
                    set [PlannedValueEnvelope1] = @plannedValueEnvelope1,
                        [PlannedValueEnvelope2] = @plannedValueEnvelope2,
                        [TotalPlannedValue] = @totalPlannedValue
                    where [ContractAllocationNumber] = @allocationNumber
                    and [ApprovedContractId] = @contractId";

                connection.Execute(sql, new { allocationNumber, contractId, plannedValueEnvelope1, plannedValueEnvelope2, totalPlannedValue });
            }
        }

        private static List<DeliverablePeriodPlannedValue> GetDeliverablePeriodsForAllocation(
            string allocationNumber,
            int versionNumber,
            IReadOnlyCollection<int> deliverableCodesToInclude)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"select  Period, SUM(PlannedValue) as plannedValue from [PaymentSchedule].[DeliverablePayment]
                    where [AllocationNumber] = @allocationNumber
                    and VersionNumber =  @versionNumber
                    and DeliverableCode in @deliverableCodesToInclude
                    and ISNULL(PlannedValue, 0) != 0
                    group by Period";

                return connection.Query<DeliverablePeriodPlannedValue>(sql, new { allocationNumber, versionNumber, deliverableCodesToInclude }).ToList();
            }
        }

        private static List<AllocationInfo> GetApprovedContractAllocationsToBeIncludedOnSummaryOfFunding(string fundingTypeCode, string fundingPeriodName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"select ca.ContractAllocationNumber as allocationNumber,
                             c.ContractVersionNumber as versionNumber,
                             c.ApprovedContractId,
                             ca.FundingStreamPeriodCode as FspCode,
                             c.StartDate,
                             c.EndDate
                        from  [ContractManagement].[ApprovedContractAllocation] ca,
                              [ContractManagement].[ApprovedContract] c,
                              [ContractManagement].[FundingTypeFundingPeriod] ftfp
                        where ca.ApprovedContractId = c.ApprovedContractId
                        and c.FundingType = ftfp.FundingTypeCode
                        and c.FundingPeriod = ftfp.FundingPeriodName
                        and ca.PlannedValueEnvelope1 is null
                        and ca.PlannedValueEnvelope2 is null
                        and ftfp.FundingTypeCode = @fundingTypeCode
						and ftfp.FundingPeriodName = @fundingPeriodName";

                return connection.Query<AllocationInfo>(sql, new {fundingTypeCode, fundingPeriodName}).ToList();
            }
        }

        private static List<AllocationInfo> GetApprovedContractAllocationsThatMayHaveTheWrongEnvelopes(IReadOnlyCollection<string> fsps)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"select ca.ContractAllocationNumber as allocationNumber,
                             c.ContractVersionNumber as versionNumber,
                             c.ApprovedContractId,
                             ca.FundingStreamPeriodCode as FspCode,
                             c.StartDate,
                             c.EndDate
                        from  [ContractManagement].[ApprovedContractAllocation] ca,
                              [ContractManagement].[ApprovedContract] c
                        where ca.ApprovedContractId = c.ApprovedContractId
						and ca.FundingStreamPeriodCode in @fsps                        ";

                return connection.Query<AllocationInfo>(sql, new { fsps }).ToList();
            }
        }

        public IReadOnlyCollection<int> GetLegalDeliverableCodesForFsp(string fspCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            string sql =
                @"select d.DeliverableCode
                  from [ContractManagement].[FundingStreamPeriodLegalDeliverable] d
                  where d.FundingStreamPeriodCode = @fspCode
                  and d.AllowProfile = 1";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<int>(sql, new { fspCode }).ToList();
            }
        }

        private class AllocationInfo
        {
            public AllocationInfo(string allocationNumber, int versionNumber, int approvedContractId, string fspCode, DateTime? startDate, DateTime? endDate)
            {
                AllocationNumber = allocationNumber;
                VersionNumber = versionNumber;
                FspCode = fspCode;
                ApprovedContractId = approvedContractId;
                StartDate = startDate;
                EndDate = endDate;
            }

            public string AllocationNumber { get; }
            public int VersionNumber { get; }
            public string FspCode { get; }
            public int ApprovedContractId { get; }
            public DateTime? StartDate { get; }
            public DateTime? EndDate { get; }
        }
    }
}
