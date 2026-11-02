namespace ActualsPull.Slack
{
    public class ErrorMessge
    {
        public ErrorMessge(string text)
        {
            this.text = text;
        }

        public string text { get; }

        public bool as_user => true;
    }
}
