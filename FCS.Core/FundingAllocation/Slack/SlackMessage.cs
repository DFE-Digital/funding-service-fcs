namespace FundingAllocation.Slack
{
    public class SlackMessage
    {
        public SlackMessage(string text)
        {
            this.text = $"FCS.Core {text}";
        }

        public string text { get; }

        public bool as_user => true;
    }
}
