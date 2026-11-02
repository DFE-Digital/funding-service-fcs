namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class SummaryInstructionLine
    {
        public string PaymentFileName { get; set; }

        public string ErrorFileName { get; set; }

        public string NumberOfPayments { get; set; }

        public string ValueOfPayments { get; set; }

        public string NumberOfErrorPayments { get; set; }

        public string ValueOfErrorPayments { get; set; }
    }
}
