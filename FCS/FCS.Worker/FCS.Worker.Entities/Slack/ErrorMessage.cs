namespace SFA.FCS.Worker.Common.Slack
{
    public class ErrorMessage
    {
        public ErrorMessage(string service, string text)
        {
            this.text = $"{service} {text}";
        }

        public string text { get; }

        public bool as_user => true;
    }
}
