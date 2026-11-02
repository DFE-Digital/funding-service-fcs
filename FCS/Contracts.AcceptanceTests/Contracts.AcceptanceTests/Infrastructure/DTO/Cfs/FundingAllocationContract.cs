namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
{
    public class FundingAllocationContract
    {
        public string FundingId { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public bool IsCreatedInCrm { get; set; }
    }
}
