namespace Datafix.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public static class LevyAmendmentService
    {
        public static void AmendSingle(
            int ukprn,
            AmendmentType amendmentType,
            bool shouldAddPayableNonLevyAllocation,
            bool allowUnderTermination,
            bool shouldMergeAmendmentTemplate
            )
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            IReadOnlyCollection<string> ukprnsToBeAmended = new List<string>
            {
                ukprn.ToString()
            };

            bool IsUkprnToBeAmended(ContractInformation c) => ukprnsToBeAmended.Contains(c.Ukprn);

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            var allLevyContracts =
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType,
                    levyFundingPeriod);

            allLevyContracts.Where(IsUkprnToBeAmended)
                .ToList().ForEach(c =>
                {
                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                    {
                        ContractInformation = c,
                        AmendmentType = amendmentType,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                        ShouldAddPayableNonLevyAllocation = shouldAddPayableNonLevyAllocation,
                        AllowUnderTermination = allowUnderTermination,
                        ShouldMergeAmendmentTemplate = shouldMergeAmendmentTemplate
                    }).Wait();
                });
        }

        public static void AmendMultiple(
            IEnumerable<string> ukprns,
            AmendmentType amendmentType,
            bool shouldAddPayableNonLevyAllocation,
            bool allowUnderTermination,
            bool shouldMergeAmendmentTemplate
            )
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            var allLevyContracts =
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType,
                    levyFundingPeriod);

            var levyContractsToUpdate = allLevyContracts.Where(c => ukprns.Contains(c.Ukprn)).ToList();

            levyContractsToUpdate.ForEach(c =>
                {
                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                    {
                        ContractInformation = c,
                        AmendmentType = amendmentType,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                        ShouldAddPayableNonLevyAllocation = shouldAddPayableNonLevyAllocation,
                        AllowUnderTermination = allowUnderTermination,
                        ShouldMergeAmendmentTemplate = shouldMergeAmendmentTemplate
                    }).Wait();
                });
        }
    }
}
