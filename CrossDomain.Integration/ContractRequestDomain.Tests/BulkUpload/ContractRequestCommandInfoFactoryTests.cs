namespace ContractRequestDomain.Tests.BulkUpload
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class ContractRequestCommandInfoFactoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Create_ForSupportedIntents_ReturnsMatchingCommand()
        {
            var request = new contractRequestType
            {
                correlationInfo = new correlationInfoType { batchId = "batch", correlationId = "correlation" }
            };
            var intents = new[]
            {
                intent.UpdateDraft,
                intent.Amendment,
                intent.UpdateDraftAmendment,
                intent.New,
                intent.NewAmendment,
                intent.RevisedNew
            };
            var commandTypes = new[]
            {
                typeof(DraftContractUpdateRequestCommand),
                typeof(ContractAmendmentRequestCommand),
                typeof(UpdateDraftContractAmendmentRequestCommand),
                typeof(NewContractRequestCommand),
                typeof(NewAmendmentRequestCommand),
                typeof(RevisedNewContractRequestCommand)
            };

            for (var index = 0; index < intents.Length; index++)
            {
                var result = ContractRequestCommandInfoFactory.Create(intents[index], request);

                Assert.IsNotNull(result);
                Assert.AreEqual(commandTypes[index], result.CommandObject.GetType());
                Assert.IsTrue(result.InformationText.Contains("batch"));
                Assert.IsTrue(result.InformationText.Contains("correlation"));
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Create_ForUnsupportedIntent_ReturnsNull()
        {
            var result = ContractRequestCommandInfoFactory.Create((intent)999, new contractRequestType());

            Assert.IsNull(result);
        }
    }
}
