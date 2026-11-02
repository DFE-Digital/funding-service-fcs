namespace PaymentManagement.Calculation.Extensions
{
    using System;
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public static class AllocationPaymentScheduleExtensions
    {
        public static void EnrichWithPlannedValues(this Allocation allocationPaymentSchedule, CalculationAllocationInput allocationInput)
        {
            allocationPaymentSchedule.EnrichWithDelegate(allocationInput, SetPlannedValues);

            void SetPlannedValues(ScheduledPayment scheduledPayment, CalculationDeliverablePeriodInput input)
            {
                scheduledPayment.PlannedValue = input.PlannedValue;
                scheduledPayment.PlannedVolume = input.PlannedVolume;
            }
        }

        public static void EnrichWithActualValues(this Allocation allocationPaymentSchedule, CalculationAllocationInput allocationInput)
        {
            allocationPaymentSchedule.EnrichWithDelegate(allocationInput, SetActualValues);

            void SetActualValues(ScheduledPayment scheduledPayment, CalculationDeliverablePeriodInput input)
            {
                scheduledPayment.ActualValue = input.ActualValue;
                scheduledPayment.ActualVolume = input.ActualVolume;
            }
        }

        private static void EnrichWithDelegate(
            this Allocation allocationPaymentSchedule,
            CalculationAllocationInput allocationInput,
            Action<ScheduledPayment, CalculationDeliverablePeriodInput> setScheduledPaymentProperties)
        {
            var inputDeliverables = allocationInput.Deliverables.ToDictionary(d => d.DeliverableCode);

            allocationPaymentSchedule.AllocationDeliverables.ForEach(psDeliverable =>
            {
                var matchingInputDeliverableOption = inputDeliverables.GetValueOrNone(psDeliverable.DeliverableCode);

                matchingInputDeliverableOption.MatchSome(inputDeliverable =>
                {
                    var inputPeriods = inputDeliverable.DeliverablePeriods.ToDictionary(dp => dp.Period);

                    psDeliverable.ScheduledPayments.ForEach(psPeriod =>
                    {
                        inputPeriods.GetValueOrNone(int.Parse(psPeriod.Period))
                            .Match(some: inputPeriod =>
                            {
                                setScheduledPaymentProperties(psPeriod, inputPeriod);
                            },
                                none: () =>
                                {
                                    if (psPeriod.PlannedValue == null)
                                    {
                                        psPeriod.PlannedValue = 0;
                                    }

                                    if (psPeriod.PlannedVolume == null)
                                    {
                                        psPeriod.PlannedVolume = 0;
                                    }
                                });
                    });
                });
            });
        }
    }
}
