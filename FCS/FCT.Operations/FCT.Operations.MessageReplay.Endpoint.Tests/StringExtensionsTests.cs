namespace FCT.Operations.MessageReplay.Endpoint.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Common.Extensions;

    [TestClass]
    public class StringExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ShouldGetSubStringBeforeCharacter()
        {
            string text =
                "ContractRequestDomain.BulkUpload@Endpoint = sb://fct-nservicebus-release.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=";
            string subString = text.GetSubstringBeforeCharacter("@");

            Assert.AreEqual("ContractRequestDomain.BulkUpload", subString);
        }
    }
}
