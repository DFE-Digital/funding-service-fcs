namespace ContractRequestDomain.Tests.BulkUpload
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class ContractRequestCommandCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestCommandCreator_ShouldReturnNewCommandOfCorrectTypeForIntent()
        {
            // arrange
            var contractRequest = new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType
            {
                contract = new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType()
                {
                    correlationId = "XX",
                    contracts = new List<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType>
                    {
                        new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType
                        {
                            hierarchyType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.hierarchyType.CONTRACT
                        }
                    }
                },
                correlationInfo = new correlationInfoType
                {
                    batchId = "BATCH",
                    correlationId = "CID"
                }
            };


            // act
            ContractRequestCommandInfo updateDraftCommandInfo = ContractRequestCommandInfoFactory.Create(intent.UpdateDraft, contractRequest);
            ContractRequestCommandInfo ammendmentCommandInfo = ContractRequestCommandInfoFactory.Create(intent.Amendment, contractRequest);
            ContractRequestCommandInfo updateDraftAmendmentCommandInfo = ContractRequestCommandInfoFactory.Create(intent.UpdateDraftAmendment, contractRequest);
            ContractRequestCommandInfo newCommandInfo = ContractRequestCommandInfoFactory.Create(intent.New, contractRequest);
            ContractRequestCommandInfo newAmendmentCommandInfo = ContractRequestCommandInfoFactory.Create(intent.NewAmendment, contractRequest);
            ContractRequestCommandInfo newWithExistingNumberCommandInfo = ContractRequestCommandInfoFactory.Create(intent.RevisedNew, contractRequest);

            // assert
            Assert.IsTrue(updateDraftCommandInfo?.CommandObject is DraftContractUpdateRequestCommand, "The wrong type of command is returned for UpdateDraft intent");
            Assert.IsTrue(ammendmentCommandInfo?.CommandObject is ContractAmendmentRequestCommand, "The wrong type of command is returned for Amendment intent");
            Assert.IsTrue(updateDraftAmendmentCommandInfo?.CommandObject is UpdateDraftContractAmendmentRequestCommand, "The wrong type of command is returned for UpdateDraftAmendment intent");
            Assert.IsTrue(newCommandInfo?.CommandObject is NewContractRequestCommand, "The wrong type of command is returned for New intent");
            Assert.IsTrue(newAmendmentCommandInfo?.CommandObject is NewAmendmentRequestCommand, "The wrong type of command is returned for NewAmendment intent");
            Assert.IsTrue(newWithExistingNumberCommandInfo?.CommandObject is RevisedNewContractRequestCommand, "The wrong type of command is returned for NewWithExistingNumber intent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestCommandCreator_ShouldReturnNewCommandWithCorrectInformationText()
        {
            // arrange
            var contractRequest = new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType
            {
                contract = new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType()
                {
                    correlationId = "XX",
                    contracts = new List<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType>
                    {
                        new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType
                        {
                            hierarchyType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.hierarchyType.CONTRACT
                        }
                    }
                },
                correlationInfo = new correlationInfoType
                {
                    batchId = "BATCH",
                    correlationId = "CID"
                }
            };

            // act
            ContractRequestCommandInfo revisedNewContractCommandInfo = ContractRequestCommandInfoFactory.Create(intent.RevisedNew, contractRequest);

            // assert
            Assert.AreEqual("Sent new contract with existing number request BATCH CID", revisedNewContractCommandInfo.InformationText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestCommandCreator_ShouldReturnNewCommandInfoWithCorrectLoggingId()
        {
            // arrange
            var contractRequest = new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType
            {
                contract = new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType()
                {
                    correlationId = "XX",
                    contracts = new List<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType>
                    {
                        new SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType
                        {
                            hierarchyType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.hierarchyType.CONTRACT
                        }
                    }
                },
                correlationInfo = new correlationInfoType
                {
                    batchId = "BATCH",
                    correlationId = "CID"
                }
            };


            // act
            ContractRequestCommandInfo updateDraftCommandInfo = ContractRequestCommandInfoFactory.Create(intent.UpdateDraft, contractRequest);
            ContractRequestCommandInfo ammendmentCommandInfo = ContractRequestCommandInfoFactory.Create(intent.Amendment, contractRequest);
            ContractRequestCommandInfo updateDraftAmendmentCommandInfo = ContractRequestCommandInfoFactory.Create(intent.UpdateDraftAmendment, contractRequest);
            ContractRequestCommandInfo newCommandInfo = ContractRequestCommandInfoFactory.Create(intent.New, contractRequest);
            ContractRequestCommandInfo newAmendmentCommandInfo = ContractRequestCommandInfoFactory.Create(intent.NewAmendment, contractRequest);
            ContractRequestCommandInfo revisedNewContractCommandInfo = ContractRequestCommandInfoFactory.Create(intent.RevisedNew, contractRequest);

            // assert
            Assert.AreEqual(ContractRequestDomainEventLoggingId.DraftContractUpdatePublished, updateDraftCommandInfo.LoggingId,  "The wrong logging id is returned for UpdateDraft intent");
            Assert.AreEqual(ContractRequestDomainEventLoggingId.ContractAmendmentRequestPublished, ammendmentCommandInfo.LoggingId, "The wrong logging id is returned for Amendment intent");
            Assert.AreEqual(ContractRequestDomainEventLoggingId.UpdateDraftContractAmendmentRequestPublished, updateDraftAmendmentCommandInfo.LoggingId, "The wrong type of command is returned for UpdateDraftAmendment intent");
            Assert.AreEqual(ContractRequestDomainEventLoggingId.NewContractRequestPublished, newCommandInfo.LoggingId, "The wrong logging id is returned for New intent");
            Assert.AreEqual(ContractRequestDomainEventLoggingId.NewAmendmentRequestSent, newAmendmentCommandInfo.LoggingId, "The wrong logging id is returned for NewAmendment intent");
            Assert.AreEqual(ContractRequestDomainEventLoggingId.RevisedNewContractRequestSent, revisedNewContractCommandInfo.LoggingId, "The wrong logging id is returned for NewWithExistingNumber intent");
        }
    }
}
