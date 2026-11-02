namespace FundingAllocation.Slack
{
    using System.Threading.Tasks;
    using NServiceBus.Faults;
    using SFA.FCT.Framework.Logging.Interfaces;

    public interface ISlackMessageSender
    {
        Task SendMessage(FailedMessage failed, ILogger logger, SlackChannel slackChannel);

        Task SendMessage(string message, ILogger logger, SlackChannel slackChannel);
    }
}