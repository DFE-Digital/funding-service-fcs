namespace SFA.FCT.DocumentsDomain.Common.Models
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

        public override int GetHashCode()
        {
            return (FileContainer + Filename).GetHashCode();
        }
    }
}
