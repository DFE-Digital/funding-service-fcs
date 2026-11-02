namespace SFA.FCT.DocumentsDomain.DocumentGeneration.ContractDocumentMerger
{
    using System.Collections.Generic;

    public interface IPdfMerger
    {
        byte[] MergeDocumentation(List<KeyValuePair<int, byte[]>> documentsToMerge);
    }
}
