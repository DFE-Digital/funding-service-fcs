namespace SFA.FCT.CrossDomain.Integration.Common.Slack
{
    public class SlackMessage
    {
        public SlackMessage(string text)
        {
            this.text = text;
        }

        public string text { get; }

        public bool as_user => true;
    }
}