namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System.Linq;
    using System.Collections.Generic;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SubnominalAggregationRepository : ISubnominalAggregationRepository
    {
        public IReadOnlyCollection<SubnominalAggregationDto> GetSubnominalAggregationsForPaymentByFspAndPeriod(string fspCode, string period, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return (from sa in context.SubnominalAggregations
                        where sa.FundingStreamPeriodCode == fspCode
                           && sa.Period == period
                           && sa.AggregatedValue != 0
                           && sa.IsSelectedForPayment
                        select new SubnominalAggregationDto
                        {
                            AllocationNumber = sa.AllocationNumber,
                            AllocationVersionNumber = sa.AllocationVersionNumber,
                            SubnominalCode = sa.SubnominalCode,
                            AggregatedValue = sa.AggregatedValue,
                            ShortDescription = sa.Subnominal.ShortDescription,
                            PaymentType = sa.PaymentType,
                            OrganisationId = sa.OrganisationId,
                            Ukprn = sa.Ukprn,
                            AgencyCode = sa.FundingStreamPeriod.FundingStream.AgencyCode,
                            StartDate = sa.FundingStreamPeriod.StartDate,
                            EndDate = sa.FundingStreamPeriod.EndDate,
                            FinanceShortCode = sa.FundingStreamPeriod.FundingStream.FinanceShortCode
                        }).ToList();
            }
        }

        public bool HasOutstandingPaymentsForAllocation(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return context.SubnominalAggregations.Any(sa => sa.AllocationNumber == allocationNumber && !sa.PostedFlag && sa.AggregatedValue != 0);
            }
        }
    }
}
