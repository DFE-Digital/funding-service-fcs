namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentMerger
{
    using Common.Models;

    public interface IDocumentMerger
    {
        byte[] MergeDocuments(DocumentConvertRequest convertRequest);
    }
}