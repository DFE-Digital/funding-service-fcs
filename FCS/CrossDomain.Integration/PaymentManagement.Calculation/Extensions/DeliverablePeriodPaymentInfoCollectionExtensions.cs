namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public static class DeliverablePeriodPaymentInfoCollectionExtensions
    {
        public static Allocation ToPaymentSchedule(
            this IReadOnlyCollection<DeliverablePeriodPaymentInfo> deliverablePeriodPaymentInfos,
            allocationType allocation)
        {
            const string calenderMonthPeriodType = "CM";

            return new Allocation
            {
                ContractNumber = allocation.contractReference.contractNumber,
                FundingStreamPeriodCode = allocation.fundingStreamPeriod.fundingStreamPeriodCode,
                ContractVersionNumber = allocation.contractReference.contractVersionNumber,
                AllocationNumber = allocation.contractAllocationNumber,
                VersionNumber = allocation.contractReference.contractVersionNumber,
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = allocation.contractorReference.organisationIdentifier,
                    OrganisationIdentifiers = new List<OrganisationIdentifier> {
                        new OrganisationIdentifier
                        {
                            OrganisationId = allocation.contractorReference.GetUkprn().ToString(),
                            OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }}
                },
                AllocationDeliverables = deliverablePeriodPaymentInfos.GroupBy(dpi => dpi.DeliverableCode)
                    .Select(deliverableGrp => new AllocationDeliverable
                    {
                        DeliverableCode = deliverableGrp.Key,
                        ScheduledPayments = deliverableGrp.Select(dp => new ScheduledPayment
                        {
                            Period = dp.Period.ToString(),
                            PlannedValue = dp.PlannedValue,
                            PlannedVolume = dp.PlannedVolume,
                            ProfilePaymentAmount = dp.ProfilePaymentAmount,
                            BalancingPaymentAmount = dp.BalancingPaymentAmount,
                            CappedPaymentAmount = dp.CappedPaymentAmount,
                            ReconciliationPaymentAmount = dp.ReconciliationPaymentAmount,
                            NetPaymentAmount = dp.NetPaymentAmount,
                            ActualValue = dp.ActualValue,
                            ActualVolume = dp.ActualVolume,
                            PeriodTypeCode = calenderMonthPeriodType
                        }).ToList()
                    }).ToList()
            };
        }
    }
}
