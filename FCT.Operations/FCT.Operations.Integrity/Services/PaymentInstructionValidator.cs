namespace SFA.FCT.Operations.Integrity.Services
{
    using System.Linq;
    using AllocationDeliveryDomain.Common.Storage;
    using CrossDomain.Integration.Common;
    using Extensions;

    /// <remarks>
    /// Local replica of NSB7 AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services.PaymentInstructionValidator
    /// </remarks>
    public class PaymentInstructionValidator
    {
        private readonly IDate _dateProvider;

        public PaymentInstructionValidator(IDate dateProvider)
        {
            _dateProvider = dateProvider;
        }

        public void Validate(EnrichedReportedActual paymentInstruction)
        {
            if (paymentInstruction.ContractAllocationNumber == null)
            {
                paymentInstruction.ValidationErrors.Add("No contract allocation number found");
            }

            if (paymentInstruction.EnrichedDeliverableCode == null)
            {
                paymentInstruction.ValidationErrors.Add("No deliverable code found");
            }

            if (IsPeriodPriorToAllocationStart(paymentInstruction))
            {
                paymentInstruction.ValidationErrors.Add("Period is prior to allocation start date");
            }

            if (IsPeriodNotPreviousCalendarMonth(paymentInstruction))
            {
                paymentInstruction.ValidationErrors.Add("Period is not previous calendar month");
            }

            paymentInstruction.IsValid = !paymentInstruction.ValidationErrors.Any();
        }

        private static bool IsPeriodPriorToAllocationStart(EnrichedReportedActual paymentInstruction)
        {
            return int.Parse(paymentInstruction.Period) < int.Parse(paymentInstruction.AllocationStartDate.ToString("yyyyMM"));
        }

        private bool IsPeriodNotPreviousCalendarMonth(EnrichedReportedActual paymentInstruction)
        {
            string currentPeriod = _dateProvider.GetCurrentPeriod(_dateProvider.GetCalculationDate());

            return int.Parse(paymentInstruction.Period) != int.Parse(currentPeriod);
        }
    }
}
