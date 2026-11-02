using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Aspose.Words;
using Aspose.Words.Tables;
using SFA.FCT.DocumentsDomain.Common.Models;
using System.Collections.Generic;

namespace SFA.FCT.DocumentsDomain.Integration.Tests.ResourceLayer
{
    using Common;

    [TestClass]
    public class AsposeWrapperTests
    {
        private IAsposeWrapper _asposeWrapper;
        private const string SimpleDocumentTitle = "A Simple Document Title";
        private const string SimpleDocumentContent = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
            "Nullam suscipit erat ut lectus feugiat, id lobortis tellus porttitor. Donec venenatis convallis lectus, " +
            "ut luctus tortor lacinia ut. Sed nec dolor sapien. Aliquam condimentum elit eu dictum congue. " +
            "Pellentesque ut nisl laoreet, pharetra risus non, posuere odio. Ut ut felis ultrices, rhoncus velit vel, " +
            "vestibulum augue. Maecenas volutpat eu nulla vitae placerat. Ut sed aliquet sapien, ut tincidunt lectus. " +
            "Nunc congue libero eu libero blandit, sed vehicula libero interdum. " + "Morbi at volutpat ipsum. Nam nec " +
            "mauris nulla. Donec accumsan placerat fermentum. Nunc leo felis, malesuada eu nulla non, ultrices pellentesque " +
            "ipsum.";
        private const int SimpleDocumentBaseSize = 8686; // This will need to change if the template document is changed
        private const string DocumentWithOneRegionTableName = "TeamMembers";
        private readonly string[] _documentWithOneRegionTeamMembers = { "Anne Andrews", "Bob Brown", "Claire Caine", "Donald Duffy", "Eric Evans", "Felicity Frederickson" };
        private const int DocumentWithOneRegionBaseSize = 8600;
        private List<DocumentConvertRequestPart> _sourceDocument = new List<DocumentConvertRequestPart>();

        [TestInitialize]
        public void TestInit()
        {
            _asposeWrapper = new AsposeWrapper();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AsposePDF_ConvertSourceDocumentToPDF()
        {
            Arrange();

            var result = _asposeWrapper.ConvertToPdf(_sourceDocument);

            Assert.IsNotNull(result, "PDF Doc not returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMultipleMerge()
        {
            // Arrange
            List<DocumentConvertRequestPart> dcrParts = new List<DocumentConvertRequestPart>();
            DocumentConvertRequestPart dcrPart = new DocumentConvertRequestPart();
            dcrPart.DocPart = new Document();
            dcrPart.SequenceNumber = 1;
            dcrParts.Add(dcrPart);

            dcrPart = new DocumentConvertRequestPart();
            dcrPart.DocPart = new Document();
            dcrPart.SequenceNumber = 2;
            dcrParts.Add(dcrPart);

            // Act
            var result = _asposeWrapper.ConvertToPdf(dcrParts);

            // Assert
            Assert.IsNotNull(result, "PDF Doc not returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestAsposeMergeWithMultipleDocumentsWithSameAllocation()
        {
            // Arrange
            Document appendix2_1 = new Document();
            DocumentBuilder builder = new DocumentBuilder(appendix2_1);
            builder.StartBookmark("NumberOfPages");
            builder.Write("");
            builder.EndBookmark("NumberOfPages");
            
            Document appendix2_2 = new Document();
            builder = new DocumentBuilder(appendix2_2);
            builder.StartBookmark("NumberOfPages");
            builder.Write("");
            builder.EndBookmark("NumberOfPages");

            List<DocumentConvertRequestPart> dcrParts = new List<DocumentConvertRequestPart>()
            {
                new DocumentConvertRequestPart()
                {
                    DocPart = new Document(),
                    SequenceNumber = 1
                },
                new DocumentConvertRequestPart()
                {
                    DocPart = appendix2_1,
                    SequenceNumber = 2,
                    GroupId = "Group1"
                },
                new DocumentConvertRequestPart()
                {
                    DocPart = appendix2_2,
                    SequenceNumber = 3,
                    GroupId = "Group1"
                }
            };

            // Act
            var result = _asposeWrapper.ConvertToPdf(dcrParts);

            // Assert
            Assert.IsNotNull(result, "PDF Doc not returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestAsposeMergeWithMultipleDocumentsWithDifferentAllocation()
        {
            // Arrange
            List<DocumentConvertRequestPart> dcrParts = new List<DocumentConvertRequestPart>()
            {
                new DocumentConvertRequestPart()
                {
                    DocPart = new Document(),
                    SequenceNumber = 1
                },
                new DocumentConvertRequestPart()
                {
                    DocPart = new Document(),
                    SequenceNumber = 2,
                    GroupId = "Group1"
                },
                new DocumentConvertRequestPart()
                {
                    DocPart = new Document(),
                    SequenceNumber = 3,
                    GroupId = "Group2"
                }
            };

            // Act
            var result = _asposeWrapper.ConvertToPdf(dcrParts);

            // Assert
            Assert.IsNotNull(result, "PDF Doc not returned");
        }

        private void Arrange()
        {
            DocumentConvertRequestPart dcrPart = new DocumentConvertRequestPart();
            using (var ms = new MemoryStream(Properties.Resources.Appendix1Mockup))
            {
                dcrPart.DocPart = new Document(ms);
            }
            dcrPart.SequenceNumber = 1;
            _sourceDocument.Add(dcrPart);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AsposePDFWrapper_GenerateSimpleDocument()
        {
            Document templateDocument = new Document(new MemoryStream(Properties.Resources.TemplateWithTable));

            List<KeyValuePair<string, object>> simpleMergeFields = new List<KeyValuePair<string, object>>{
                new KeyValuePair<string, object>("DocumentTitle", SimpleDocumentTitle),
                new KeyValuePair<string, object>("DocumentContent", SimpleDocumentContent)
            };
        
            Document testOut = _asposeWrapper.Generate(templateDocument, simpleMergeFields, null, null);

            Assert.IsNotNull(testOut, "No document returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AsposePDFWrapper_GeneratesADocumentWithOnlyOneRegion()
        {
            Document templateDocument = new Document(new MemoryStream(Properties.Resources.TemplateWithTable));

            MergeDataSource mds = new MergeDataSource(Constants.TemplateMainTableName);
            for (int row = 0; row < _documentWithOneRegionTeamMembers.Length; row++)
            {
                mds.AddRegionMergeField(0, DocumentWithOneRegionTableName, row, "PersonName", _documentWithOneRegionTeamMembers[row]);
            }

            Document testOut = _asposeWrapper.Generate(templateDocument, null, new[]{mds}, null);

            Assert.IsNotNull(testOut, "No document returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AsposePDFWrapper_GeneratesADocument_WithRowsThatCauseIndentationOnly()
        {
            Document templateDocument = new Document(new MemoryStream(Properties.Resources.TemplateWithTable));

            MergeDataSource mds = new MergeDataSource(Constants.TemplateMainTableName);

            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnOne", "Value One");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnOne", "^tValue to indent");
            Document filledDocument = _asposeWrapper.Generate(templateDocument, new List<KeyValuePair<string, object>>(), new []{mds}, null);

            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[0].FirstParagraph.GetText().StartsWith("Value One"), "First row value is incorrect");
            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].FirstParagraph.GetText().StartsWith("    "), "Second row is not indented");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AsposePDFWrapper_GeneratesADocument_WithRowsThatCauseCellMergeOnly()
        {
            Document templateDocument = new Document(new MemoryStream(Properties.Resources.TemplateWithTable));

            MergeDataSource mds = new MergeDataSource(Constants.TemplateMainTableName);

            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnOne", "Value One");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnOne", "^mValue to merge");
            Document filledDocument = _asposeWrapper.Generate(templateDocument, new List<KeyValuePair<string, object>>(), new[] { mds }, null);

            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[0].FirstParagraph.GetText().StartsWith("Value One"), "First row value is incorrect");
            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].FirstParagraph.GetText().StartsWith("Value to merge"), "Marker not removed");
            Assert.AreEqual(CellMerge.First, filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[0].CellFormat.VerticalMerge);
            Assert.AreEqual(CellMerge.Previous, filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].CellFormat.VerticalMerge);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AsposePDFWrapper_GeneratesADocument_WithRowsThatCauseMultipleCellMerges()
        {
            Document templateDocument = new Document(new MemoryStream(Properties.Resources.TemplateWithTable));

            MergeDataSource mds = new MergeDataSource(Constants.TemplateMainTableName);

            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnOne", "Value One");
            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnTwo", "Value Two");
            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnThree", "Value Three");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnOne", "^mFirst Value to merge");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnTwo", "Do not merge");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnThree", "^mSecond Value to merge");
            Document filledDocument = _asposeWrapper.Generate(templateDocument, new List<KeyValuePair<string, object>>(), new[] { mds }, null);

            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[0].FirstParagraph.GetText().StartsWith("Value One"), "First row cell 1 value is incorrect");
            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].FirstParagraph.GetText().StartsWith("First Value to merge"), "Marker not removed");
            Assert.AreEqual(CellMerge.First, filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[0].CellFormat.VerticalMerge);
            Assert.AreEqual(CellMerge.Previous, filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].CellFormat.VerticalMerge);

            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[1].FirstParagraph.GetText().StartsWith("Value Two"), "First row cell 2 value is incorrect");
            Assert.AreNotEqual(CellMerge.First, filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[1].CellFormat.VerticalMerge);
            Assert.AreNotEqual(CellMerge.Previous, filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[1].CellFormat.VerticalMerge);

            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[2].FirstParagraph.GetText().StartsWith("Value Three"), "First row cell 3 value is incorrect");
            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[2].FirstParagraph.GetText().StartsWith("Second Value to merge"), "Marker not removed");
            Assert.AreEqual(CellMerge.First, filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[2].CellFormat.VerticalMerge);
            Assert.AreEqual(CellMerge.Previous, filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[2].CellFormat.VerticalMerge);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AsposePDFWrapper_GeneratesADocumentWithRows_WithIndentationAndCellBorderRemoval()
        {
            Document templateDocument = new Document(new MemoryStream(Properties.Resources.TemplateWithTable));

            MergeDataSource mds = new MergeDataSource(Constants.TemplateMainTableName);
            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnOne", "Value One");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnOne", "^s^tValue One");
            Document filledDocument = _asposeWrapper.Generate(templateDocument, new List<KeyValuePair<string, object>>(), new[] { mds }, null);

            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[0].CellFormat.Borders.Top.IsVisible);
            Assert.IsFalse(filledDocument.Sections[0].Body.Tables[1].Rows[0].Cells[0].CellFormat.Borders.Bottom.IsVisible);
            Assert.IsFalse(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].CellFormat.Borders.Top.IsVisible);
            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].CellFormat.Borders.Bottom.IsVisible);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_DocCreatorGeneratesADocumentWithBoldCells_WhenCalledWithADocGenRequestWithBoldMarker()
        {
            Document templateDocument = new Document(new MemoryStream(Properties.Resources.TemplateWithTable));

            MergeDataSource mds = new MergeDataSource(Constants.TemplateMainTableName);
            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnOne", "Value One");
            mds.AddRegionMergeField(0, "MainTable", 0, "ColumnTwo", "Value Two");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnOne", "^bValue to be made bold¶");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnTwo", "Value Two");
            mds.AddRegionMergeField(0, "MainTable", 1, "ColumnThree", "Need to ^bmake this bold¶ but not this");

            Document filledDocument = _asposeWrapper.Generate(templateDocument, new List<KeyValuePair<string, object>>(), new[] { mds }, null);

            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[0].FirstParagraph.Runs[0].Font.Bold);
            Assert.IsFalse(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[2].FirstParagraph.Runs[0].Font.Bold);
            Assert.IsTrue(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[2].FirstParagraph.Runs[1].Font.Bold);
            Assert.IsFalse(filledDocument.Sections[0].Body.Tables[1].Rows[1].Cells[2].FirstParagraph.Runs[2].Font.Bold);
        }
    }
}
