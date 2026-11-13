
namespace PaymentGenerationDomain.BusinessLogic.Mappers
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Integration.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class AggregatedPaymentMapper : IAggregatedPaymentMapper
    {
        public List<SubnominalAggregation> MapAggregatedPaymentCorporateSchemaToDbEntities(Allocation allocation)
        {
            var subnominalAggregations = new List<SubnominalAggregation>();

            foreach (var allocationPeriod in allocation.AllocationPeriods)
            {
                foreach (var aggregation in allocationPeriod.Aggregations)
                {
                    subnominalAggregations.Add(new SubnominalAggregation
                    {
                        AllocationNumber = allocation.AllocationNumber,
                        AllocationVersionNumber = allocation.VersionNumber,
                        FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                        OrganisationId = allocation.Organisation.MainOrganisationIdentifier,
                        Ukprn = int.Parse(allocation.Organisation.AlternativeOrganisationIdentifiers.Single(x => x.OrganisationIdentifierName == OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER).OrganisationId),
                        PeriodTypeCode = allocationPeriod.PeriodTypeCode.ToString(),
                        Period = allocationPeriod.Period,
                        SubnominalCode = aggregation.SubnominalCode,
                        PaymentType = Enum.GetName(typeof(AggregationPaymentType), aggregation.PaymentType),
                        AggregatedValue = aggregation.AggregatedValue
                    });
                }
            }

            return subnominalAggregations;
        }

        public List<Allocation> MapDbEntitiesToAggregatedPaymentCorporateSchema(List<SubnominalAggregation> subnominalAggregations, ConnectionInfo connectionInfo)
        {
            var allocationValues = new List<Allocation>();

            var groupByStructure = subnominalAggregations
               .GroupBy(subnominalAggregation => new
               {
                   subnominalAggregation.AllocationNumber,
                   subnominalAggregation.FundingStreamPeriodCode,
                   subnominalAggregation.OrganisationId,
                   subnominalAggregation.Ukprn,
                   subnominalAggregation.PeriodTypeCode,
                   subnominalAggregation.Period,
                   subnominalAggregation.PaymentType,
                   subnominalAggregation.SubnominalCode,
                   subnominalAggregation.AggregatedValue,
                   subnominalAggregation.PostedFlag
               })
               .GroupBy(ap => new
               {
                   ap.Key.AllocationNumber,
                   ap.Key.FundingStreamPeriodCode,
                   ap.Key.OrganisationId,
                   ap.Key.Ukprn,
                   ap.Key.PeriodTypeCode,
                   ap.Key.Period
               })
               .GroupBy(a => new
               {
                   a.Key.AllocationNumber,
                   a.Key.FundingStreamPeriodCode,
                   a.Key.OrganisationId,
                   a.Key.Ukprn,
               });

            foreach (var allocations in groupByStructure)
            {
                var allocation = new Allocation
                {
                    AllocationNumber = allocations.Key.AllocationNumber,
                    VersionNumber = GetLatestContractVersionNumberForAllocation(allocations.Key.AllocationNumber, allocations.Key.FundingStreamPeriodCode, connectionInfo),
                    FundingStreamPeriodCode = allocations.Key.FundingStreamPeriodCode,
                    Organisation = new Organisation
                    {
                        MainOrganisationIdentifier = allocations.Key.OrganisationId,
                        AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>()
                                                       {
                                                           new OrgainsationIdentifier()
                                                           {
                                                               OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                                                               OrganisationId = allocations.Key.Ukprn.ToString()
                                                           }
                                                       }
                    },
                    AllocationPeriods = new List<AllocationPeriod>()
                };

                foreach (var ap in allocations)
                {
                    var allocationPeriod = new AllocationPeriod
                    {
                        Period = ap.Key.Period,
                        PeriodTypeCode = (AllocationPeriodPeriodTypeCode)Enum.Parse(typeof(AllocationPeriodPeriodTypeCode), ap.Key.PeriodTypeCode),
                        Aggregations = new List<Aggregation>()
                    };

                    foreach (var aggregation in ap)
                    {
                        var agg = new Aggregation
                        {
                            SubnominalCode = aggregation.Key.SubnominalCode,
                            PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), aggregation.Key.PaymentType),
                            AggregatedValue = aggregation.Key.AggregatedValue,
                            PostedFlag = aggregation.Key.PostedFlag
                        };

                        allocationPeriod.Aggregations.Add(agg);
                    }

                    allocation.AllocationPeriods.Add(allocationPeriod);
                }

                allocationValues.Add(allocation);
            }

            return allocationValues;
        }

        public int GetLatestContractVersionNumberForAllocation(string allocationNumber, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                int versionNumber = 0;
                var allocations =
                    context.Allocations.Where(
                        x => x.AllocationNumber == allocationNumber && x.FundingStreamPeriodCode == fundingStreamPeriodCode);
                if (allocations.Count() > 1)
                {
                    versionNumber = allocations.Max(x => x.VersionNumber);
                }
                else if (allocations.Count() == 1)
                {
                    versionNumber = allocations.Single().VersionNumber;
                }
                return versionNumber;
            }
        }
    }
}