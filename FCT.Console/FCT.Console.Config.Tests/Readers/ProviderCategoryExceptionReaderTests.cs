namespace FCT.Console.Config.Tests.Readers
{
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class ProviderCategoryExceptionReaderTests : TestBase
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderCategoryExceptionReader_ShouldReadInAllRows()
        {
            // arrange
            var workbookReader = GetWorkbookReader();
            var worksheetReader = workbookReader.WorksheetReader("Provider Category Exceptions");
            var reader = new ProviderCategoryExceptionReader();

            // act
            var providerCategoryExceptions = reader.ReadConfig(worksheetReader);

            // assert
            providerCategoryExceptions.Should().HaveCount(236);
        }
    }
}
