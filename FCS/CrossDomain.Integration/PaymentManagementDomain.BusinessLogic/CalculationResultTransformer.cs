namespace SFA.FCT.PaymentManagementDomain.BusinessLogic
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using FundingClaimReconciliation.Dto;
    using ModelOrganisationIdentifier = PaymentSchedule.DataStore.Model.OrganisationIdentifer;

    public static class CalculationResultTransformer
    {
        public static Allocation TransformDeliverablePeriodResultsToPaymentScheduleAllocation(
            IReadOnlyCollection<DeliverablePeriodResult> deliverablePeriodResults,
            string fundingStreamPeriodCode,
            ModelOrganisationIdentifier organisationIdentifier)
        {
            DeliverablePeriodResult firstResult = deliverablePeriodResults.First();

            return new Allocation
            {
                AllocationNumber = firstResult.AllocationNumber,
                ContractNumber = firstResult.ContractNumber,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                ContractVersionNumber = firstResult.ContractVersionNumber,
                VersionNumber = firstResult.ContractVersionNumber,
                Organisation = TransformOrganisation(organisationIdentifier),
                ProvisionIdentifiers = null,
                AllocationDeliverables = deliverablePeriodResults.GroupBy(x => x.DeliverableCode).Select(CreatePaymentScheduleDeliverables).ToList()
            };
        }

        private static Organisation TransformOrganisation(ModelOrganisationIdentifier organisationIdentifier)
        {
            return new Organisation
            {
                MainOrganisationIdentifier = organisationIdentifier.MainOrganisationIdentifier,
                OrganisationIdentifiers = new List<OrganisationIdentifier>
                    {
                        new OrganisationIdentifier
                        {
                            OrganisationId = organisationIdentifier.OrganisationId,
                            OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }
                    }
            };
        }

        private static AllocationDeliverable CreatePaymentScheduleDeliverables(IGrouping<int, DeliverablePeriodResult> deliverablePeriodResultGrouping)
        {
            int deliverableCode = deliverablePeriodResultGrouping.Key;
            List<DeliverablePeriodResult> periodResultsForDeliverable = deliverablePeriodResultGrouping.ToList();

            return new AllocationDeliverable
            {
                DeliverableCode = deliverableCode,
                ScheduledPayments = periodResultsForDeliverable.Select(TransformDeliverablePeriodResultToPayment).ToList()
            };
        }

        private static ScheduledPayment TransformDeliverablePeriodResultToPayment(DeliverablePeriodResult deliverablePeriodResult)
        {
            return new ScheduledPayment
            {
                Period = $"{deliverablePeriodResult.Year}{deliverablePeriodResult.Period:00}",
                BalancingPaymentAmount = deliverablePeriodResult.BalancingPaymentValue,
                CappedPaymentAmount = deliverablePeriodResult.CappingPaymentValue,
                CollectionReturnCode = null,
                ProfilePaymentAmount = deliverablePeriodResult.ProfilePaymentValue,
                NetPaymentAmount = deliverablePeriodResult.NetPaymentValue ?? 0,
                PeriodTypeCode = "CM",
                PlannedValue = deliverablePeriodResult.ProfileValue,
                PlannedVolume = 0,
                ReconciliationPaymentAmount = deliverablePeriodResult.ReconciliationPaymentValue,
                ActualValue = deliverablePeriodResult.ActualValue
            };
        }
    }
}
