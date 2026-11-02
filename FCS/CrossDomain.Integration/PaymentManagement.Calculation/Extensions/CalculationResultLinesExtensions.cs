namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public static class CalculationResultLinesExtensions
    {
        public static Allocation ToPaymentSchedule(
            this IEnumerable<CalculationResultLine> lines, CalculationAllocationInput allocation)
        {
            return new Allocation
            {
                ContractNumber = allocation.ContractNumber,
                FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                ContractVersionNumber = allocation.VersionNumber,
                AllocationNumber = allocation.AllocationNumber,
                VersionNumber = allocation.VersionNumber,
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = allocation.OrgId,
                    OrganisationIdentifiers = new List<OrganisationIdentifier> { 
                        new OrganisationIdentifier
                        {
                            OrganisationId = allocation.Ukprn,
                            OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }}
                },
                AllocationDeliverables = lines.GroupBy(l => l.DeliverableCode).Select(deliverableLineGroup => new AllocationDeliverable
                {
                    DeliverableCode = deliverableLineGroup.Key,
                    ScheduledPayments = deliverableLineGroup.Select(g => new ScheduledPayment
                    {
                        Period = g.Period.ToString(),
                        PeriodTypeCode = "CM",
                        ReconciliationPaymentAmount = g.ReconciliationPaymentAmount,
                        CappedPaymentAmount = g.CappedPaymentAmount,
                        BalancingPaymentAmount = g.BalancingPaymentAmount,
                        ProfilePaymentAmount = g.ProfileValue,
                        NetPaymentAmount = g.NetPaymentAmount,
                    }).ToList()
                }).ToList()
            };
        }

        public static IReadOnlyCollection<CalculationResultLine> StaggerPaymentsIfNecessary(
            this IReadOnlyCollection<CalculationResultLine> calculationResultLines, bool shouldStaggerPayments, Period currentPeriod)
        {
            if (shouldStaggerPayments)
            {
                var linesWithStaggeredPayments = new List<CalculationResultLine>(calculationResultLines);
                bool anyPaymentsStaggered = false;
                calculationResultLines.GroupBy(l => l.DeliverableCode).ToList().ForEach(deliverableGroup =>
                {
                    var orderedPeriodsBeginningAtCurrentPeriod = deliverableGroup
                        .Where(l => l.Period >= currentPeriod)
                        .OrderBy(l => l.Period)
                        .ToList();

                    if (orderedPeriodsBeginningAtCurrentPeriod.Any())
                    {
                        var currentPeriodLine = orderedPeriodsBeginningAtCurrentPeriod.First();
                        if (currentPeriodLine.ReconciliationPaymentAmount != null && currentPeriodLine.ReconciliationPaymentAmount.IsNegative())
                        {
                            anyPaymentsStaggered = true;
                            var initialValue = currentPeriodLine.ReconciliationPaymentAmount.Value;
                            var quarterValue = (initialValue / 4).RoundPoundsDownToNearestPenny();
                            int deliverableCode = deliverableGroup.Key;
                            linesWithStaggeredPayments.GetOrAdd(currentPeriod, deliverableCode).SetReconciliationPayment(quarterValue);
                            linesWithStaggeredPayments.GetOrAdd(currentPeriod.AddMonths(1), deliverableCode).SetReconciliationPayment(quarterValue);
                            linesWithStaggeredPayments.GetOrAdd(currentPeriod.AddMonths(2), deliverableCode).SetReconciliationPayment(quarterValue);
                            linesWithStaggeredPayments.GetOrAdd(currentPeriod.AddMonths(3), deliverableCode).SetReconciliationPayment(initialValue - 3 * quarterValue);
                        }
                    }
                });

                if (anyPaymentsStaggered)
                {
                    linesWithStaggeredPayments.PopulateMissingPeriods();
                }

                return linesWithStaggeredPayments;
            }

            return calculationResultLines;
        }

        public static void PopulateMissingPeriods(
            this IList<CalculationResultLine> calculationResultLines)
        {
            var distinctPeriods = calculationResultLines.Select(l => l.Period)
                .Distinct()
                .ToList();

            calculationResultLines.GroupBy(l => l.DeliverableCode).ToList().ForEach(deliverableGroup =>
            {
                distinctPeriods.ForEach(p =>
                {
                    if (deliverableGroup.Select(l => l.Period).None(p))
                    {
                        calculationResultLines.Add(new CalculationResultLine(p, deliverableGroup.Key, 0, 0, 0, 0, 0));
                    }
                });
            });
        }

        private static CalculationResultLine GetOrAdd(this List<CalculationResultLine> lines, int period, int deliverableCode)
        {
            var lineForPeriod = lines.FirstOrDefault(l => l.Period == period && l.DeliverableCode == deliverableCode);
            if (lineForPeriod == null)
            {
                lineForPeriod = new CalculationResultLine(period, deliverableCode, 0, 0, 0, 0, 0);
                lines.Add(lineForPeriod);
            }

            return lineForPeriod;
        }
    }
}
