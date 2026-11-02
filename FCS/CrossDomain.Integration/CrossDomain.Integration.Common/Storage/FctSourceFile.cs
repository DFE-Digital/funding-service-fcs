namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    public class FctSourceFile
    {
        public FctSourceFile()
        {
        }

        public FctSourceFile(int sequenceNumber, string fileContainer, string filename)
        {
            SequenceNumber = sequenceNumber;
            FileContainer = fileContainer;
            Filename = filename;
        }

        public int SequenceNumber { get; set; }

        public string FileContainer { get; set; }

        public string Filename { get; set; }
    }
}
