namespace ContractManagementDomain.Endpoint.ConfirmPublicationToProvider
{
    using System;
    using System.Linq;
    using System.Threading;
    using System.Threading.Tasks;
    using Infrastructure;
    using Microsoft.ServiceBus;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;
    using contractStatusTypeStatus = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractStatusTypeStatus;

    public class ConfirmPublicationToProviderHandler : IHandleMessages<ConfirmPublicationToProviderCommand>
    {
        private const string ReasonForFailure = "There was a failure to publish documentation for UKPRN: {0} & Contract: {1}. This failure was caused by contracting activity having closed for {2} {3} contracts.";

        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IDateProvider _dateProvider;
        private readonly IContractsManager _contractsManager; // careful.. has property injected dependencies
        private readonly IFundingTypeFundingPeriodService _fundingTypeFundingPeriodService;
        private readonly IXrmManager _xrmManager;
        private readonly string LevyFundingTypeCode = "LEVY";

        public ConfirmPublicationToProviderHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IDateProvider dateProvider,
            IContractsManager contractsManager,
            IFundingTypeFundingPeriodService fundingTypeFundingPeriodService,
            IXrmManager xrmManager)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _dateProvider = dateProvider;
            _contractsManager = contractsManager;
            _fundingTypeFundingPeriodService = fundingTypeFundingPeriodService;
            _xrmManager = xrmManager;
        }

        public async Task Handle(ConfirmPublicationToProviderCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.ConfirmPublicationToProviderCommandReceived,
                $"{nameof(ConfirmPublicationToProviderCommand)} received for MasterContractNumber:{message.MasterContractNumber} ContractNumber:{message.ContractNumber}");

            if (!ValidateMessage(message))
            {
                return;
            }

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            contract masterContract = _contractsManager.GetCorporateContract(message.ContractNumber, message.MasterContractNumber, lastApproved: false);


            if (ValidateContractStructure(masterContract, message.ContractNumber))
            {
                contractType childContract = GetChildContract(masterContract, message.ContractNumber);
                _logger.LogInformation(
                    101,
                    $"ConfirmPublicationToProviderCommand received for ContractNumber:{childContract.contractNumber} version:{childContract.contractVersionNumber}, sub version: {childContract.contractSubVersionNumber}");

                string fundingTypeCode = childContract.fundingType.fundingTypeCode;
                string fundingPeriodName = childContract.GetFundingPeriod();
                
                #region validation
                if (fundingTypeCode == LevyFundingTypeCode)
                {
                    int? allocationCount = 0;
                    if (childContract.contractAllocations.Any())
                    {
                        allocationCount = childContract.contractAllocations.Count;
                    }
                    _logger.LogInformation($"ConfirmPublicationToProviderCommand received for APPLevy MasterContractNumber:{message.MasterContractNumber} ContractNumber:{message.ContractNumber} allocationCount:{allocationCount}");

                    if (childContract.contractVersionNumber != 1 && allocationCount < 2)
                    {
                        if (!_fundingTypeFundingPeriodService.IsLEVYAllocationSynced(childContract.contractNumber, childContract.contractVersionNumber, childContract.contractSubVersionNumber, childContract.contractAllocations.Count))
                        {
                            _logger.LogInformation($"ConfirmPublicationToProviderCommand received where Allocation count not synced for MasterContractNumber:{message.MasterContractNumber} ContractNumber:{message.ContractNumber}");

                            masterContract = ImmediateRetries(message);
                            if (!ValidateContractStructure(masterContract, message.ContractNumber))
                            {
                                _logger.LogInformation($"Contract structure validation failed for MasterContractNumber:{message.MasterContractNumber} ContractNumber:{message.ContractNumber}");

                                return;
                            }
                            childContract = GetChildContract(masterContract, message.ContractNumber);
                            fundingTypeCode = childContract.fundingType.fundingTypeCode;
                            fundingPeriodName = childContract.GetFundingPeriod();
                        }
                    }
                }
                #endregion validation

                if (_fundingTypeFundingPeriodService.IsProcessDateAfterFundingTypeContractingActivityCloseDate(fundingTypeCode, fundingPeriodName, connectionInfo))
                {
                    _logger.LogError(ContractManagementLoggingEvents.ConfirmPublicationToProviderProcessDateGreaterThanContractingActivityCloseDate,
                        $"Funding Type '{fundingTypeCode}' Funding Period '{fundingPeriodName}' has a ContractingActivityCloseDate which is before the processing date");

                    _xrmManager.UpdateContractPublishedToProviderFailed(
                        childContract.contractNumber,
                        childContract.contractVersionNumber,
                        childContract.contractSubVersionNumber,
                        string.Format(ReasonForFailure, childContract.contractor.ukprn, childContract.contractNumber, childContract.fundingType.fundingTypeName, childContract.period.period1));

                    return;
                }

                if (DoesContractNeedToBeMoved(childContract))
                {
                    await MoveContract(masterContract, message.ContractNumber, context);
                }
                else
                {
                    // Change contract state by reference
                    UpdateContractStatus(childContract, connectionInfo);
                    ContractApprovalType approvalType = _fundingTypeFundingPeriodService.GetApprovalType(
                        fundingTypeCode: fundingTypeCode,
                        fundingPeriodName: fundingPeriodName);
                    await PublishContractReadyToPublishEvent(masterContract, approvalType, context)
                        .ConfigureAwait(false);
                }
            }
        }

        public contract ImmediateRetries(ConfirmPublicationToProviderCommand message)
        {
            contract masterContract = null;
            bool allocationSync = true;
            int retryCount = 0;
            _logger.LogInformation($"Retry verification for APPLevy allocation count for :{message.MasterContractNumber} ContractNumber:{message.ContractNumber}");

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                retryCount++;
                _logger.LogInformation($"APPLevy Retry check count  :{retryCount} for ContractNumber:{message.ContractNumber}");

                masterContract = _contractsManager.GetCorporateContract(message.ContractNumber, message.MasterContractNumber, lastApproved: false);

                contractType childContract = GetChildContract(masterContract, message.ContractNumber);

                return allocationSync = _fundingTypeFundingPeriodService.IsLEVYAllocationSynced
                                    (childContract.contractNumber, childContract.contractVersionNumber,
                                    childContract.contractSubVersionNumber, childContract.contractAllocations.Count);
            },
            maxNumChecks: 3,
            waitIntervalSeconds: 10);
            // applied 10 sec wait time and 3 time check until condtion not satisfied.
            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            if (!allocationSync)
            {
                _logger.LogError(ContractManagementLoggingEvents.ConfirmPublicationToProviderBadContractNumber,
                    $"APPLEVY allocation not synced for MasterContractNumber :{message.MasterContractNumber} " +
                    $"ContractNumber:{message.ContractNumber} , contract data moved to Error queue - contractmanagementdomain.confirmpublicationtoprovider.error");
            }
            return allocationSync == true ? masterContract :
                throw new Exception("Retry Levy Message as allocation count not matched between PaaS and CRM");

        }

        private bool ValidateMessage(ConfirmPublicationToProviderCommand message)
        {
            if (string.IsNullOrEmpty(message.ContractNumber) || string.IsNullOrEmpty(message.MasterContractNumber))
            {
                _logger.LogError(ContractManagementLoggingEvents.ConfirmPublicationToProviderBadContractNumber,
                    $"Missing MasterContractNumber or ContractNumber in the {nameof(ConfirmPublicationToProviderCommand)}");

                return false;
            }

            return true;
        }

        private bool ValidateContractStructure(contract masterContract, string childContractNumber)
        {
            if (masterContract == null || masterContract.contracts.Count == 0)
            {
                if (masterContract != null)
                    _logger.LogInformation(
                        ContractManagementLoggingEvents.DocumentMoveCommandNotSent,
                        $"{nameof(DocumentMoveCommand)} NOT sent for MasterContractNumber:{masterContract.contractNumber} ContractNumber:{childContractNumber} because CRM did not return a contract.");

                return false;
            }

            return true;
        }

        private async Task PublishContractReadyToPublishEvent(contract masterContract, ContractApprovalType approvalType, IMessageHandlerContext context)
        {
            await context.Publish(new ContractReadyToPublishEvent
            {
                CorporateContract = masterContract,
                ContractApprovalType = approvalType
            }).ConfigureAwait(false);

            _logger.LogInformation(
                ContractManagementLoggingEvents.PublishContractReadyToPublishEventPublished,
                $"{nameof(ContractReadyToPublishEvent)} published for MasterContractNumber:{masterContract.contractNumber}");

        }

        private void UpdateContractStatus(contractType childContract, ConnectionInfo connectionInfo)
        {
            // Get Now DateTime, real or override
            DateTime publishedDate = _dateProvider.GetDate(connectionInfo);

            // Note: Using the type of the v10 corporate schema
            string status = contractStatusTypeStatus
                .PublishedToProvider.ToString();

            // Update Corporate Contract with Published info
            childContract.StatusLastUpdatedDate = publishedDate;
            childContract.contractStatus.status = status;
        }

        private async Task MoveContract(contract masterContract, string contractNumber, IMessageHandlerContext context)
        {
            contractType childContract = GetChildContract(masterContract, contractNumber);
            DocumentMoveCommand documentMoveCommand = new DocumentMoveCommand
            {
                CorporateContract = masterContract,
                ContractNumberToBeMoved = contractNumber,
                ContractApprovalType = _fundingTypeFundingPeriodService.GetApprovalType(
                    fundingTypeCode: childContract.fundingType.fundingTypeCode,
                    fundingPeriodName: childContract.GetFundingPeriod())
            };

            await context.Send(documentMoveCommand).
                ConfigureAwait(false);

            _logger.LogInformation(
                ContractManagementLoggingEvents.DocumentMoveCommandSent,
                $"{nameof(DocumentMoveCommand)} sent for MasterContractNumber:{masterContract.contractNumber} ContractNumber:{contractNumber}");
        }

        private static bool DoesContractNeedToBeMoved(contractType childContract)
        {
            return childContract.DocumentationRequired != null && childContract.DocumentationRequired.Value;
        }

        private static contractType GetChildContract(contract masterContract, string contractNumber)
        {
            return masterContract.contracts.SingleOrDefault(c => c.contractNumber == contractNumber);
        }
    }
}
