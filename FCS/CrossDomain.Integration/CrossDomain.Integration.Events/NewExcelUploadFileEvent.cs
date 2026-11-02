namespace SFA.FCT.CrossDomain.Integration.Events
{
    public interface INewExcelUploadFileEvent
    {
        string UploadedFilename { get; set; }

        string BatchId { get; set; }
    }
}
