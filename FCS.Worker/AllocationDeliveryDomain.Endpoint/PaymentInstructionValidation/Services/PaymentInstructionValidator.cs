namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using System.Linq;
    using Infrastructure.Extensions;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;

    public class PaymentInstructionValidator : IPaymentInstructionValidator
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