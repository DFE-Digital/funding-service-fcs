namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class JobCompletedCommand
    {
        public JobCompletedCommand(int readId)
        {
            ReadId = readId;
        }

        public int ReadId { get; }

        public override string ToString() => $"ReadId: {ReadId}";
    }
}
