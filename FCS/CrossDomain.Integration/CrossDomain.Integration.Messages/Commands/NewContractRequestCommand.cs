namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class NewContractRequestCommand : CreateContractRequestCommand
    {
        public bool ShouldReply { get; set; }

        public long? DasEngagementEventId { get; set; }
    }
}
