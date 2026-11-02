namespace FCT.Console.Config.Tests.Excel
{
    using System.Linq;
    using Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class JsonWorksheetReaderTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void JsonWorkSheetReader_ShouldGetAllFspSheetRows()
        {
            // arrange
            using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.Config.json"))
            {
                var jsonWorkbookReader = new JsonWorkbookReader(resource.Stream);

                var jsonWorkSheetReader = jsonWorkbookReader.WorksheetReader("Funding Stream Period");

                // act
                var rows = jsonWorkSheetReader.DataRows().ToList();

                // assert
                Assert.AreEqual(249, rows.Count, "incorrect number of rows returned");
            }
        }
    }
}