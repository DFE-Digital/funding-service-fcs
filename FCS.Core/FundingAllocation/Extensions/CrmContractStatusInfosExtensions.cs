namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dto;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public static class CrmContractStatusInfosExtensions
    {
        private static readonly IReadOnlyCollection<string> AllowedSubStatusForUpdateDraftAmendment =
            new List<string> {"Awaiting Documentation", "In Review"};

        private static readonly IReadOnlyCollection<string> AllowedSubStatusForUpdateDraft =
            new List<string>(AllowedSubStatusForUpdateDraftAmendment) {"Unassigned"};

        private static readonly IReadOnlyCollection<string> AllowedSubStatusForAmendment =
            new List<string> { "Approved", "Under Termination", "Modified" };

        private static readonly List<ContractIntent> IntentsThatCanBeOverridenByRule = new List<ContractIntent>
        {
            ContractIntent.NewAmendment,
            ContractIntent.New,
            ContractIntent.RevisedNew,
            ContractIntent.Amendment
        };

        public static ContractIntent GetIntent(
            this IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos, IntentFundingTypeFundingPeriod intentFundingTypeFundingPeriod,
            string currentFundingPeriod, IReadOnlyCollection<ContractIdentity> contractIdentitiesToIgnoreWhenDerivingIntent, bool isInvokedViaDequeueEvent = false)
        {
            var intent = crmContractStatusInfos.GetInitialIntent(intentFundingTypeFundingPeriod, currentFundingPeriod, isInvokedViaDequeueEvent);

            return RunValidation(
                intent,
                crmContractStatusInfos,
                intentFundingTypeFundingPeriod.FtpGroupCode.HasValue(),
                contractIdentitiesToIgnoreWhenDerivingIntent);
        }

        public static bool AreThereAnyOtherDraftContractsInTheSystem(this IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos, IEnumerable<ContractIdentity> contractIdentitiesToIgnore)
        {
            var filteredCrmContractStatusInfos = crmContractStatusInfos.Where(c =>
            {
                return contractIdentitiesToIgnore.NotAny(contractToIgnore =>
                    contractToIgnore.ContractNumber == c.Number &&
                    contractToIgnore.VersionNumber == c.Version &&
                    contractToIgnore.SubVersionNumber ==
                    c.SubVersion);
            });

            return filteredCrmContractStatusInfos.Any(c => c.IsDraft);
        }

        public static bool IsDadaFundingType(this IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos)
        {
            return crmContractStatusInfos.All(c => c.FundingType == "DADA");
        }

        public static CrmContractStatusInfo GetBlockedOnContractForMultiYear(this IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos, string currentFundingPeriodCode)
        {
            var currentPeriodBlockedOnContract = crmContractStatusInfos.FirstOrDefault(c =>
                c.FundingPeriod == currentFundingPeriodCode && c.SubStatus != "Approved");
            if (currentPeriodBlockedOnContract != null)
            {
                return currentPeriodBlockedOnContract;
            }

            var contractsOrderedByOldestFirst = crmContractStatusInfos.Where(c => c.LatestVersion)
                .OrderBy(c => int.Parse(c.FundingPeriod[2..])).ToList();

            return contractsOrderedByOldestFirst
                .First(c => c.SubStatus != "Approved");
        }

        public static void UpdateStatusSubStatusWhereFound(this IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos,
            IReadOnlyCollection<ContractAndStatus> overrideStatuses)
        {
            overrideStatuses.ToList().ForEach(overrideStatus =>
            {
                var matchCrmContract = crmContractStatusInfos.SingleOrDefault(ccsi =>
                    ccsi.Number == overrideStatus.ContractIdentity.ContractNumber &&
                    ccsi.Version == overrideStatus.ContractIdentity.VersionNumber &&
                    ccsi.SubVersion == overrideStatus.ContractIdentity.SubVersionNumber
                );

                if (matchCrmContract != null)
                {
                    matchCrmContract.Status = overrideStatus.Status;
                    matchCrmContract.SubStatus = overrideStatus.SubStatus;
                }
            });
        }

        public static async Task<CrmContractInfo> GetExistingCrmContractInfo(
            this IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos,
            int ukprn,
            ContractIntent contractIntent,
            string fundingPeriod,
            Func<string, Task<IReadOnlyCollection<CrmAllocationInfo>>> getCrmAllocationInfos)
        {
            CrmContractStatusInfo latestCrmContractStatusInfo;
            if (contractIntent == ContractIntent.RevisedNew)
            {
                latestCrmContractStatusInfo = crmContractStatusInfos.OrderByDescending(ccsi => ccsi.CreatedDate).First();
            }
            else if (contractIntent == ContractIntent.Queue)
            {
                if (crmContractStatusInfos.IsDadaFundingType())
                {
                    // this is a multi year so we need to find the one we are blocked on
                    latestCrmContractStatusInfo = crmContractStatusInfos.GetBlockedOnContractForMultiYear(fundingPeriod);
                }
                else
                {
                    latestCrmContractStatusInfo =
                        crmContractStatusInfos.Single(c => c.FundingPeriod == fundingPeriod && c.LatestVersion);
                }
            }
            else if (contractIntent == ContractIntent.NewAmendment && crmContractStatusInfos.IsDadaFundingType())
            {
                latestCrmContractStatusInfo = crmContractStatusInfos.OrderByDescending(ccsi => ccsi.CreatedDate).First();
            }
            else
            {
                latestCrmContractStatusInfo = crmContractStatusInfos.First(crmInfo => crmInfo.LatestVersion);
            }

            var crmAllocationInfos = await getCrmAllocationInfos(latestCrmContractStatusInfo.CrmEntityId);

            var latestOverallVersionNumber = crmContractStatusInfos.OrderByDescending(ccsi => ccsi.CreatedDate).First().Version;

            return new CrmContractInfo(latestCrmContractStatusInfo.Number,
                latestCrmContractStatusInfo.Version,
                latestCrmContractStatusInfo.SubVersion,
                ukprn,
                latestCrmContractStatusInfo.CrmEntityId,
                latestCrmContractStatusInfo.MasterContractNumber,
                latestCrmContractStatusInfo.AmendmentType,
                crmAllocationInfos,
                latestOverallVersionNumber);

        }

        private static IEnumerable<string> GetAllowedSubStatusForAmendment(bool isInvokedViaDequeueEvent)
        {
            if (isInvokedViaDequeueEvent)
            {
                return AllowedSubStatusForAmendment.Concat(new List<string>
                {
                    "Awaiting Modification Approval",
                    "Modification Approval in Progress",
                    "Termination Initiation Approval in Progress"
                });
            }

            return AllowedSubStatusForAmendment;
        }

        private static ContractIntent GetInitialIntent(
            this IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos,
            IntentFundingTypeFundingPeriod intentFundingTypeFundingPeriod,
            string currentFundingPeriod,
            bool isInvokedViaDequeueEvent = false)
        {
            var currentFundingPeriodInfos = crmContractStatusInfos
                .Where(i => i.FundingPeriod == currentFundingPeriod)
                .ToList();


            var latestCrmContractStatusInfo = currentFundingPeriodInfos.SingleOrDefault(ccsi => ccsi.LatestVersion);

            if (currentFundingPeriodInfos.IsEmpty())
            {
                if (intentFundingTypeFundingPeriod.IsNewAmendment(crmContractStatusInfos))
                {
                    return ContractIntent.NewAmendment;
                }

                return ContractIntent.New;
            }

            if (currentFundingPeriodInfos.All(info => !info.LatestVersion))
            {
                return ContractIntent.RevisedNew;
            }
            if (latestCrmContractStatusInfo is {IsDraft: true} &&
                AllowedSubStatusForUpdateDraftAmendment.Contains(latestCrmContractStatusInfo.SubStatus) &&
                currentFundingPeriodInfos.Any(ccsi => ccsi.IsApproved))
            {
                return ContractIntent.UpdateDraftAmendment;
            }

            if (latestCrmContractStatusInfo is {IsDraft: true}
                && AllowedSubStatusForUpdateDraft.Contains(latestCrmContractStatusInfo.SubStatus))
            {
                return ContractIntent.UpdateDraft;
            }

            if (latestCrmContractStatusInfo is {IsApproved: true} &&
                GetAllowedSubStatusForAmendment(isInvokedViaDequeueEvent).Contains(latestCrmContractStatusInfo.SubStatus))
            {
                return ContractIntent.Amendment;
            }

            return ContractIntent.Queue;
        }

        private static ContractIntent RunValidation(
            ContractIntent intent,
            IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfo,
            bool hasFtpGroupCode, IReadOnlyCollection<ContractIdentity> contractsToIgnore)
        {
            if (IntentsThatCanBeOverridenByRule.Contains(intent) && hasFtpGroupCode && crmContractStatusInfo.AreThereAnyOtherDraftContractsInTheSystem(contractsToIgnore))
            {
                return ContractIntent.Queue;
            }

            return intent;
        }
    }
}