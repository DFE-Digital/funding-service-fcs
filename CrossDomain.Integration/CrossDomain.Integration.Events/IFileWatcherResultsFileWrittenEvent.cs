namespace SFA.FCT.CrossDomain.Integration.Events
{
    public interface IFileWatcherResultsFileWrittenEvent
    {
        string InputFileName { get; set; }

        string ResultsFileName { get; set; }

        string BatchId { get; set; }
    }
}
