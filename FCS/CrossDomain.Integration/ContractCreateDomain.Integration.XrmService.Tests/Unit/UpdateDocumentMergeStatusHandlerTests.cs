//namespace ContractCreateDomain.Integration.XrmService.Tests.Unit
//{
//    using System;
//    using System.Collections.Generic;
//    using Microsoft.VisualStudio.TestTools.UnitTesting;
//    using Moq;
//    using NServiceBus;
//    using SFA.FCT.ContractCreateDomain.BusinessLogic;
//    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
//    using SFA.FCT.ContractCreateDomain.XrmServiceHandlers;
//    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
//    using SFA.FCT.CrossDomain.Integration.Entities.Documents;
//    using SFA.FCT.DocumentsDomain.Common.Commands;
//    using SFA.FCT.Framework.Logging.Interfaces;

//    [TestClass]
//    public class UpdateDocumentMergeStatusHandlerTests
//    {
//        /*
//        [TestMethod, TestCategory("UnitTest")]
//        public void Handle_UpdateDocumentMergeStatusCommand_ShouldSendGetDocumentsForDeleteCommand_ForSuccessfulMergeAndUpdate()
//        {
//            var mockLogger = new Mock<ILogger>();
//            var mockContractsManager = new Mock<IContractsManager>();
//            var mockBus = new Mock<IBus>();

//            var handler = new XrmService
//            {
//                Logger = mockLogger.Object,
//                ContractsManager = mockContractsManager.Object,
//                Bus = mockBus.Object
//            };

//            var contract = new contractType();
//            var masterContract = new contract
//            {
//                contracts = new List<contractType>
//                {
//                    contract
//                }
//            };

//            var mergeStatus = new MergeStatus
//            {
//                IsMergeSuccessful = true
//            };

//            mockContractsManager.Setup(m => m.UpdateContractWithDocumentMergeStatus(contract, mergeStatus))
//                .Returns(true);

//            var cmd = new UpdateDocumentMergeStatusCommand
//            {
//                CorporateContract = masterContract,
//                MergeStatus = mergeStatus
//            };

//            handler.Handle(cmd);

//            mockContractsManager.VerifyAll();

//            mockBus.Verify(b => b.Send(It.Is<GetDocumentsForDeleteCommand>(c => c.MasterContract == masterContract && c.Contract == contract)), 
//                Times.Once, "No reply was made to MergeDocument endpoint with ContractNumber and UKPRN.");

//            mockLogger.Verify(l => l.LogInformation(ContractCreateDomainEventLoggingId.UpdateDocumentMergeStatusHandlerMsgReceived, It.IsAny<string>()));
//            mockLogger.Verify(l => l.LogInformation(ContractCreateDomainEventLoggingId.UpdateDocumentMergeStatusHandlerUpdateSuccessful, It.IsAny<string>()));
//            mockLogger.Verify(l => l.LogInformation(ContractCreateDomainEventLoggingId.UpdateDocumentMergeStatusHandlerReplying, It.IsAny<string>()));
//        }
//        */

//        [TestMethod, TestCategory("UnitTest")]
//        public void Handle_UpdateDocumentMergeStatusCommand_DoesNotReplyWithGetDocumentsForDeleteCommand_ForFailedMergeAndSuccessfulUpdate()
//        {
//            var mockLogger = new Mock<ILogger>();
//            var mockContractsManager = new Mock<IContractsManager>();
//            var mockBus = new Mock<IBus>();

//            var handler = new XrmService
//            {
//                Logger = mockLogger.Object,
//                ContractsManager = mockContractsManager.Object,
//                Bus = mockBus.Object
//            };

//            var contract = new contractType();
//            var masterContract = new contract
//            {
//                contracts = new List<contractType>
//                {
//                    contract
//                }
//            };

//            var mergeStatus = new MergeStatus
//            {
//                IsMergeSuccessful = false
//            };

//            mockContractsManager.Setup(m => m.UpdateContractWithDocumentMergeStatus(contract, mergeStatus))
//                .Returns(true);

//            var cmd = new UpdateDocumentMergeStatusCommand
//            {
//                CorporateContract = masterContract,
//                MergeStatus = mergeStatus
//            };

//            handler.Handle(cmd);

//            mockContractsManager.VerifyAll();

//            mockBus.Verify(b => b.Reply(It.IsAny<GetDocumentsForDeleteCommand>()), Times.Never, "A reply was made to MergeDocument endpoint.");

//            mockLogger.Verify(l => l.LogInformation(ContractCreateDomainEventLoggingId.UpdateDocumentMergeStatusHandlerMsgReceived, It.IsAny<string>()));
//            mockLogger.Verify(l => l.LogInformation(ContractCreateDomainEventLoggingId.UpdateDocumentMergeStatusHandlerUpdateSuccessful, It.IsAny<string>()));
//        }

//        [TestMethod, TestCategory("UnitTest")]
//        [ExpectedException(typeof(Exception))]
//        public void Handle_UpdateDocumentMergeStatusCommand_DoesNotReplyWithGetDocumentsForDeleteCommand_ForFailedMergeAndFailedUpdate()
//        {
//            var mockLogger = new Mock<ILogger>();
//            var mockContractsManager = new Mock<IContractsManager>();
//            var mockBus = new Mock<IBus>();

//            var handler = new XrmService
//            {
//                Logger = mockLogger.Object,
//                ContractsManager = mockContractsManager.Object,
//                Bus = mockBus.Object
//            };

//            var contract = new contractType();
//            var masterContract = new contract
//            {
//                contracts = new List<contractType>
//                {
//                    contract
//                }
//            };

//            var mergeStatus = new MergeStatus
//            {
//                IsMergeSuccessful = false
//            };

//            mockContractsManager.Setup(m => m.UpdateContractWithDocumentMergeStatus(contract, mergeStatus))
//                .Throws(new Exception("CRM is not good!!! why not use MVC"));

//            var cmd = new UpdateDocumentMergeStatusCommand
//            {
//                CorporateContract = masterContract,
//                MergeStatus = mergeStatus
//            };

//            handler.Handle(cmd);

//            mockContractsManager.VerifyAll();

//            mockBus.Verify(b => b.Reply(It.IsAny<GetDocumentsForDeleteCommand>()), Times.Never, "A reply was made to MergeDocument endpoint.");

//            mockLogger.Verify(l => l.LogInformation(ContractCreateDomainEventLoggingId.UpdateDocumentMergeStatusHandlerMsgReceived, It.IsAny<string>()));
//            mockLogger.Verify(l => l.LogError(ContractCreateDomainEventLoggingId.UpdateDocumentMergeStatusHandlerUpdateFailed, It.IsAny<string>()));
//        }
//    }
//}
