namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    public class FctFile
    {
        public FctFile()
        {
            // need this for generated code
        }

        public FctFile(string fileContainer, string filename)
        {
            FileContainer = fileContainer;
            Filename = filename;
        }

        public string FileContainer { get; set; }

        public string Filename { get; set; }
    }
}
