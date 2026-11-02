namespace Operations.Worker.Slack
{
    using System.Threading.Tasks;
    using NServiceBus.Faults;
    using SFA.FCT.Framework.Logging.Interfaces;

    public interface ISlackMessageSender
    {
        Task SendMessage(FailedMessage failed, ILogger logger);

        Task SendMessage(string message, ILogger logger);
    }
}