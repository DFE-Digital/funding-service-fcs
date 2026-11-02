namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentSaver
{
    using Common.Models;
    using Common.Commands;

    public interface IDocumentSaver
    {
        void SaveDocument(DocumentSaveCommand message);
    }
}
