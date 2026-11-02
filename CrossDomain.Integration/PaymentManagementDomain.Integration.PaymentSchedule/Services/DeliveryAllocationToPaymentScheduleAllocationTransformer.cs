namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Entities.PaymentSchedule;

    public static class DeliveryAllocationToPaymentScheduleAllocationTransformer
    {
        public static Allocation ToPaymentScheduleAllocation(allocationType deliveryAllocation)
        {
            return new Allocation
            {
                AllocationNumber = deliveryAllocation.contractAllocationNumber,
                ContractNumber = deliveryAllocation.contractReference.contractNumber,
                ContractVersionNumber = deliveryAllocation.contractReference.contractVersionNumber,
                VersionNumber = deliveryAllocation.contractReference.contractVersionNumber,
                FundingStreamPeriodCode = deliveryAllocation.fundingStreamPeriod.fundingStreamPeriodCode,
                AllocationDeliverables = GetFlattenedDeliverables(deliveryAllocation.contractDeliverables).ToList(),
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = deliveryAllocation.contractorReference.organisationIdentifier,
                    OrganisationIdentifiers = new List<OrganisationIdentifier>
                    {
                        new OrganisationIdentifier
                        {
                            OrganisationId = GetUkprn(deliveryAllocation.contractorReference.alternativeOrganisationIdentifiers),
                            OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }
                    }
                }
            };
        }

        private static string GetUkprn(List<alternativeOrganisationIdentifierType> organisationIdentifiers)
        {
            return organisationIdentifiers
                .First(id => id.OrganisationIdentifierName == alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER)
                .OrganisationIdentifier;
        }

        private static IEnumerable<AllocationDeliverable> GetFlattenedDeliverables(IEnumerable<contractDeliverableType> deliveryDeliverables)
        {
            List<AllocationDeliverable> allocationDeliverables = new List<AllocationDeliverable>();

            deliveryDeliverables.ToList().ForEach(dd =>
            {
                allocationDeliverables.Add(new AllocationDeliverable
                {
                    DeliverableCode = dd.deliverable.deliverableCode,
                    ScheduledPayments = dd.contractDeliverablePeriods.Select(DeliveryContractDeliverablePeriodToScheduledPayment).ToList()
                });

                allocationDeliverables.AddRange(GetFlattenedDeliverables(dd.contractDeliverables));
            });

            return allocationDeliverables;
        }

        private static ScheduledPayment DeliveryContractDeliverablePeriodToScheduledPayment(contractDeliverablePeriodsTypeContractDeliverablePeriod deliveryContractDeliverablePeriod)
        {
            return new ScheduledPayment
            {
                PlannedValue = deliveryContractDeliverablePeriod.plannedValue,
                PlannedVolume = deliveryContractDeliverablePeriod.plannedVolume,
                Period = deliveryContractDeliverablePeriod.period.periodValue,
                PeriodTypeCode = deliveryContractDeliverablePeriod.period.periodType1.periodTypeCode.ToString()
            };
        }
    }
}
