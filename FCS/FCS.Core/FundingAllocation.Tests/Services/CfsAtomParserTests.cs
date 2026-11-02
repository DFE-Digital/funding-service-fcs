namespace FundingAllocation.Tests.Services
{
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CfsAtomParserTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CfsAtomParser_GetPrevLink_ShouldGetPrevLink()
        {
            // arrange
            string json = GetJsonResponseFromFile("Resources.CfsAtomNotificationPage.json");

            // act
            var prevLink = CfsAtomParser.GetPrevLink(json);

            // assert
            Assert.AreEqual("https://app-t1sb-external-v2.azurewebsites.net/api/v3/funding/notifications/2?groupingreasons=Contracting", prevLink);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CfsAtomParser_GetPageNumberFromLink_ShouldGetNumber()
        {
            // arrange
            string prevLink = "https://app-t1sb-external-v2.azurewebsites.net/api/v4/funding/notifications/2?groupingreasons=Contracting";

            // act
            var pageNumber = CfsAtomParser.GetPageNumberFromLink(prevLink);

            // assert
            Assert.AreEqual(2, pageNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CfsAtomParser_GetAtomItems_ShouldGetAtomItems()
        {
            // arrange
            string json = GetJsonResponseFromFile("Resources.CfsAtomNotificationPage.json");

            // act
            var atomItems = CfsAtomParser.GetAtomItems(json);

            // assert
            Assert.AreEqual(500, atomItems.Count, "The total number of items is incorrect");
            var firstAtomItem = atomItems.First();
            Assert.AreEqual("1619-AS-2122-Contracting-Provider-10083475-2_0", firstAtomItem.FundingId, "The fundingId is not correct");
            Assert.AreEqual("2_0", firstAtomItem.FundingVersion, "The FundingVersion is not correct");
            Assert.AreEqual("AS-2122", firstAtomItem.Period, "The Period is not correct");
            Assert.AreEqual("1619", firstAtomItem.AllocationFundingStream, "The AllocationFundingStream is not correct");
            Assert.AreEqual("10083475", firstAtomItem.Ukprn, "The Ukprn is not correct");
            Assert.AreEqual(-19000, firstAtomItem.Value, "The Value is not correct");
            Assert.AreEqual(1, firstAtomItem.ProviderFundingIds.Length, "The ProviderFundingIds count is not correct");
            Assert.AreEqual("1619-AS-TEST1-10083475-1_0", firstAtomItem.ProviderFundingIds.First(), "The ProviderFundingId is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CfsAtomParser_GetProviderFundingAllocationApiDto_ShouldGetDto_AndThenFundingAllocationLineApiDto_IsValid()
        {
            // arrange
            string json = GetJsonResponseFromFile("Resources.CfsProvider.json");

            // act
            var dto = CfsAtomParser.GetProviderFundingAllocationApiDto(json);

            // assert
            Assert.AreEqual("Furth", dto.ProviderType, "The provider type is incorrect");
            Assert.AreEqual("18ISP", dto.ProviderSubType, "The ProviderSubType is incorrect");
            Assert.AreEqual("1619-AS-TEST1-10083475-1_0", dto.ProviderFundingId, "The ProviderFundingId is incorrect");
            Assert.AreEqual(82, dto.FundingAllocationLines.Length, "The FundingAllocationLines count is incorrect");
            
            // assert FundingAllocationLineApiDto.IsValid functionality 
            var validFundingAllocationLines = dto.FundingAllocationLines.Where(fal => fal.IsValid()).ToArray();
            Assert.AreEqual(1, validFundingAllocationLines.Length, "The valid FundingAllocationLines count is incorrect");

            Assert.AreEqual("1619-001", validFundingAllocationLines[0].FundingLineCode, "The FundingLineCode is incorrect");
            Assert.AreEqual(12, validFundingAllocationLines[0].FundingAllocationProfilePeriods.Length, "The FundingAllocationProfilePeriods count is incorrect");
        }

        private static string GetJsonResponseFromFile(string resourceName)
        {
            using Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"FundingAllocation.Tests.{resourceName}");
            using StreamReader streamReader = new StreamReader(stream);

            return streamReader.ReadToEnd();
        }
    }
}
