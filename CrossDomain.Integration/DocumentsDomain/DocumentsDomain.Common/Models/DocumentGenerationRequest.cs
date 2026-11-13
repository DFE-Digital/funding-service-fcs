namespace SFA.FCT.DocumentsDomain.Common.Models
{
    using Aspose.Words;
    using Aspose.Words.Replacing;
    using Aspose.Words.Tables;
    using System;

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
            var options = new FindReplaceOptions
            {
                MatchCase = true,           // was your 3rd param
                FindWholeWordsOnly = false  // was your 4th param
            };

            row.FirstCell.Range.Replace(Constants.IndentTextMarker, string.Empty /* FourSpaces */, options);
            row.FirstCell.CellFormat.LeftPadding = 12;
        }

    }
}