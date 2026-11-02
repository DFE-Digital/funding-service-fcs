namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public static class CalculationAllocationInputExtensions
    {
        public static Allocation ToPaymentSchedule(this CalculationAllocationInput calculationAllocationInput)
        {
            const string calenderMonthPeriodType = "CM";

            return new Allocation
            {
                ContractNumber = calculationAllocationInput.ContractNumber,
                FundingStreamPeriodCode = calculationAllocationInput.FundingStreamPeriodCode,
                ContractVersionNumber = calculationAllocationInput.VersionNumber,
                AllocationNumber = calculationAllocationInput.AllocationNumber,
                VersionNumber = calculationAllocationInput.VersionNumber,
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = calculationAllocationInput.OrgId,
                    OrganisationIdentifiers = new List<OrganisationIdentifier> {
                        new OrganisationIdentifier
                        {
                            OrganisationId = calculationAllocationInput.Ukprn,
                            OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }}
                },
                AllocationDeliverables = calculationAllocationInput.Deliverables
                    .Select(d => new AllocationDeliverable
                {
                    DeliverableCode = d.DeliverableCode,
                    ScheduledPayments = d.DeliverablePeriods.Select(dp => new ScheduledPayment
                    {
                        Period = dp.Period.ToString(),
                        PlannedValue = dp.PlannedValue,
                        PlannedVolume = dp.PlannedVolume,
                        ProfilePaymentAmount = 0,
                        BalancingPaymentAmount = 0,
                        CappedPaymentAmount = 0,
                        ReconciliationPaymentAmount = 0,
                        PeriodTypeCode = calenderMonthPeriodType
                    }).ToList()
                }).ToList()
            };
        }
    }
}
