namespace Operations.Worker.Slack
{
    public class SlackMessage
    {
        public SlackMessage(string text)
        {
            this.text = $"FCS.Operations {text}";
        }

        public string text { get; }

        public bool as_user => true;
    }
}