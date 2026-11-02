namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Aspose.Pdf;
    using Aspose.Pdf.Text;
    using ContractDocumentMerger;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class PdfMergerTests
    {
        private IPdfMerger _pdfMerger;
        private string _pageBeforeText = "Ts And Cs Page before";
        private string _pageAfterText = "Ts And Cs Page After";
        private string _appendicesText = "Appendices";

        [TestInitialize]
        public void TestInitialise()
        {
            _pdfMerger = new PdfMerger();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenMergeIsCalled_WithOnlyAppendices_MergedDocIsCreated()
        {
            var documentsToMerge = new List<KeyValuePair<int, byte[]>> { new KeyValuePair<int, byte[]>(50, GetResourcePdf("11111_Main-1234_v1_50")) };
            var mergedResult = _pdfMerger.MergeDocumentation(documentsToMerge);

            var document = new Document(new MemoryStream(mergedResult));

            Assert.AreEqual(documentsToMerge.Count, document.Pages.Count);

            TextAbsorber textAbsorber = new TextAbsorber();
            document.Pages[1].Accept(textAbsorber);
            Assert.AreEqual($"{_appendicesText}", textAbsorber.Text.Trim());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_WithOnlyAppendices_AndOneDocumentBefore_DocumentsAreMerged()
        {
            var documentsToMerge = new List<KeyValuePair<int, byte[]>>
            {
                new KeyValuePair<int, byte[]>(49, GetResourcePdf("11111_Main-1234_v1_49")),
                new KeyValuePair<int, byte[]>(50, GetResourcePdf("11111_Main-1234_v1_50")),
            };
            var mergedResult = _pdfMerger.MergeDocumentation(documentsToMerge);

            var document = new Document(new MemoryStream(mergedResult));

            Assert.AreEqual(documentsToMerge.Count, document.Pages.Count);

            TextAbsorber textAbsorber = new TextAbsorber();
            document.Pages[1].Accept(textAbsorber);
            Assert.AreEqual($"{_pageBeforeText} Page 49", textAbsorber.Text.Trim());

            textAbsorber = new TextAbsorber();
            document.Pages[2].Accept(textAbsorber);
            Assert.AreEqual($"{_appendicesText}", textAbsorber.Text.Trim());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_WithOnlyAppendices_AndOneDocumentAfter_DocumentsAreMerged()
        {
            var documentsToMerge = new List<KeyValuePair<int, byte[]>>
            {
                new KeyValuePair<int, byte[]>(50, GetResourcePdf("11111_Main-1234_v1_50")),
                new KeyValuePair<int, byte[]>(51, GetResourcePdf("11111_Main-1234_v1_51"))
            };

            var mergedResult = _pdfMerger.MergeDocumentation(documentsToMerge);

            var document = new Document(new MemoryStream(mergedResult));

            Assert.AreEqual(documentsToMerge.Count, document.Pages.Count);

            TextAbsorber textAbsorber = new TextAbsorber();
            document.Pages[1].Accept(textAbsorber);
            Assert.AreEqual($"{_appendicesText}", textAbsorber.Text.Trim());

            textAbsorber = new TextAbsorber();
            document.Pages[2].Accept(textAbsorber);
            Assert.AreEqual($"{_pageAfterText} Page 51", textAbsorber.Text.Trim());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_WithMultipleDocuments_BeforeAndAfterAppendices_DocumentsAreMerged()
        {
            var documentsToMerge = GetAllTestDocuments();
            var mergedResult = _pdfMerger.MergeDocumentation(documentsToMerge);

            var document = new Document(new MemoryStream(mergedResult));

            Assert.AreEqual(documentsToMerge.Count, document.Pages.Count);

            TextAbsorber textAbsorber = new TextAbsorber();
            //accept the absorber for all the pages
            document.Pages[1].Accept(textAbsorber);
            Assert.AreEqual($"{_pageBeforeText} Page 47", textAbsorber.Text.Trim());

            textAbsorber = new TextAbsorber();
            document.Pages[2].Accept(textAbsorber);
            Assert.AreEqual($"{_pageBeforeText} Page 48", textAbsorber.Text.Trim());

            textAbsorber = new TextAbsorber();
            document.Pages[3].Accept(textAbsorber);
            Assert.AreEqual($"{_pageBeforeText} Page 49", textAbsorber.Text.Trim());

            textAbsorber = new TextAbsorber();
            document.Pages[4].Accept(textAbsorber);
            Assert.AreEqual($"{_appendicesText}", textAbsorber.Text.Trim());

            textAbsorber = new TextAbsorber();
            document.Pages[5].Accept(textAbsorber);
            Assert.AreEqual($"{_pageAfterText} Page 51", textAbsorber.Text.Trim());

            textAbsorber = new TextAbsorber();
            document.Pages[6].Accept(textAbsorber);
            Assert.AreEqual($"{_pageAfterText} Page 52", textAbsorber.Text.Trim());
        }

        private List<KeyValuePair<int, byte[]>> GetAllTestDocuments()
        {
            return new Dictionary<int, byte[]>
            {
                {50, GetResourcePdf("11111_Main-1234_v1_50")},
                {47, GetResourcePdf("11111_Main-1234_v1_47")},
                {48, GetResourcePdf("11111_Main-1234_v1_48")},
                {49, GetResourcePdf("11111_Main-1234_v1_49")},
                {51, GetResourcePdf("11111_Main-1234_v1_51")},
                {52, GetResourcePdf("11111_Main-1234_v1_52")}
            }.OrderBy(x => x.Key).ToList();
        }

        private static byte[] GetResourcePdf(string resourceName)
        {
            return TestResource.AsBytes(
                "SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources",
                $"{resourceName}.pdf");
        }
    }
}
