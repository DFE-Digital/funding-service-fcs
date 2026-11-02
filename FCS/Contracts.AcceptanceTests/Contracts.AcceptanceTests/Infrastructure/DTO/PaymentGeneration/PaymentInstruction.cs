namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.PaymentGeneration
{
    using System.Collections.Generic;

    public class PaymentInstruction
    {
        public List<InstructionLine> Lines { get; set; }
    }
}
