namespace FCT.Console.Config.Tests.Json
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FCT.Console.Config.Json;
    using UnitTests.Common;
    using Config.Excel;
    using System.IO;

    [TestClass]
    public class WorkbookToJsonTests
    {
        private WorkbookReader _reader;

        [TestMethod, TestCategory("ProduceJson")]
        public void WorkbookToJson_Transform_ShouldProduceJson()
        {
            // arrange
            _reader = GetWorkbookReader();

            var workbookToJson = new WorkbookToJson(_reader);

            // act
            var jsonOutput = workbookToJson.Transform();

            // assert
            Assert.IsNotNull(jsonOutput, "Json was not produced");
            Assert.IsTrue(jsonOutput.Length > 0, "Json does not have content");

            WriteToFile(jsonOutput, @"FCT.Console.Config\Resources\");
            WriteToFile(jsonOutput, @"FCT.Console.Config.Tests\Resources\");
            WriteFileToContractsAcceptanceTests(jsonOutput);

            Assert.IsTrue(jsonOutput.Contains("\"Version History\": ["), "Json does not include 'Version History' node");
        }

        private WorkbookReader GetWorkbookReader()
        {
            if (_reader == null)
            {
                using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.FundingStreamConfigData.xlsx"))
                {
                    _reader = new WorkbookReader(resource.Stream);
                }
            }

            return _reader;
        }

        private void WriteToFile(string configJson, string resourceFolder)
        {
            const string jsonConfigFilename = "Config.json";
            const string textIndexPlaceMarker = "FCT.Console.Config";

            var fullPath = System.AppDomain.CurrentDomain.BaseDirectory;

            var position = fullPath.LastIndexOf(textIndexPlaceMarker);

            var path = fullPath.Substring(0, position);

            var resourceLocation = path + resourceFolder + jsonConfigFilename;

            File.WriteAllText(resourceLocation, configJson);
        }

        private void WriteFileToContractsAcceptanceTests(string configJson)
        {
            const string jsonConfigFilename = "Config.json";
            const string textIndexPlaceMarker = "FCT.Console";
            const string resourceFolder = @"Contracts.AcceptanceTests\Contracts.AcceptanceTests\Resources\";

            var fullPath = System.AppDomain.CurrentDomain.BaseDirectory;

            var position = fullPath.IndexOf(textIndexPlaceMarker);

            var path = fullPath.Substring(0, position);

            var resourceLocation = path + resourceFolder + jsonConfigFilename;

            File.WriteAllText(resourceLocation, configJson);
        }

    }
}