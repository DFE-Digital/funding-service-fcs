namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class CheckForJobCompleteCommand
    {
        public int ReadId { get; set; }

        public override string ToString()
        {
            return $"ReadId: {ReadId}";
        }
    }
}