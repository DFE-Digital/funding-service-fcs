namespace ContractCreateDomain.Endpoint.NonFinancialAmendment.Services
{
    using System;
    using System.Collections.Generic;
    using Infrastructure;
    using ContractManagement.DataStore.Model;
    using Dtos;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Validation;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class NonFinancialAmendmentValidationService : INonFinancialAmendmentValidationService
    {
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly IDate _dateProvider;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        public NonFinancialAmendmentValidationService(ICrmContractRepository crmContractRepository,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            IDate dateProvider)
        {
            _crmContractRepository = crmContractRepository;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _dateProvider = dateProvider;
        }

        public string IsValid(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo)
        {
            return ValidationHelper.GetFirstFailureMessageWhenValidationFails(GetMethodsWithErrorMessages(connectionInfo), contractIdentifier);
        }

        private ValidationResult IsContractApprovedWithValidSubStatus(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo)
        {
            string approvalErrorMessage = @"It must be in a status of ""Approved"" and a substatus of either ""Approved"", ""Modified"" or ""Under Termination""";

            string[] validSubstatuses = { "Approved", "Modified", "Under Termination" };

            bool isContractApproved = _crmContractRepository.IsContractApprovedWithSubstatus(contractIdentifier.ContractNumber,
                contractIdentifier.VersionNumber, contractIdentifier.SubVersionNumber, validSubstatuses);

            string errorMessage = isContractApproved ? string.Empty : approvalErrorMessage;

            return new ValidationResult(isContractApproved, errorMessage);
        }

        private ValidationResult IsContractOfAnAmendableFundingTypeFundingPeriod(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo)
        {
            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey =
                _crmContractRepository.GetFundingTypeFundingPeriodKeyForGivenContract(contractIdentifier.ContractNumber,
                    contractIdentifier.VersionNumber, contractIdentifier.SubVersionNumber);

            FundingTypeFundingPeriod fundingTypeFundingPeriod = 
                _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeFundingPeriodKey.FundingTypeCode, fundingTypeFundingPeriodKey.FundingPeriodName, connectionInfo);
            DateTime? contractActivityCloseDate = fundingTypeFundingPeriod.ContractingActivityCloseDate;

            if (fundingTypeFundingPeriod.DocumentsRequired == false || fundingTypeFundingPeriod.SkipDocumentMerge)
            {
                return
                    new ValidationResult(false,
                    GenerateAmendmentCannotBeCreatedErrorMessage(fundingTypeFundingPeriod.FundingTypeCode,
                        fundingTypeFundingPeriodKey.FundingPeriodName));
            }

            if (contractActivityCloseDate.HasValue && _dateProvider.GetCalculationDate() > contractActivityCloseDate.Value)
            {
                return
                    new ValidationResult(false,
                        GenerateContractingActivityClosedErrorMessage(fundingTypeFundingPeriod.FundingTypeCode,
                            fundingTypeFundingPeriod.FundingPeriodName));
            }

            return new ValidationResult(true, string.Empty);
        }

        private ValidationResult IsThereNoSubsequentDraftContracts(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo)
        {
            bool isThereNoSubsequentDraftContracts = _crmContractRepository.IsThereNoSubsequentDraftContracts(contractIdentifier.ContractNumber,
                contractIdentifier.VersionNumber, contractIdentifier.SubVersionNumber);

            if (isThereNoSubsequentDraftContracts)
            {
                return new ValidationResult(true, string.Empty);
            }
            return new ValidationResult(false, "A draft amendment already exists");
        }

        private ValidationResult HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo)
        {
            var fundingTypeFundingPeriodKey = _crmContractRepository.GetFundingTypeFundingPeriodKeyForGivenContract(
                contractIdentifier.ContractNumber,
                contractIdentifier.VersionNumber,
                contractIdentifier.SubVersionNumber);
            
            var includeAllContractsOnSummaryOfFunding = _fundingTypeFundingPeriodQueryRepository.Get(
                    fundingTypeFundingPeriodKey.FundingTypeCode,
                    fundingTypeFundingPeriodKey.FundingPeriodName,
                    connectionInfo)
                .IncludeAllContractsOnSummaryOfFunding;

            if (includeAllContractsOnSummaryOfFunding)
            {
                if (_crmContractRepository.HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(contractIdentifier.ContractNumber))
                {
                    return new ValidationResult(false,
                        "A draft amendment already exists (or has been initiated) for another contract associated with this Master Contract");
                }
            }

            return new ValidationResult(true, string.Empty);
        }

        private string GenerateAmendmentCannotBeCreatedErrorMessage(string fundingTypeCode, string fundingPeriod)
        {
            return $"Non-financial amendments cannot be created for {fundingTypeCode} {fundingPeriod} contracts";
        }

        private string GenerateContractingActivityClosedErrorMessage(string fundingTypeCode, string fundingPeriod)
        {
            return $"Contracting activity has closed for {fundingTypeCode} {fundingPeriod} contracts";
        }

        private IReadOnlyCollection<MethodWithErrorResult> GetMethodsWithErrorMessages(ConnectionInfo connectionInfo)
        {
            return new List<MethodWithErrorResult>
            {
                new MethodWithErrorResult(ci => IsContractOfAnAmendableFundingTypeFundingPeriod(ci, connectionInfo)),
                new MethodWithErrorResult(ci => IsContractApprovedWithValidSubStatus(ci, connectionInfo)),
                new MethodWithErrorResult(ci => IsThereNoSubsequentDraftContracts(ci, connectionInfo)),
                new MethodWithErrorResult(ci => HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(ci, connectionInfo))
            };
        }
    }
}
