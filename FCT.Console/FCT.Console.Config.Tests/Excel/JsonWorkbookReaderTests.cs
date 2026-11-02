namespace FCT.Console.Config.Tests.Excel
{
    using System.Linq;
    using Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class JsonWorkbookReaderTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void JsonWorkbookReader_ShouldGetSheetNames()
        {
            // arrange
            using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.Config.json"))
            {
                JsonWorkbookReader reader = new JsonWorkbookReader(resource.Stream);

                // act
                var sheetNames = reader.SheetNames();

                // assert
                Assert.IsTrue(sheetNames.Count > 0, "we should have some sheet names");
                Assert.IsTrue(sheetNames.Contains("Agency"), "we should have some the Agency sheet name");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void JsonWorkbookReader_ShouldGetSheet()
        {
            // arrange
            using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.Config.json"))
            {
                JsonWorkbookReader reader = new JsonWorkbookReader(resource.Stream);

                // act
                var sheet = reader.WorksheetReader("Agency");

                // assert

            }
        }
    }
}
