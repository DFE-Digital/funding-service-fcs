using ContractManagementService.Repositories;
using ContractManagementService.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ContractManagementService.Tests.UnitTests.Services
{
    [TestClass, TestCategory("UnitTest")]
    public class FundingStreamPeriodCodeServiceTests
    {
        private readonly Mock<IAllocationFundingStreamPeriodCodeQueryRepository> _repository = new();

        [TestMethod]
        public async Task GetFundingStreamPeriodCodesAsync_ALL_AliasMatching_UsesMappedFundingStreams()
        {
            var service = new FundingStreamPeriodCodeService(_repository.Object);
            _repository
                .Setup(repository => repository.GetFundingStreamPeriodCodesAsync(
                    It.IsAny<IReadOnlyCollection<string>>(),
                    "mockApCode"))
                .ReturnsAsync(new[] { "mockFspCode" });

            await service.GetFundingStreamPeriodCodesAsync("ALL", "APC");

            _repository.Verify(repository => repository.GetFundingStreamPeriodCodesAsync(
                It.Is<IReadOnlyCollection<string>>(codes =>
                    codes.Count == 4 &&
                    codes.Contains("LOANS") &&
                    codes.Contains("ALLC") &&
                    codes.Contains("ALLF") &&
                    codes.Contains("ALLB")),
                "APC"), Times.Once);
        }

        [TestMethod]
        public async Task GetFundingStreamPeriodCodesAsync_ASF__AliasMatching_UsesMappedFundingStreams()
        {
            var service = new FundingStreamPeriodCodeService(_repository.Object);
            _repository
                .Setup(repository => repository.GetFundingStreamPeriodCodesAsync(
                    It.IsAny<IReadOnlyCollection<string>>(),
                    "mockApCode"))
                .ReturnsAsync(new[] { "mockFspCode" });

            await service.GetFundingStreamPeriodCodesAsync("ASF", "APC");

            _repository.Verify(repository => repository.GetFundingStreamPeriodCodesAsync(
                It.Is<IReadOnlyCollection<string>>(codes =>
                    codes.Count == 3 &&
                    codes.Contains("ASFG") &&
                    codes.Contains("ASFC") &&
                    codes.Contains("ASCA")),
                "APC"), Times.Once);
        }

        [TestMethod]
        public async Task GetFundingStreamPeriodCodesAsync_NonAlias_PassesValuesThroughUnchanged()
        {
            const string fundingStreamCode = "1619";
            const string periodCode = "apc";
            var service = new FundingStreamPeriodCodeService(_repository.Object);
            _repository
                .Setup(repository => repository.GetFundingStreamPeriodCodesAsync(
                    It.IsAny<IReadOnlyCollection<string>>(),
                    periodCode))
                .ReturnsAsync(new[] { "AY267" });

            await service.GetFundingStreamPeriodCodesAsync(fundingStreamCode, periodCode);

            _repository.Verify(repository => repository.GetFundingStreamPeriodCodesAsync(
                It.Is<IReadOnlyCollection<string>>(codes =>
                    codes.Count == 1 && codes.Contains(fundingStreamCode)),
                periodCode), Times.Once);
        }

        [TestMethod]
        [DataRow("all")]
        [DataRow("asf")]
        public async Task GetFundingStreamPeriodCodesAsync_AliasMatching_IsCaseSensitive(string fundingStreamCode)
        {
            var service = new FundingStreamPeriodCodeService(_repository.Object);
            _repository
                .Setup(repository => repository.GetFundingStreamPeriodCodesAsync(
                    It.IsAny<IReadOnlyCollection<string>>(),
                    "APC"))
                .ReturnsAsync(new[] { "AY267" });

            await service.GetFundingStreamPeriodCodesAsync(fundingStreamCode, "APC");

            _repository.Verify(repository => repository.GetFundingStreamPeriodCodesAsync(
                It.Is<IReadOnlyCollection<string>>(codes =>
                    codes.Count == 1 && codes.Contains(fundingStreamCode)),
                "APC"), Times.Once);
        }
    }
}
