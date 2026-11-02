namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using System;
    using System.Collections.Generic;
    using Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Messages.Commands;

    public static class ContractRequestCommandInfoFactory
    {
        private static readonly IDictionary<intent, Func<contractRequestType, ContractRequestCommandInfo>> CommandInfoCreators = new Dictionary
            <intent, Func<contractRequestType, ContractRequestCommandInfo>>
        {
            {
                intent.UpdateDraft, contractRequestType =>
                    new ContractRequestCommandInfo(
                        new DraftContractUpdateRequestCommand {ContractRequest = contractRequestType},
                        $"Published Draft Contract Update Requested event {contractRequestType.correlationInfo}",
                        ContractRequestDomainEventLoggingId.DraftContractUpdatePublished)
            },
            {
                intent.Amendment, (contractRequestType) =>
                    new ContractRequestCommandInfo(
                        new ContractAmendmentRequestCommand {ContractRequest = contractRequestType},
                        $"Sent contract amendment request {contractRequestType.correlationInfo}",
                        ContractRequestDomainEventLoggingId.ContractAmendmentRequestPublished)
            },
            {
                intent.UpdateDraftAmendment, (contractRequestType) =>
                    new ContractRequestCommandInfo(
                        new UpdateDraftContractAmendmentRequestCommand {ContractRequest = contractRequestType},
                        $"Sent update draft contract amendment request {contractRequestType.correlationInfo}",
                        ContractRequestDomainEventLoggingId.UpdateDraftContractAmendmentRequestPublished)
            },
            {
                intent.New, (contractRequestType) =>
                    new ContractRequestCommandInfo(
                        new NewContractRequestCommand {ContractRequest = contractRequestType, ShouldReply = true},
                        $"Sent new contract request {contractRequestType.correlationInfo}",
                        ContractRequestDomainEventLoggingId.NewContractRequestPublished)
            },
            {
                intent.NewAmendment, (contractRequestType) =>
                    new ContractRequestCommandInfo(
                        new NewAmendmentRequestCommand {ContractRequest = contractRequestType},
                        $"Sent new amendment request {contractRequestType.correlationInfo}",
                        ContractRequestDomainEventLoggingId.NewAmendmentRequestSent)
            },
            {
                intent.RevisedNew, (contractRequestType) =>
                    new ContractRequestCommandInfo(
                        new RevisedNewContractRequestCommand {ContractRequest = contractRequestType},
                        $"Sent new contract with existing number request {contractRequestType.correlationInfo}",
                        ContractRequestDomainEventLoggingId.RevisedNewContractRequestSent)
            },
        };

        public static ContractRequestCommandInfo Create(intent intent, contractRequestType contractRequestType)
        {
            if (CommandInfoCreators.ContainsKey(intent))
            {
                Func<contractRequestType, ContractRequestCommandInfo> createCommandInfo = CommandInfoCreators[intent];
                return createCommandInfo(contractRequestType);
            }

            return null;
        }
    }
}
