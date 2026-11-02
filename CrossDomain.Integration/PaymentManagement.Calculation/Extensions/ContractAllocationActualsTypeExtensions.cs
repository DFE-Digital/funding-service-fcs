namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    public static class ContractAllocationActualsTypeExtensions
    {
        public static CalculationAllocationInput ToCalculationAllocationInput(
            this ContractAllocationActualsType contractAllocationActualsType,
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos,
            IReadOnlyCollection<CappingGroup> cappingGroups)
        {
            return new CalculationAllocationInput(
                contractAllocationActualsType.ContractAllocationNumber,
                contractAllocationActualsType.ContractReference.ContractVersionNumber,
                contractAllocationActualsType.FundingStreamPeriodCode,
                ukprn: contractAllocationActualsType.ContractorReference.AlternativeOrganisationIdentifiers
                    .Single(a => a.organisationIdentifierType == organisationIdentifierType.UKPROVIDERREFERENCENUMBER)
                    .organisationIdentifier,
                contractNumber: contractAllocationActualsType.ContractReference.ContractNumber,
                orgId: contractAllocationActualsType.ContractorReference.OrganisationIdentifier,
                cappingGroups: cappingGroups.ToList(),
                deliverables: contractAllocationActualsType.ActualsSummary.GroupBy(a => a.DeliverableCode)
                    .Select(grp =>
                        {
                            var deliverable = grp.First();
                            return new CalculationDeliverableInput(
                                grp.Key,
                                grp.Select(p => new CalculationDeliverablePeriodInput(
                                    int.Parse(p.Period),
                                    p.ActualVolume,
                                    p.ActualValue)).ToList(),
                                deliverable.IsAllowProfile(fspDeliverableInfos),
                                deliverable.CappingApportionmentPriorityOrder(fspDeliverableInfos),
                                deliverable.FundingStreamPeriodCappingGroupId(fspDeliverableInfos),
                                deliverable.IsAllowPayment(fspDeliverableInfos));
                        }
                    ).ToList());
        }
    }
}