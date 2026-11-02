namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    public static class AllocationTypeExtensions
    {
        public static CalculationAllocationInput ToCalculationAllocationInput(this allocationType allocationType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos,
            IReadOnlyCollection<CappingGroup> cappingGroups)
        {
            return new CalculationAllocationInput(
                allocationType.contractAllocationNumber,
                allocationType.contractReference.contractVersionNumber,
                allocationType.GetFspCode(),
                ukprn: allocationType.contractorReference.alternativeOrganisationIdentifiers
                    .Single(a => a.OrganisationIdentifierName == alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER)
                    .OrganisationIdentifier,
                contractNumber: allocationType.contractReference.contractNumber,
                orgId: allocationType.contractorReference.organisationIdentifier,
                cappingGroups: cappingGroups.ToList(),
                deliverables: FlattenDeliverables(allocationType.contractDeliverables)
                    .Select(d => new CalculationDeliverableInput(
                        deliverableCode: d.deliverable.deliverableCode, 
                        deliverablePeriods: d.contractDeliverablePeriods
                            .Select(p => new CalculationDeliverablePeriodInput(
                                period: int.Parse(p.period.periodValue),
                                plannedValue: p.plannedValue,
                                plannedVolume: p.plannedVolume)).ToList(),
                        allowProfile: d.IsAllowProfile(fspDeliverableInfos),
                        cappingApportionmentPriorityOrder: d.CappingApportionmentPriorityOrder(fspDeliverableInfos),
                        fundingStreamPeriodCappingGroupId: d.FundingStreamPeriodCappingGroupId(fspDeliverableInfos),
                        allowPayment: d.IsAllowPayment(fspDeliverableInfos)))
                    .ToList());
        }

        private static IReadOnlyCollection<contractDeliverableType> FlattenDeliverables(IReadOnlyCollection<contractDeliverableType> deliverables)
        {
            var results = new List<contractDeliverableType>();
            foreach (var contractDeliverableType in deliverables)
            {
                results.Add(contractDeliverableType);
                if (contractDeliverableType.contractDeliverables != null &&
                    contractDeliverableType.contractDeliverables.Any())
                {
                    results.AddRange(FlattenDeliverables(contractDeliverableType.contractDeliverables));
                }
            }

            return results;
        }
    }
}
