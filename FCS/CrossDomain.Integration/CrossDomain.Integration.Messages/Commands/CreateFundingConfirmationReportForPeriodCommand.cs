namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class CreateFundingConfirmationReportForPeriodCommand
    {
        public CreateFundingConfirmationReportForPeriodCommand(int period, string type)
        {
            Period = period;
            Type = type;
        }

        public int Period { get; }

        public string Type { get; }

        public override string ToString() => $"Period: {Period}";
    }
}
