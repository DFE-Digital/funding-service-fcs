namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentCreator
{
    using Aspose.Words;
    using Common.Models;

    public interface IDocumentCreator
    {
        Document CreateDocument(DocumentGenerationRequest createRequest);
    }
}
