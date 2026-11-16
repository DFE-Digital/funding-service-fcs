namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint
{
    extern alias Entities;
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;
    using Extensions;
    using Repositories;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class UpSertSubmoninalAggregationService : IUpSertSubmoninalAggregationService
    {
        private readonly ISubnominalAggregationRepository _subnominalAggregationRepository;

        public UpSertSubmoninalAggregationService(ISubnominalAggregationRepository subnominalAggregationRepository)
        {
            _subnominalAggregationRepository = subnominalAggregationRepository;
        }

        public void UpSert(IReadOnlyCollection<AllocationPeriodWithExistingData> allocationPeriodsWithExistingData, Allocation allocation, ConnectionInfo connectionInfo)
        {
            allocationPeriodsWithExistingData.ToList()
                .ForEach(ap =>
                {
                    ap.AllocationPeriod.Aggregations.ForEach(ag =>
                    {
                        SimpleSubnominalAggregation simpleSubnominalAggregation =
                            FindMatchingSubnominalAggregation(ag, ap.ExistingSubnominalAggregations);

                        if (simpleSubnominalAggregation != null)
                        {
                            simpleSubnominalAggregation.AggregatedValue = ag.AggregatedValue;
                            simpleSubnominalAggregation.VersionNumber = allocation.VersionNumber;
                            _subnominalAggregationRepository.Update(simpleSubnominalAggregation, connectionInfo);
                        }
                        else
                        {
                            var subnominalAggregation = ag.ToSubnominalAggregation(allocation, ap.AllocationPeriod.Period,
                                ap.AllocationPeriod.PeriodTypeCode.ToString());

                            _subnominalAggregationRepository.Insert(subnominalAggregation, connectionInfo);
                        }
                    });
                });
        }

        private SimpleSubnominalAggregation FindMatchingSubnominalAggregation(Aggregation aggregation,
            IReadOnlyCollection<SimpleSubnominalAggregation> subnominalAggregations)
        {
            return subnominalAggregations.FirstOrDefault(sa =>
                sa.SubnominalCode == aggregation.SubnominalCode &&
                sa.PaymentType == aggregation.PaymentType.ToString());
        }
    }
}
