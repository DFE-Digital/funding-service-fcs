namespace ContractRequestDomain.Tests.BulkUpload.Extensions
{
    using System.IO;
    using System.Reflection;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractRequestArrayExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestArrayExtensions_GetFundingInfo_ShouldReturnCorrectData()
        {
            // arrange
            contractRequestType contractRequest = FromJson<contractRequestType>("ContractRequestDomain.Tests",
                @"Resources.contract_request_das.json");
            contractRequestType[] contractRequestTypes = {contractRequest};

            // act
            var fundingInfo = contractRequestTypes.GetFundingInfo();

            // assert
            fundingInfo.fundingPeriodName.Should().Be("LEVY1799");
            fundingInfo.fundingTypeCode.Should().Be("LEVY");

        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream =
                Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
