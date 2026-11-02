namespace FCT.Console.Config.Infrastructure
{
    public class SequenceNameInfo
    {
        public SequenceNameInfo(string sequenceName, string context)
        {
            SequenceName = sequenceName;
            Context = context;
        }

        public string SequenceName { get; }

        public string Context { get; }
    }
}
