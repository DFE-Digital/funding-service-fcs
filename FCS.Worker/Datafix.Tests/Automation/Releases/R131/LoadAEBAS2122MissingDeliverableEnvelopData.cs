
namespace Datafix.Tests.Automation.Releases.R131
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Datafix.Tests.Extensions;
    using Dtos;
    using Datafix.Tests.Repositories;
    using System.Threading.Tasks;
  


    public class LoadAEBAS2122MissingDeliverableEnvelopData : IApplyDataFix
    {
        public string Release => "R131";
        public int StoryNumber => 37482;
        public string Name => "Update deliverable Envelopes Where Missing for AEB-AS2122";
        public int Order => 1;
        public void ApplyDataFix()
        {

            var approvedContractAllocationsWithMissingEnvelopeValues =
               GetApprovedContractAllocationsWithMissingDeliverableEnvelopeValues(fundingTypeCode: "AEB2021", fundingPeriodName: "AY2122");

            var allocationEnvelopeValues = approvedContractAllocationsWithMissingEnvelopeValues
                .Select(GetEnvelopeValuesForAllocation).ToList();

            allocationEnvelopeValues.ForEach(a =>
            {
                a.deliverbles.ForEach(d =>
                {
                    ApprovedContractRepository.UpdateApprovedContractDeliverable(a.allocationNumber, a.approvedContractId, d.deliverableCode, d.envelope1, d.envelope2);
                });
            });
        }

        public static IReadOnlyCollection<ApprovedContractAllocationIdentifier> GetApprovedContractAllocationsWithMissingDeliverableEnvelopeValues(string fundingTypeCode, string fundingPeriodName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select a.ContractAllocationNumber, c.ContractVersionNumber, c.ApprovedContractId, ftfp.IncludeAllContractsOnSummaryOfFunding
                                from [ContractManagement].[ApprovedContractDeliverable] ad,
                                     [ContractManagement].[ApprovedContract] c,
                                     [ContractManagement].[ApprovedContractAllocation] a,
	                                 [ContractManagement].[FundingTypeFundingPeriod] ftfp
                                where
                                  ad.ApprovedContractId=c.ApprovedContractId
                                and c.ApprovedContractId = a.ApprovedContractId
                                and c.FundingType = ftfp.FundingTypeCode
                                and c.FundingPeriod = ftfp.FundingPeriodName
								and ftfp.IncludeAllContractsOnSummaryOfFunding = 1
								and (ad.PlannedValueEnvelope1 is null
								or ad.PlannedValueEnvelope2 is null)                                
								and c.FundingType=@fundingTypeCode
								and c.FundingPeriod=@fundingPeriodName";
                               


            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<ApprovedContractAllocationIdentifier>(sql,new { fundingTypeCode, fundingPeriodName })
                    .ToList();
            }
        }

       public static (int approvedContractId, string allocationNumber, decimal envelope1, decimal envelope2,
       List<(decimal? envelope1, decimal? envelope2, int deliverableCode)> deliverbles) GetEnvelopeValuesForAllocation(
           ApprovedContractAllocationIdentifier approvedContractAllocationIdentifier)
        {
            var deliverablePayments = GetPlannedValueLines(
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

        public static async Task<IReadOnlyCollection<DeliverablePaymentPlannedValue>> GetPlannedValueLines(
           string allocationNumber, int versionNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select Period, DeliverableCode, PlannedValue from [PaymentSchedule].[DeliverablePayment]
                                where AllocationNumber = @allocationNumber
                                and VersionNumber = @versionNumber";

            using (var connection = new SqlConnection(connectionString))
            {
                var deliverablePayments =
                    await connection.QueryAsync<DeliverablePaymentPlannedValue>(sql,
                        new { allocationNumber, versionNumber }).ConfigureAwait(false);

                return deliverablePayments.ToList();
            }
        }
    }

}

