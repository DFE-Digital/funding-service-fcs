namespace FCT.Console.Config.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class WorkbookReaderTests : TestBase
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void WorkbookReader_ShouldGetTheSheetNames()
        {
            // arrange
            WorkbookReader reader = GetWorkbookReader();
            const string sheetNameToFind = "Subnominal Payment Types";
            // act
            IReadOnlyCollection<string> sheetNames = reader.SheetNames().ToList();

            // assert
            Assert.IsTrue(sheetNames.Any(), "There are no sheet names");
            Assert.IsTrue(sheetNames.Contains(sheetNameToFind), $"The is no sheet name called {sheetNameToFind}");
        }
    }
}
