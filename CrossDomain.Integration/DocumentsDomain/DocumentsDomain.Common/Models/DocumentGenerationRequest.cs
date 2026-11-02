namespace SFA.FCT.DocumentsDomain.Common.Models
{
    using System;
    using Aspose.Words;
    using Aspose.Words.Tables;

    public partial class DocumentGenerationRequest
    {
        [System.Xml.Serialization.XmlIgnore]
        public Action<Document> MutateGeneratedDocument { get; set; }

        [System.Xml.Serialization.XmlIgnore]
        public bool IsNewPageRequired { get; set; } = true;

        [System.Xml.Serialization.XmlIgnore]
        public string FspGroupCode { get; set; }

        [System.Xml.Serialization.XmlIgnore]
        public Action<Row> IndentMarkersOverride { get; set; }

        public static void CleanupIndentMarkers(Row row)
        {
            row.FirstCell.Range.Replace(Constants.IndentTextMarker, string.Empty /* FourSpaces */, true, false);
            row.FirstCell.CellFormat.LeftPadding = 12;
        }
    }
}