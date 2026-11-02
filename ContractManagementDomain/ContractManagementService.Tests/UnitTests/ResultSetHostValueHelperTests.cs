using Microsoft.AspNetCore.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.ContractManagementService.Utils;

namespace ContractManagementService.Tests.UnitTests
{
    [TestClass, TestCategory("UnitTest")]
    public class ResultSetHostValueHelperTests
    {
        [TestMethod]
        public void SchemeAndHostValue_WithoutForwardedHeaders_ReturnsConfiguredValue()
        {
            var request = new DefaultHttpContext().Request;

            var result = ResultSetHostValueHelper.SchemeAndHostValue(request, "https://configured.example");

            Assert.AreEqual("https://configured.example", result);
        }

        [TestMethod]
        public void SchemeAndHostValue_WithForwardedHeaders_ReturnsForwardedSchemeAndHost()
        {
            var request = new DefaultHttpContext().Request;
            request.Headers["X-Request-Scheme"] = "https";
            request.Headers["X-Request-Host"] = "public.example";

            var result = ResultSetHostValueHelper.SchemeAndHostValue(request, "https://configured.example");

            Assert.AreEqual("https://public.example", result);
        }

        [TestMethod]
        public void SchemeAndHostValue_WithOnlyOneForwardedHeader_ReturnsConfiguredValue()
        {
            var request = new DefaultHttpContext().Request;
            request.Headers["X-Request-Host"] = "public.example";

            var result = ResultSetHostValueHelper.SchemeAndHostValue(request, "https://configured.example");

            Assert.AreEqual("https://configured.example", result);
        }

        [TestMethod]
        public void SchemeAndHostValue_WithNullRequest_ReturnsConfiguredValue()
        {
            var result = ResultSetHostValueHelper.SchemeAndHostValue(null, "https://configured.example");

            Assert.AreEqual("https://configured.example", result);
        }
    }
}
