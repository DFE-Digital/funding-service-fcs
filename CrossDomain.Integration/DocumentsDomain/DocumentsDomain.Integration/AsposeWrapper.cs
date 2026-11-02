namespace SFA.FCT.DocumentsDomain.Integration
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text.RegularExpressions;
    using Aspose.Words;
    using Aspose.Words.MailMerging;
    using Aspose.Words.Tables;
    using Common;
    using Common.Models;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using CrossDomain.Integration.Common;

    public class AsposeWrapper : IAsposeWrapper
    {
        private const string FourSpaces = "    ";

        public AsposeWrapper()
        {
            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License license = new License();
                license.SetLicense(licenseStream);
            }

            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public Document Generate(Document templateDocument, List<KeyValuePair<string, object>> simpleMergeFields, MergeDataSource[] repeatingSections, Action<Row> indentMarkersOverride)
        {
            templateDocument.MailMerge.CleanupOptions = MailMergeCleanupOptions.RemoveUnusedFields;

            if (simpleMergeFields != null)
            {
                templateDocument.MailMerge.Execute(simpleMergeFields.Select(md => md.Key).ToArray(), simpleMergeFields.Select(md => md.Value).ToArray());
            }

            repeatingSections?.ToList().ForEach(templateDocument.MailMerge.ExecuteWithRegions);

            CleanUpDocument(ref templateDocument, indentMarkersOverride);
            return templateDocument;
        }

        public byte[] ConvertToPdf(List<DocumentConvertRequestPart> sourceDocuments)
        {
            var singleSourceDocument = AppendDocuments(sourceDocuments);
            byte[] targetPdf;

            if (sourceDocuments.Any(sd => sd.GroupId == Constants.PaymentScheduleGroupId))
            {
                using (var ms = new MemoryStream())
                {
                    singleSourceDocument.Save(ms, SaveFormat.Docx);
                    var intermediateDocument = new Document(ms);

                    using (var ms2 = new MemoryStream())
                    {
                        intermediateDocument.Save(ms2, SaveFormat.Pdf);
                        targetPdf = ms2.ToArray();
                    }
                }
            }
            else
            {
                using (var ms = new MemoryStream())
                {
                    singleSourceDocument.Save(ms, SaveFormat.Pdf);
                    targetPdf = ms.ToArray();
                }
            }

            return targetPdf;
        }

        private Document AppendDocuments(List<DocumentConvertRequestPart> sourceFiles)
        {
            Document completeWordDocument = null;
            string groupId = string.Empty;
            int numberOfPagesFromLastGroup = 0;
            const string numberOfPagesBookmarkName = "NumberOfPages";

            Logger.LogVerbose("AsposeWrapper AppendDocuments found {0} documents to merge", sourceFiles.Count);
            bool isAppendixOnePresent = sourceFiles.Any(p => string.IsNullOrEmpty(p.GroupId));

            foreach (DocumentConvertRequestPart part in sourceFiles)
            {
                Document wordDocument = part.DocPart;
                bool isAppendix2 = !string.IsNullOrEmpty(part.GroupId);

                if (isAppendix2 && (isAppendixOnePresent || completeWordDocument != null))
                {
                    // Need to determine number of pages in all documents in this group
                    var documentsInGroup =
                        sourceFiles.Where(groupPart => groupPart.GroupId == part.GroupId)
                            .Select(groupPart => groupPart.DocPart).ToList();

                    int totalPagesInGroup = documentsInGroup.Sum(documentInGroup => documentInGroup.PageCount);

                    // Replace the documnets bookmarks with the correct number
                    foreach (Document documentInGroup in documentsInGroup)
                    {
                        documentInGroup.AddValueToBookMarkIfPresent(numberOfPagesBookmarkName, totalPagesInGroup.ToString());
                    }

                    if (part.GroupId != groupId)
                    {
                        groupId = part.GroupId;

                        // Group has now changed, need to reset the page number
                        numberOfPagesFromLastGroup = wordDocument.PageCount;
                        
                        wordDocument.FirstSection.PageSetup.PageStartingNumber = 1;
                       
                    }
                    else
                    {
                        // New document in the same group, we need to continue the page numbering from last document.
                        wordDocument.FirstSection.PageSetup.PageStartingNumber = numberOfPagesFromLastGroup + 1;
                        numberOfPagesFromLastGroup += wordDocument.PageCount;
                    }
                }

                if (completeWordDocument == null)
                {
                    if (!isAppendixOnePresent)
                    {
                        int numPagesInGroup = 1;
                        if (sourceFiles.Any(sf => sf.GroupId == "PaymentScheduleGroup"))
                        {
                            // there is a problem with accessing the PageCount for all
                            numPagesInGroup = sourceFiles.Where(groupPart => groupPart.GroupId == part.GroupId)
                                .Select(groupPart => groupPart.DocPart)
                                .Sum(documentInGroup => documentInGroup.PageCount);

                            numberOfPagesFromLastGroup = wordDocument.PageCount;
                        }
                       
                        wordDocument.AddValueToBookMarkIfPresent(bookmarkName: numberOfPagesBookmarkName,
                            bookmarkValue: numPagesInGroup.ToString());

                        wordDocument.FirstSection.PageSetup.PageStartingNumber = 1;

                        groupId = part.GroupId;
                    }
                    completeWordDocument = wordDocument;
                }
                else
                {
                    wordDocument.FirstSection.HeadersFooters.LinkToPrevious(false);
                    if (part.IsNewPageRequired)
                    {
                        wordDocument.FirstSection.PageSetup.SectionStart = SectionStart.NewPage;
                    }
                    else
                    {
                        wordDocument.FirstSection.PageSetup.SectionStart = SectionStart.Continuous;
                    }
                    completeWordDocument.AppendDocument(wordDocument, ImportFormatMode.KeepSourceFormatting);
                }
            }

            return completeWordDocument;
        }

        private void CleanUpDocument(ref Document doc, Action<Row> indentMarkersOverride)
        {
            // this assumes the main table is the second one
            Table table = (Table)doc.GetChild(NodeType.Table, 1, true);

            // not every document has a table.
            if (table != null)
            {
                CleanupLinestyles(table);
                CleanupMergeMarkers(table);
                CleanupIndentMarkers(table, indentMarkersOverride);
                CleanupBoldTextMarker(doc);
                CleanupItalicTextMarker(doc);
                CleanupPoundSignMarker(doc);
            }
        }

        private static void CleanupLinestyles(Table table)
        {
            Row[] deliverableRows = (from r in table.Rows.ToArray()
                                     where r.FirstCell.GetText().Contains(Constants.SubRowMarker)
                                     select r).ToArray();

            foreach (Row deliverableRow in deliverableRows)
            {
                deliverableRow.FirstCell.Range.Replace(Constants.SubRowMarker, string.Empty, true, false);
                foreach (Cell cell in deliverableRow)
                {
                    cell.CellFormat.Borders.Top.LineStyle = LineStyle.None;
                    cell.CellFormat.Borders.Top.LineWidth = 0;
                }

                Row previousRow = (Row)deliverableRow.PreviousSibling;
                if (previousRow != null)
                {
                    foreach (Cell cell in previousRow.Cells)
                    {
                        cell.CellFormat.Borders.Bottom.LineStyle = LineStyle.None;
                        cell.CellFormat.Borders.Bottom.LineWidth = 0;
                    }
                }
            }
        }

        private static void CleanupItalicTextMarker(Document doc)
        {
            doc.Range.Replace(
                new Regex(@"\" + Constants.ItalicTextMarker + "([^" + Constants.EndOfTextMarker + "]*)" + Constants.EndOfTextMarker, RegexOptions.IgnoreCase),
                new ReplaceEvaluatorFindAndExecute(run =>
                {
                    run.Font.Italic = true;
                }),
                false);
        }

        private void CleanupPoundSignMarker(Document doc)
        {
            doc.Range.Replace(
                new Regex(@"\" + Constants.RemovePoundSignMarker + "([^" + Constants.EndOfTextMarker + "]*)" + Constants.EndOfTextMarker, RegexOptions.IgnoreCase),
                new ReplaceEvaluatorFindAndExecute(run =>
                {
                    run.Font.Italic = false;
                }),      
                false);
        }

        private static void CleanupBoldTextMarker(Document doc)
        {
            doc.Range.Replace(
                new Regex(@"\" + Constants.BoldTextMarker + "([^" + Constants.EndOfTextMarker + "]*)" + Constants.EndOfTextMarker, RegexOptions.IgnoreCase),
                new ReplaceEvaluatorFindAndExecute(run =>
                {
                    run.Font.Bold = true;
                }),
                false);
        }

        private static void CleanupIndentMarkers(Table table, Action<Row> indentMarkersOverride)
        {
            void DefaultIndentMarkers(Row row) => row.FirstCell.Range.Replace(Constants.IndentTextMarker, FourSpaces, true, false);

            table
                .Rows
                .ToArray()
                .Where(r => r.FirstCell.GetText().Contains(Constants.IndentTextMarker))
                .ToList()
                .ForEach(indentMarkersOverride ?? DefaultIndentMarkers);
        }

        private static void CleanupMergeMarkers(Table table)
        {
            Row[] deliverableRows = (from r in table.Rows.ToArray()
                                     where r.FirstCell.GetText().Contains(Constants.MergeThisAndCellAboveMarker)
                                     select r).ToArray();
            foreach (Row deliverableRow in deliverableRows)
            {
                int pos = 0;
                foreach (var cell in deliverableRow.Cells.Cast<Cell>())
                {
                    if (cell.GetText().Contains(Constants.MergeThisAndCellAboveMarker))
                    {
                        VerticallyMergeCellAtPosition(cell, pos);
                    }

                    pos++;
                }
            }
        }

        private static void VerticallyMergeCellAtPosition(Cell cell, int pos)
        {
            cell.Range.Replace(Constants.MergeThisAndCellAboveMarker, string.Empty, true, false);
            cell.CellFormat.VerticalMerge = CellMerge.Previous;
            ((Row)cell.ParentRow.PreviousSibling).Cells[pos].CellFormat.VerticalMerge = CellMerge.First;
        }

        private class ReplaceEvaluatorFindAndExecute : IReplacingCallback
        {
            private readonly Action<Run> _actionToCall = null;
 
            public ReplaceEvaluatorFindAndExecute(Action<Run> functionToCall)
            {
                _actionToCall = functionToCall;
            }

            ReplaceAction IReplacingCallback.Replacing(ReplacingArgs e)
            {
                Node currentNode = e.MatchNode;

                if (e.MatchOffset > 0)
                {
                    currentNode = SplitRun((Run)currentNode, e.MatchOffset);
                }

                List<Run> runs = new List<Run>();

                int remainingLength = e.Match.Value.Length;

                while (
                    (remainingLength > 0) &&
                    (currentNode != null) &&
                    (currentNode.GetText().Length <= remainingLength))
                {
                    runs.Add((Run)currentNode);
                    remainingLength = remainingLength - currentNode.GetText().Length;

                    do
                    {
                        currentNode = currentNode.NextSibling;
                    } 
                    while ((currentNode != null) && (currentNode.NodeType != NodeType.Run));
                }

                if ((currentNode != null) && (remainingLength > 0))
                {
                    SplitRun((Run)currentNode, remainingLength);
                    runs.Add((Run)currentNode);
                }

                runs.First().Text = runs.First().Text.Substring(2);
                runs.Last().Text = runs.Last().Text.Substring(0, runs.Last().Text.Length - 1);

                foreach (Run run in runs)
                {
                    _actionToCall(run);
                }

                return ReplaceAction.Skip;
            }

            private static Run SplitRun(Run run, int position)
            {
                Run afterRun = (Run)run.Clone(true);
                afterRun.Text = run.Text.Substring(position);
                run.Text = run.Text.Substring(0, position);
                run.ParentNode.InsertAfter(afterRun, run);
                return afterRun;
            }
        }
    }

    internal static class DocumentExtensions
    {
        public static void AddValueToBookMarkIfPresent(this Document document, string bookmarkName, string bookmarkValue)
        {
            var bookMark = document.Range.Bookmarks[bookmarkName];
            if (bookMark != null)
            {
                bookMark.Text = bookmarkValue;
            }
        }
    }
}
