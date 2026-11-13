namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Implementation.Entities;
    using Implementation.Persistence;
    using MoreLinq;
    using Optional;
    using Validation.Rules;

    public class PreviousContractMerger : IPreviousContractMerger
    {
        private static readonly IReadOnlyCollection<Intent> AllowedIntents = new List<Intent> { Intent.UpdateDraft, Intent.UpdateDraftAmendment, Intent.Amendment };
        private static readonly IReadOnlyCollection<Intent> CopyAmendmentTypeIntents = new List<Intent> { Intent.UpdateDraftAmendment, Intent.Amendment };
        private static readonly IReadOnlyCollection<Intent> CopyAmendmentReasonIntents = new List<Intent> { Intent.UpdateDraftAmendment};
        private static readonly IReadOnlyCollection<Intent> LastVersionRequiredIntents = new List<Intent> { Intent.UpdateDraft, Intent.UpdateDraftAmendment};
        private static readonly string AmendmentNoLastApprovedVersionErrorMessage = ValidationRuleErrorMessages.ContractAmendmentMustHaveExistingApprovedContract;
        private const string UpdateDraftNoLatestVersionErrorMessage = "Cannot find matching draft contract to update";

        private readonly IPreviousContractRepository _previousContractRepository;

        public PreviousContractMerger(IPreviousContractRepository previousContractRepository)
        {
            _previousContractRepository = previousContractRepository;
        }

        public PreviousContractMergeResult MergeOptionalFieldsFromPreviousContract(contractRequestType contractRequest)
        {
            if (!AreIntentsSupported(contractRequest.contract.contracts.Select(c => c.CRMIntent).ToList()))
            {
                throw new ArgumentOutOfRangeException(nameof(contractRequest), @"An intent passed in is not supported");
            }

            IReadOnlyCollection<ContractWithPrevious> contractsWithPrevious = contractRequest.contract.contracts.Select(c =>
            {
                if (LastVersionRequiredIntents.Contains(c.CRMIntent))
                {
                    return new ContractWithPrevious(c, _previousContractRepository.GetLatestContract(c.contractNumber));
                }

                return new ContractWithPrevious(c, _previousContractRepository.GetLastApprovedContract(c.contractNumber));
            }).ToList();

            contractsWithPrevious.ForEach(c => MergePreviousIntoContractOrSetErrorInformation(c, contractRequest));

            PreviousContractMergeResult mergeResult = contractsWithPrevious.All(c => c.Previous.HasValue)
                ? PreviousContractMergeResult.PreviousContractMerged
                : PreviousContractMergeResult.PreviousContractNotFound;

            if (mergeResult == PreviousContractMergeResult.PreviousContractMerged)
            {
                UpdateMasterContractData(contractRequest.contract, contractsWithPrevious);
            }

            return mergeResult;
        }

        private static void UpdateMasterContractData(contractType masterContract, IReadOnlyCollection<ContractWithPrevious> contractsWithPrevious)
        {
            contractsWithPrevious.FirstOrDefault().SomeWhen(c => c != null)
                .MatchSome(c =>
                {
                    c.Previous.MatchSome(p =>
                    {
                        masterContract.startDate = masterContract.startDate ?? p.ContractStartDate;
                        masterContract.endDate = masterContract.endDate ?? p.ContractEndDate;
                        masterContract.amendmentType = masterContract.amendmentType != amendmentType.None
                            ? masterContract.amendmentType
                            : ParseAmendmentType(p.AmendmentType);
                    });
                });
        }

        private static bool AreIntentsSupported(IReadOnlyCollection<Intent> contractIntents)
        {
            return contractIntents.All(contractIntent => AllowedIntents.Contains(contractIntent));
        }

        private static void MergePreviousIntoContractOrSetErrorInformation(ContractWithPrevious contractWithPrevious, contractRequestType contractRequest)
        {
            contractType masterContract = contractRequest.contract;
            contractType contract = contractWithPrevious.Contract;

            contractWithPrevious.Previous.Match(
                some: prev =>
                {
                    contract.startDate = contract.startDate ?? prev.ContractStartDate;
                    contract.endDate = contract.endDate ?? prev.ContractEndDate;
                    contract.contractType1 = string.IsNullOrEmpty(contract.contractType1) ? prev.ContractType : contract.contractType1;
                    if (CopyAmendmentTypeIntents.Contains(contract.CRMIntent))
                    {
                        contract.amendmentType = contract.amendmentType != amendmentType.None ?
                            contract.amendmentType : ParseAmendmentType(prev.AmendmentType);
                    }
                    
                    masterContract.contractNumber = string.IsNullOrEmpty(masterContract.contractNumber) ? prev.MasterContractReferenceNumber : masterContract.contractNumber;
                    contract.description =  string.IsNullOrEmpty(contract.description) ? prev.ContractDescription : contract.description;
                    contractWithPrevious.Contract.contractAllocations.ForEach(a => 
                        MergePreviousIntoAllocation(
                            allocation: a, 
                            previousAllocation: prev.PreviousAllocations.FirstOrDefault(previousAlloc => previousAlloc.AllocationNumber == a.contractAllocationNumber).SomeWhen(p => p != null),
                            intent: contract.CRMIntent));
                },
                none: () =>
                {
                    contractRequest.AddError(new errorInfoType
                    {
                        correlationId = masterContract.correlationId,
                        level = errorInfoTypeLevel.Contract,
                        Value = contract.CRMIntent == Intent.Amendment ? AmendmentNoLastApprovedVersionErrorMessage : UpdateDraftNoLatestVersionErrorMessage,
                        Severity = ErrorSeverity.Standard
                    });
                });
        }

        private static amendmentType ParseAmendmentType(string amendmentType)
        {
            if (!string.IsNullOrEmpty(amendmentType))
            {
                return (amendmentType) Enum.Parse(typeof(amendmentType), amendmentType);
            }

            return CrossDomain.Integration.Entities.ContractRequest.amendmentType.None;
        }

        private static void MergePreviousIntoAllocation(contractAllocation allocation, Option<PreviousAllocation> previousAllocation, Intent intent)
        {
            previousAllocation.MatchSome(prev =>
            {
                allocation.startDate = allocation.startDate ?? prev.StartDate;
                allocation.endDate = allocation.endDate ?? prev.EndDate;
                allocation.fundingStreamCode = OverrideSourceIfNullOrEmpty(allocation.fundingStreamCode, prev.FundingStreamCode);
                allocation.fundingStreamPeriodCode = OverrideSourceIfNullOrEmpty(allocation.fundingStreamPeriodCode, prev.FundingStreamPeriodCode);
                allocation.LEPName = OverrideSourceIfNullOrEmpty(allocation.LEPName, prev.LepName);
                allocation.LEPCode = OverrideSourceIfNullOrEmpty(allocation.LEPCode, prev.LepCode);
                allocation.tenderSpecificationReference = OverrideSourceIfNullOrEmpty(allocation.tenderSpecificationReference, prev.TenderSpecReference);
                allocation.lotReference = OverrideSourceIfNullOrEmpty(allocation.lotReference, prev.LotReference);
                allocation.tenderAwardReference = OverrideSourceIfNullOrEmpty(allocation.tenderAwardReference, prev.TenderAwardReference);
                allocation.activityDescription = OverrideSourceIfNullOrEmpty(allocation.activityDescription, prev.ActivityDescription);
                allocation.description = OverrideSourceIfNullOrEmpty(allocation.description, prev.AllocationDescription);
                if (CopyAmendmentReasonIntents.Contains(intent))
                {
                    allocation.amendmentReason = OverrideSourceIfNullOrEmpty(allocation.amendmentReason, prev.AmendmentReason);
                }
                allocation.investmentPriority = OverrideSourceIfNullOrEmpty(allocation.investmentPriority, prev.InvestmentPriority);
                allocation.agreementNumber = OverrideSourceIfNullOrEmpty(allocation.agreementNumber, prev.AgreementNumber);
                allocation.specificationTitle = OverrideSourceIfNullOrEmpty(allocation.specificationTitle, prev.SpecificationTitle);
                allocation.regionType = OverrideSourceIfNullOrEmpty(allocation.regionType, prev.RegionType);
                allocation.learningRatePremium = OverrideSourceIfNullOrEmpty(allocation.learningRatePremium, prev.LearningRatePremium);
            });
        }

        private static string OverrideSourceIfNullOrEmpty(string source, string previousSource)
        {
            return string.IsNullOrEmpty(source) ? previousSource : source;
        }

        private class ContractWithPrevious
        {
            public ContractWithPrevious(contractType contract, Option<PreviousContract> previous)
            {
                Contract = contract;
                Previous = previous;
            }

            public contractType Contract { get; }

            public Option<PreviousContract> Previous { get; }
        }
    }
}