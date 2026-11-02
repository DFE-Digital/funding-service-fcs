namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Dapper;
    using Dtos;
    using Extensions;
    using MoreLinq;
    using Optional;

    public static class ApprovedContractRepository
    {
        public static Option<ApprovedContract> GetApprovedContractIfItExists(string contractNumber, int ukprn)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"SELECT [ApprovedContractId]
                                      ,[ContractNumber]
                                      ,[ContractVersionNumber]
                                      ,[ContractSubVersionNumber]
                                      ,[FundingType]
                                      ,[FundingPeriod]
                                      ,[Ukprn]
                                      ,[OrganisationId]
                                      ,[MasterContractNumber]
                                      ,[StartDate]
                                      ,[EndDate]
                                  FROM [ContractManagement].[ApprovedContract]
                                  where ukprn = @ukprn
                                  and ContractNumber = @contractNumber";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<ApprovedContract>(sql, new {contractNumber, ukprn})
                    .SingleOrDefault()
                    .SomeWhen(c => c!= null);
            }
        }

        public static void InsertContractIfNotExists(ApprovedContract approvedContract)
        {
            using (var context = new ContractManagementDbContext())
            {
                ApprovedContract existingEntity = context.ApprovedContracts.SingleOrDefault(ac =>
                        ac.ContractNumber == approvedContract.ContractNumber &&
                        ac.ContractVersionNumber == approvedContract.ContractVersionNumber &&
                        ac.ContractSubVersionNumber == approvedContract.ContractSubVersionNumber);
                
                if (existingEntity == null)
                {
                    context.ApprovedContracts.Add(approvedContract);
                    context.SaveChanges();
                }
            }
        }

        public static IReadOnlyCollection<ApprovedContractAllocationIdentifier> GetApprovedContractAllocationIdentifiersWithIncludeSoF()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select a.ContractAllocationNumber, c.ContractVersionNumber, c.ApprovedContractId, ftfp.IncludeAllContractsOnSummaryOfFunding
                                from [ContractManagement].[ApprovedContract] c,
                                     [ContractManagement].[ApprovedContractAllocation] a,
	                                 [ContractManagement].[FundingTypeFundingPeriod] ftfp
                                where
                                  c.ApprovedContractId = a.ApprovedContractId
                                and c.FundingType = ftfp.FundingTypeCode
                                and c.FundingPeriod = ftfp.FundingPeriodName
								and ftfp.IncludeAllContractsOnSummaryOfFunding = 1";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<ApprovedContractAllocationIdentifier>(sql)
                    .ToList();
            }
        }

        public static async Task InsertDeliverablesForAllocation(
            ApprovedContractAllocationIdentifier approvedContractAllocationIdentifier)
        {
            var deliverablePayments = await DeliverablePaymentRepository.GetPlannedValueLines(
                approvedContractAllocationIdentifier.AllocationNumber,
                approvedContractAllocationIdentifier.VersionNumber);

            if (deliverablePayments.Any())
            {
                int startYear = deliverablePayments.GetStartYear();
                int endYear = deliverablePayments.GetEndYear();

                var deliverables = deliverablePayments.GroupBy(dp => dp.DeliverableCode).ToList()
                    .Select(deliverablePaymentsForDeliverable =>
                    {
                        var totalPlannedValue = deliverablePaymentsForDeliverable.Sum(dp => dp.PlannedValue);

                        var envelope1 = approvedContractAllocationIdentifier.IncludeAllContractsOnSummaryOfFunding
                            ? deliverablePaymentsForDeliverable.GetFirstEnvelope(startYear)
                            : (decimal?) null;

                        var envelope2 = approvedContractAllocationIdentifier.IncludeAllContractsOnSummaryOfFunding
                            ? deliverablePaymentsForDeliverable.GetSecondEnvelope(endYear)
                            : (decimal?) null;

                        return new ApprovedContractDeliverable(
                            approvedContractAllocationIdentifier.AllocationNumber,
                            approvedContractAllocationIdentifier.ApprovedContractId,
                            deliverablePaymentsForDeliverable.Key,
                            totalPlannedValue,
                            envelope1,
                            envelope2);
                    }).ToList();

                await InsertApprovedContractDeliverables(deliverables);
            }
        }

        public static (int approvedContractId, string allocationNumber, decimal envelope1, decimal envelope2,
        List<(decimal? envelope1, decimal? envelope2, int deliverableCode)> deliverbles) GetEnvelopeValuesForAllocation(
            ApprovedContractAllocationIdentifier approvedContractAllocationIdentifier)
        {
            var deliverablePayments = DeliverablePaymentRepository.GetPlannedValueLines(
                approvedContractAllocationIdentifier.AllocationNumber,
                approvedContractAllocationIdentifier.VersionNumber).Result;

            int startYear = deliverablePayments.GetStartYear();
            int endYear = deliverablePayments.GetEndYear();

            var deliverableEnvelopes = deliverablePayments.GroupBy(dp => dp.DeliverableCode).ToList()
                .Select(deliverablePaymentsForDeliverable =>
                {
                    var envelope1 = approvedContractAllocationIdentifier.IncludeAllContractsOnSummaryOfFunding
                        ? deliverablePaymentsForDeliverable.GetFirstEnvelope(startYear)
                        : (decimal?)null;

                    var envelope2 = approvedContractAllocationIdentifier.IncludeAllContractsOnSummaryOfFunding
                        ? deliverablePaymentsForDeliverable.GetSecondEnvelope(endYear)
                        : (decimal?)null;

                    return (envelope1, envelope2, deliverablePaymentsForDeliverable.Key);
                }).ToList();

            var envelope1Total = deliverableEnvelopes.Sum(d => d.envelope1) ?? 0;
            var envelope2Total = deliverableEnvelopes.Sum(d => d.envelope2) ?? 0;

            return (approvedContractAllocationIdentifier.ApprovedContractId,
                approvedContractAllocationIdentifier.AllocationNumber, envelope1Total, envelope2Total, deliverableEnvelopes);
        }

        public static void UpdateApprovedContractAllocation(
            string allocationNumber,
            int contractId,
            decimal plannedValueEnvelope1,
            decimal plannedValueEnvelope2)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"update [ContractManagement].[ApprovedContractAllocation]
                    set      [PlannedValueEnvelope1] = @plannedValueEnvelope1,
                             [PlannedValueEnvelope2] = @plannedValueEnvelope2
                    where [ContractAllocationNumber] = @allocationNumber
                    and [ApprovedContractId] = @contractId";

                connection.Execute(sql, new { allocationNumber, contractId, plannedValueEnvelope1, plannedValueEnvelope2 });
            }
        }

        public static void UpdateApprovedContractDeliverable(
            string allocationNumber,
            int contractId,
            int deliverableCode,
            decimal? plannedValueEnvelope1,
            decimal? plannedValueEnvelope2)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"update [ContractManagement].[ApprovedContractDeliverable]
                    set      [PlannedValueEnvelope1] = @plannedValueEnvelope1,
                             [PlannedValueEnvelope2] = @plannedValueEnvelope2
                    where [ContractAllocationNumber] = @allocationNumber
                    and [ApprovedContractId] = @contractId
                    and [DeliverableCode] = @deliverableCode";

                connection.Execute(sql, new { allocationNumber, contractId, plannedValueEnvelope1, plannedValueEnvelope2, deliverableCode });
            }
        }

        public static IReadOnlyCollection<ApprovedContractAllocationIdentifier> GetApprovedContractAllocationIdentifiersWithIncludeSoFWithMissingDeliverables()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select a.ContractAllocationNumber, c.ContractVersionNumber, c.ApprovedContractId, ftfp.IncludeAllContractsOnSummaryOfFunding
                                from [ContractManagement].[ApprovedContract] c,
                                     [ContractManagement].[ApprovedContractAllocation] a,
	                                 [ContractManagement].[FundingTypeFundingPeriod] ftfp
                                where
                                  c.ApprovedContractId = a.ApprovedContractId
                                and c.FundingType = ftfp.FundingTypeCode
                                and c.FundingPeriod = ftfp.FundingPeriodName
								and ftfp.IncludeAllContractsOnSummaryOfFunding = 1
								and not exists (select 1 from [ContractManagement].[ApprovedContractDeliverable]
								where ApprovedContractId = c.ApprovedContractId)";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<ApprovedContractAllocationIdentifier>(sql)
                    .ToList();
            }
        }

        public static IReadOnlyCollection<ApprovedContractAllocationIdentifier> GetApprovedContractAllocationsWithMissingEnvelopeValues()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select a.ContractAllocationNumber, c.ContractVersionNumber, c.ApprovedContractId, ftfp.IncludeAllContractsOnSummaryOfFunding
                                from [ContractManagement].[ApprovedContract] c,
                                     [ContractManagement].[ApprovedContractAllocation] a,
	                                 [ContractManagement].[FundingTypeFundingPeriod] ftfp
                                where
                                  c.ApprovedContractId = a.ApprovedContractId
                                and c.FundingType = ftfp.FundingTypeCode
                                and c.FundingPeriod = ftfp.FundingPeriodName
								and ftfp.IncludeAllContractsOnSummaryOfFunding = 1
								and (a.PlannedValueEnvelope1 is null
								or a.PlannedValueEnvelope2 is null)";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<ApprovedContractAllocationIdentifier>(sql)
                    .ToList();
            }
        }

        public static void InsertApprovedContractDeliverable(ApprovedContractDeliverable deliverable)
        {
            using (var context = new ContractManagementDbContext())
            {
                ApprovedContractDeliverable existingEntity = context.ApprovedContractDeliverables.SingleOrDefault(d =>
                    d.DeliverableCode == deliverable.DeliverableCode &&
                    d.ApprovedContractId == deliverable.ApprovedContractId &&
                    d.ContractAllocationNumber == deliverable.ContractAllocationNumber);

                if (existingEntity == null)
                {
                    context.ApprovedContractDeliverables.Add(deliverable);

                    context.SaveChanges();
                }
            }
        }

        public static async Task InsertApprovedContractDeliverables(IEnumerable<ApprovedContractDeliverable> deliverables)
        {
            using (var context = new ContractManagementDbContext())
            {
                deliverables.ForEach(d => context.ApprovedContractDeliverables.Add(d));
                
                await context.SaveChangesAsync();
            }
        }
    }
}
