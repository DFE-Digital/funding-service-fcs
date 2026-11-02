namespace FeedReader
{
    using CommandLine;

    public class Options
    {
        [Option('e', "Environment", Required = false, HelpText = "Which environment do you want to point to.")]
        public Environment Environment { get; set; }
    }
}
