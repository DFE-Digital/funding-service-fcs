namespace SFA.FCT.DocumentsDomain.Integration
{
    using System;
    using System.Collections.Generic;
    using Aspose.Words;
    using Aspose.Words.Tables;
    using Common.Models;

    public interface IAsposeWrapper
    {
        Document Generate(Document templateDocument, List<KeyValuePair<string, object>> simpleMergeFields, MergeDataSource[] repeatingSections, Action<Row> indentMarkersOverride);

        byte[] ConvertToPdf(List<DocumentConvertRequestPart> sourceDocuments);
    }
}
