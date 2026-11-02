namespace SFA.FCT.ContractManagementService.Common
{
    using CrossDomain.Integration.Common;

    public class ContractManagementLoggingEvents
    {
        public const int CMApprovedReceived = LoggingEventId.ContractManagementDomain;
        public const int CMBadContractNumber = LoggingEventId.ContractManagementDomain + 1;
        public const int CMContractNumberNotFound = LoggingEventId.ContractManagementDomain + 2;
        public const int CMBusError = LoggingEventId.ContractManagementDomain + 3;
        public const int CMCorpContractOnBus = LoggingEventId.ContractManagementDomain + 4;
        public const int CMSeedApprovedContractStorage = LoggingEventId.ContractManagementDomain + 5;
        public const int CMStorageIssue = LoggingEventId.ContractManagementDomain + 6;
        public const int CMSeedApprovedContract = LoggingEventId.ContractManagementDomain + 7;
        public const int CMApprovedEventReceivedForPagedStorage = LoggingEventId.ContractManagementDomain + 8;
        public const int ContractXmlInvalidAgainstCorporateSchema = LoggingEventId.ContractManagementDomain + 9;

        public const int PublishApprovedContractCommandReceived = LoggingEventId.ContractManagementDomain + 10;
        public const int PublishedContractApprovedEvent = LoggingEventId.ContractManagementDomain + 11;
        public const int PublishContractApprovedEventFailed = LoggingEventId.ContractManagementDomain + 12;

        public const int ReleaseForReviewBadContractNumber = LoggingEventId.ContractManagementDomain + 13;
        public const int ReleaseForReviewCommandSent = LoggingEventId.ContractManagementDomain + 14;

        public const int ReleaseForReviewCommandReceived = LoggingEventId.ContractManagementDomain + 15;
        public const int DocumentMergeCommandSent = LoggingEventId.ContractManagementDomain + 16;
        public const int DocumentMergeCommandNotSent = LoggingEventId.ContractManagementDomain + 17;

        public const int PublishContractToProviderEventReceived = LoggingEventId.ContractManagementDomain + 18;
        public const int PublishContractToProviderEventCompleted = LoggingEventId.ContractManagementDomain + 19;
        public const int ConfirmPublicationToProviderBadContractNumber = LoggingEventId.ContractManagementDomain + 20;
        public const int DocumentMoveCommandNotSent = LoggingEventId.ContractManagementDomain + 21;
        public const int DocumentMoveCommandSent = LoggingEventId.ContractManagementDomain + 22;
        public const int ConfirmPublicationToProviderCommandSent = LoggingEventId.ContractManagementDomain + 23;
        public const int PublishContractToProviderFailed = LoggingEventId.ContractManagementDomain + 24;

        public const int IntegrityCheckPostReceived = LoggingEventId.ContractManagementDomain + 25;
        public const int IntegrityCheckReceivedWithAnIncorrectName = LoggingEventId.ContractManagementDomain + 26;

        public const int InitiateContractApprovalReceived = LoggingEventId.ContractManagementDomain + 27;
        public const int InitiateContractApprovalCommandSent = LoggingEventId.ContractManagementDomain + 28;
        public const int InitiateContractApprovalBadRequest = LoggingEventId.ContractManagementDomain + 29;

        public const int InitiateContractApprovalCommandReceived = LoggingEventId.ContractManagementDomain + 30;
        public const int InitiateContractApprovalHandlerBadContractNumber = LoggingEventId.ContractManagementDomain + 31;
        public const int InitiateContractApprovalHandlerUpdateContractForApproval = LoggingEventId.ContractManagementDomain + 32;
        public const int InitiateContractApprovalHandlerDidNotUpdateContractForApproval = LoggingEventId.ContractManagementDomain + 33;
        public const int InitiateContractApprovalHandlerContractAlreadyApproved = LoggingEventId.ContractManagementDomain + 34;

        public const int ConfirmPublicationToProviderCommandReceived = LoggingEventId.ContractManagementDomain + 35;
        public const int ContractNotificationPublishedToProviderEventReceived = LoggingEventId.ContractManagementDomain + 36;
        public const int DocumentMoveResponseReceived = LoggingEventId.ContractManagementDomain + 37;
        public const int PublishContractReadyToPublishEventPublished = LoggingEventId.ContractManagementDomain + 38;

        public const int InitiateContractApprovalHandlerContractValidationException = LoggingEventId.ContractManagementDomain + 39;

        public const int WithdrawContractBadContractDetails = LoggingEventId.ContractManagementDomain + 40;
        public const int WithdrawRequestReceived = LoggingEventId.ContractManagementDomain + 41;
        public const int WithdrawRequestAccepted = LoggingEventId.ContractManagementDomain + 42;

        public const int InitiateContractWithdrawCommandReceived = LoggingEventId.ContractManagementDomain + 43;
        public const int InitiateContractWithdrawHandlerUpdateContractForWithdrawal = LoggingEventId.ContractManagementDomain + 44;
        public const int InitiateContracttWithdrawHandlerContractAlreadyWithdrawn = LoggingEventId.ContractManagementDomain + 45;
        public const int InitiateContractWithdrawHandlerBadContractNumber = LoggingEventId.ContractManagementDomain + 46;
        public const int InitiateContractWithdrawHandlerDidNotUpdateContractForWithdrawal = LoggingEventId.ContractManagementDomain + 47;

        public const int PublishContractReadyToWithdrawEventReceived = LoggingEventId.ContractManagementDomain + 48;
        public const int PublishContractReadyToWithdrawEventFailed = LoggingEventId.ContractManagementDomain + 49;
        public const int PublishContractReadyToWithdrawEventCompleted = LoggingEventId.ContractManagementDomain + 50;

        public const int PublishContractToProviderEventStart = LoggingEventId.ContractManagementDomain + 51;
        public const int PublishContractToProviderEventEnd = LoggingEventId.ContractManagementDomain + 52;

        public const int InitiatePublishOfFundingClaimReconciliationReceived = LoggingEventId.ContractManagementDomain + 53;
        public const int InitiatePublishOfFundingClaimReconciliationCommandSent = LoggingEventId.ContractManagementDomain + 54;

        public const int InitiateContractApprovalHandlerDeferDueToMonthEndProcessing =
            LoggingEventId.ContractManagementDomain + 55;

        public const int ConfirmPublicationToProviderProcessDateGreaterThanContractingActivityCloseDate =
            LoggingEventId.ContractManagementDomain + 56;

        public const int InitiateContractApprovalHandlerContractInWrongStateError =
            LoggingEventId.ContractManagementDomain + 57;

        public const int PreIncrementWithdrawalCommandReceived =
            LoggingEventId.ContractManagementDomain + 58;

        public const int PreIncrementWithdrawalCommandCompleted =
            LoggingEventId.ContractManagementDomain + 59;

        public const int DeleteDraftContractItemsCommandReceived = LoggingEventId.ContractManagementDomain + 60;
        public const int DeleteDraftContractItemsCommandCompleted = LoggingEventId.ContractManagementDomain + 61;

        public const int DeleteDraftContractBadRequest = LoggingEventId.ContractManagementDomain + 62;
        public const int DeleteDraftContractReceived = LoggingEventId.ContractManagementDomain + 63;
        public const int DeleteDraftContractItemsCommandSent = LoggingEventId.ContractManagementDomain + 64;
        public const int DeleteDocumentsForContractCommandReceived = LoggingEventId.ContractManagementDomain + 65;
        public const int DeleteDocumentsForContractCommandCompleted = LoggingEventId.ContractManagementDomain + 66;

        public const int DeleteContractCommandReceived = LoggingEventId.ContractManagementDomain + 67;
        public const int DeleteContractCommandCompleted = LoggingEventId.ContractManagementDomain + 68;

        public const int ChangeAgreementStartDateStarted = LoggingEventId.ContractManagementDomain + 69;
        public const int ChangeAgreementStartDateCompleted = LoggingEventId.ContractManagementDomain + 70;

        public const int ContractClosureCommandReceived = LoggingEventId.ContractManagementDomain + 71;
        public const int ContractClosureCommandCompleted = LoggingEventId.ContractManagementDomain + 72;

        public const int ContractClosureBadRequest = LoggingEventId.ContractManagementDomain + 73;
        public const int ContractClosureRequestReceived = LoggingEventId.ContractManagementDomain + 74;
        public const int ContractClosureRequestAccepted = LoggingEventId.ContractManagementDomain + 75;

        public const int IssueCrmNotificationCommandReceived = LoggingEventId.ContractManagementDomain + 76;
        public const int IssueCrmNotificationCommandCompleted = LoggingEventId.ContractManagementDomain + 77;

        public const int AllocationPaymentsChangedEventReceived = LoggingEventId.ContractManagementDomain + 78;
        public const int AllocationPaymentsChangedEventCompleted = LoggingEventId.ContractManagementDomain + 79;

        public const int ApproveContractClosureBadRequest = LoggingEventId.ContractManagementDomain + 80;
        public const int ApproveContractClosureRequestReceived = LoggingEventId.ContractManagementDomain + 81;
        public const int ApproveContractClosureRequestAccepted = LoggingEventId.ContractManagementDomain + 82;

        public const int ApproveContractClosureCommandReceived = LoggingEventId.ContractManagementDomain + 83;
        public const int ApproveContractClosureCommandCompleted = LoggingEventId.ContractManagementDomain + 84;

        public const int ContractClosedEventReceived = LoggingEventId.ContractManagementDomain + 85;
        public const int ContractClosedEventCompleted = LoggingEventId.ContractManagementDomain + 86;
        public const int ClosingContractInCrm = LoggingEventId.ContractManagementDomain + 87;
        public const int AmendLevyContractNotOnRoatp = LoggingEventId.ContractManagementDomain + 88;
        public const int AmendLevyContractNoActionTaken = LoggingEventId.ContractManagementDomain + 89;
        public const int AmendLevyContractCommandArrived = LoggingEventId.ContractManagementDomain + 90;
        public const int AmendLevyContractCommandCompleted = LoggingEventId.ContractManagementDomain + 91;

        public const int AmendContractBadRequest = LoggingEventId.ContractManagementDomain + 92;
        public const int AmendContractRequestReceived = LoggingEventId.ContractManagementDomain + 93;
        public const int AmendContractRequestAccepted = LoggingEventId.ContractManagementDomain + 94;

        public const int AmendContractNonFinancialAmendmentCommandReceived = LoggingEventId.ContractManagementDomain + 95;
        public const int AmendContractNonFinancialAmendmentCommandCompleted = LoggingEventId.ContractManagementDomain + 96;

        public const int InitiateRoatpUpdateHandleStarted = LoggingEventId.ContractManagementDomain + 97;
        public const int InitiateRoatpUpdateHandleRetrievedFromRoatp = LoggingEventId.ContractManagementDomain + 98;
        public const int InitiateRoatpUpdateHandleCompleted = LoggingEventId.ContractManagementDomain + 99;

        public const int PublishContractClosedEventFailed = LoggingEventId.ContractManagementDomain + 100;
        public const int PublishContractClosedEventSuccessful = LoggingEventId.ContractManagementDomain + 101;

        public const int ApproveContractTerminationInitiationBadRequest = LoggingEventId.ContractManagementDomain + 102;
        public const int ApproveContractTerminationInitiationReceived = LoggingEventId.ContractManagementDomain + 103;
        public const int ApproveContractTerminationInitiationAccepted = LoggingEventId.ContractManagementDomain + 104;

        public const int ApproveContractTerminationInitiationCommandReceived = LoggingEventId.ContractManagementDomain + 105;
        public const int ApproveContractTerminationInitiationCommandProcessed = LoggingEventId.ContractManagementDomain + 106;

        public const int SetContractTerminationToCompleteCommandReceived = LoggingEventId.ContractManagementDomain + 107;
        public const int SetContractTerminationToCompleteCommandProcessed = LoggingEventId.ContractManagementDomain + 108;

        public const int AddApprovedTerminationInitiationContractAlreadyPresent = LoggingEventId.ContractManagementDomain + 109;

        public const int CancelContractTerminationBadRequest = LoggingEventId.ContractManagementDomain + 110;
        public const int CancelContractTerminationReceived = LoggingEventId.ContractManagementDomain + 111;
        public const int CancelContractTerminationAccepted = LoggingEventId.ContractManagementDomain + 112;
        public const int CancelContractTerminationCommandReceived = LoggingEventId.ContractManagementDomain + 113;
        public const int CancelContractTerminationCommandProcessed = LoggingEventId.ContractManagementDomain + 114;

        public const int TerminateContractBadRequest = LoggingEventId.ContractManagementDomain + 115;
        public const int TerminateContractReceived = LoggingEventId.ContractManagementDomain + 116;
        public const int TerminateContractAccepted = LoggingEventId.ContractManagementDomain + 117;
        public const int TerminateContractCommandReceived = LoggingEventId.ContractManagementDomain + 118;
        public const int TerminateContractCommandProcessed = LoggingEventId.ContractManagementDomain + 119;
        public const int ContractTerminatedEventReceived = LoggingEventId.ContractManagementDomain + 120;
        public const int ContractTerminatedEventProcessed = LoggingEventId.ContractManagementDomain + 121;

        public const int ContractTerminationCancelledEventReceived = LoggingEventId.ContractManagementDomain + 122;
        public const int ContractTerminationCancelledEventProcessed = LoggingEventId.ContractManagementDomain + 123;
        public const int ContractTerminationValidationSuccess = LoggingEventId.ContractManagementDomain + 124;
        public const int ContractTerminationValidationFailed = LoggingEventId.ContractManagementDomain + 125;
        public const int ContractTerminationFailedReceived = LoggingEventId.ContractManagementDomain + 126;
        public const int ContractTerminationFailedProcessed = LoggingEventId.ContractManagementDomain + 127;

        public const int UpdateContractTerminationDetailsBadRequest = LoggingEventId.ContractManagementDomain + 128;
        public const int UpdateContractTerminationDetailsReceived = LoggingEventId.ContractManagementDomain + 129;
        public const int UpdateContractTerminationDetailsAccepted = LoggingEventId.ContractManagementDomain + 130;

        public const int UpdateContractTerminationDetailsCommandReceived = LoggingEventId.ContractManagementDomain + 131;
        public const int UpdateContractTerminationDetailsCommandProcessed = LoggingEventId.ContractManagementDomain + 132;

        public const int InitiateCfsAllocationReleaseCommandReceived = LoggingEventId.ContractManagementDomain + 133;
        public const int InitiateCfsAllocationReleaseCommandProcessed = LoggingEventId.ContractManagementDomain + 134;

        public const int AmendLevyContractCommandNoMessageSent = LoggingEventId.ContractManagementDomain + 135;
        public const int InitiateReCalculationForFcrCommandReceived = LoggingEventId.ContractManagementDomain + 136;
        public const int InitiateReCalculationForFcrCommandProcessed = LoggingEventId.ContractManagementDomain + 137;
        public const int DeleteMasterContractsCommandReceived = LoggingEventId.ContractManagementDomain + 138;
        public const int DeleteMasterContractsCommandProcessed = LoggingEventId.ContractManagementDomain + 139;
        public const int PublishApprovedContractCommandProcessed = LoggingEventId.ContractManagementDomain + 140;

        public const int ContractModificationHttpRequestReceived = LoggingEventId.ContractManagementDomain + 141;
        public const int ContractModificationBadHttpRequest = LoggingEventId.ContractManagementDomain + 142;
        public const int ContractModificationHttpRequestProcessed = LoggingEventId.ContractManagementDomain + 143;

        public const int ApproveContractModificationCommandReceived = LoggingEventId.ContractManagementDomain + 144;
        public const int ApproveContractModificationCommandProcessed = LoggingEventId.ContractManagementDomain + 145;

        public const int UpdateContractModificationCommandReceived = LoggingEventId.ContractManagementDomain + 146;
        public const int UpdateContractModificationCommandProcessed = LoggingEventId.ContractManagementDomain + 147;

        public const int CancelContractModificationCommandReceived = LoggingEventId.ContractManagementDomain + 148;
        public const int CancelContractModificationCommandProcessed = LoggingEventId.ContractManagementDomain + 149;

        public const int fundingAllocationReleaseGroupCommandReceived = LoggingEventId.ContractManagementDomain + 150;
        public const int fundingAllocationReleaseGroupCommandProcessed = LoggingEventId.ContractManagementDomain + 151;

        public const int FundingAllocationHoldEventReceived = LoggingEventId.ContractManagementDomain + 152;
        public const int FundingAllocationHoldEventProcessed = LoggingEventId.ContractManagementDomain + 153;
        public const int FundingAllocationUnHoldEventReceived = LoggingEventId.ContractManagementDomain + 154;
        public const int FundingAllocationUnHoldEventProcessed = LoggingEventId.ContractManagementDomain + 155;
        public const int FundingAllocationWithdrawalEventReceived = LoggingEventId.ContractManagementDomain + 156;
        public const int FundingAllocationWithdrawalEventProcessed = LoggingEventId.ContractManagementDomain + 157;
        public const int FundingAllocationReinstateEventReceived = LoggingEventId.ContractManagementDomain + 158;
        public const int FundingAllocationReinstateEventProcessed = LoggingEventId.ContractManagementDomain + 159;

        public const int FundingAllocationReleaseInProgressEventReceived = LoggingEventId.ContractManagementDomain + 160;
        public const int FundingAllocationReleaseInProgressEventProcessed = LoggingEventId.ContractManagementDomain + 161;
        public const int FundingAllocationReleasedEventReceived = LoggingEventId.ContractManagementDomain + 162;
        public const int FundingAllocationReleasedEventProcessed = LoggingEventId.ContractManagementDomain + 163;

        public const int CreateFundingConfirmationReportReceived = LoggingEventId.ContractManagementDomain + 164;
        public const int CreateFundingConfirmationReportCommandSent = LoggingEventId.ContractManagementDomain + 165;
        public const int FundingAllocationUnQueueEventReceived = LoggingEventId.ContractManagementDomain + 166;
        public const int FundingAllocationUnQueueEventProcessed = LoggingEventId.ContractManagementDomain + 167;
        public const int CreateLAFundingConfirmationReportReceived = LoggingEventId.ContractManagementDomain + 168;
        public const int CreateLAFundingConfirmationReportCommandSent = LoggingEventId.ContractManagementDomain + 169;
    }
}