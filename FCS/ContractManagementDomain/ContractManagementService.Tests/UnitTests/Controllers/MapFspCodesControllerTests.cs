using ContractManagementService.Controllers.FundingConfigService;
using ContractManagementService.DTOs;
using ContractManagementService.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ContractManagementService.Tests.UnitTests.Controllers
{
    [TestClass, TestCategory("UnitTest")]
    public class MapFspCodesControllerTests
    {
        private readonly Mock<IFundingStreamPeriodCodeService> _service = new();

        [TestMethod]
        public async Task MapFspCodes_MissingRequiredParameter_ReturnsBadRequest()
        {
            var controller = new MapFspCodesController(_service.Object);

            var result = await controller.MapFspCodes("ALL", null);

            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
            _service.Verify(service => service.GetFundingStreamPeriodCodesAsync(
                It.IsAny<string>(),
                It.IsAny<string>()), Times.Never);
        }

        [TestMethod]
        public async Task MapFspCodes_ValidParameters_ReturnsFundingStreamPeriodCodes()
        {
            IReadOnlyCollection<string> codes = ["AY267", "CODE2"];
            _service
                .Setup(service => service.GetFundingStreamPeriodCodesAsync("ALL", "APC"))
                .ReturnsAsync(codes);
            var controller = new MapFspCodesController(_service.Object);

            var result = await controller.MapFspCodes("ALL", "APC");

            var response = (result.Result as OkObjectResult)?.Value as FundingStreamPeriodCodesResponse;
            Assert.IsNotNull(response);
            CollectionAssert.AreEqual(new[] { "AY267", "CODE2" }, new List<string>(response.FundingStreamPeriodCodes));
        }
    }
}
