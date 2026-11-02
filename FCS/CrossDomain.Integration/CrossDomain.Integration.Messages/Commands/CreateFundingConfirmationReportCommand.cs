namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class CreateFundingConfirmationReportCommand
    {
        public CreateFundingConfirmationReportCommand(string type)
        {
            Type = type;
        }
        public string Type { get; }

    }
}
