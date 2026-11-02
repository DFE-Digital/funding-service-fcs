namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class CheckForReadCompleteCommand
    {
        public string FundingAllocationId { get; set; }

        public override string ToString()
        {
            return $"FundingAllocationId: {FundingAllocationId}";
        }
    }
}
