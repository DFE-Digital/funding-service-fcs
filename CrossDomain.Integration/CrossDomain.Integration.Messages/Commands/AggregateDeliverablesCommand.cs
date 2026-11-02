namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class AggregateDeliverablesCommand
    {
        public string AllocationNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public override string ToString()
        {
            return $"AllocationNumber: {AllocationNumber}, ContractVersionNumber: {ContractVersionNumber}, SubVersionNumber: {SubVersionNumber}, FundingStreamPeriodCode: {FundingStreamPeriodCode}";
        }
    }
}
