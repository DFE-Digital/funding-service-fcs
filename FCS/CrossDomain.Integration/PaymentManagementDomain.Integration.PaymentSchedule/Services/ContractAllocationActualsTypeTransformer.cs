namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.AllocationActuals;
    using CrossDomain.Integration.Entities.PaymentSchedule;

    public static class ContractAllocationActualsTypeTransformer
    {

        public static Allocation ToPaymentScheduleAllocation(ContractAllocationActualsType allocationType)
        {
            var actualsGroupedByDelCode = allocationType.ActualsSummary.GroupBy(actualSummary => actualSummary.DeliverableCode);
            List<AllocationDeliverable> allocationDeliverables = actualsGroupedByDelCode.Select(g => TransformDelGroupToAllocationDeliverable(g.ToList())).ToList();

            return new Allocation()
            {
                AllocationNumber = allocationType.ContractAllocationNumber,
                ContractNumber = allocationType.ContractReference.ContractNumber,
                ContractVersionNumber = allocationType.ContractReference.ContractVersionNumber,
                VersionNumber = allocationType.ContractReference.ContractVersionNumber,
                FundingStreamPeriodCode = allocationType.FundingStreamPeriodCode,
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = allocationType.ContractorReference.OrganisationIdentifier,
                    OrganisationIdentifiers = new List<OrganisationIdentifier>
                    {
                        new OrganisationIdentifier
                        {
                            OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN,
                            OrganisationId = GetUkprn(allocationType.ContractorReference.AlternativeOrganisationIdentifiers),
                        }
                    }
                },
                
                AllocationDeliverables = allocationDeliverables
            };
        }

        private static string GetUkprn(List<organisationIdentifiersOrganisationIdentifier> organisationIdentifiers)
        {
            return organisationIdentifiers
                .First(id => id.organisationIdentifierType == organisationIdentifierType.UKPROVIDERREFERENCENUMBER)
                .organisationIdentifier;
        }

        private static AllocationDeliverable TransformDelGroupToAllocationDeliverable(IEnumerable<ActualsSummaryType> actualsSummaryTypes)
        {
            return new AllocationDeliverable
            {
                DeliverableCode = actualsSummaryTypes.First().DeliverableCode,
                ScheduledPayments = actualsSummaryTypes.Select(TransformToScheduledPayment).ToList()
            };
        }

        private static ScheduledPayment TransformToScheduledPayment(ActualsSummaryType actualsSummaryType)
        {
            return new ScheduledPayment
            {
                ActualValue = actualsSummaryType.ActualValue,
                ActualVolume = actualsSummaryType.ActualVolume,
                Period = actualsSummaryType.Period,
                PeriodTypeCode = actualsSummaryType.PeriodType.PeriodTypeCode
            };
        }
    }
}
