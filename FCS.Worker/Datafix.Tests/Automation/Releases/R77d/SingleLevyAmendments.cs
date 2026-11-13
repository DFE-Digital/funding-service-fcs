namespace Datafix.Tests.Automation.Releases.R77d
{
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public class SingleLevyAmendments : IApplyDataFix
    {
        public string Release => "R77d";
        public int StoryNumber => 28975;
        public string Name => "Issue 1 further Apps provider agreement variations (28975)";
        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            IReadOnlyCollection<string> ukprnsToBeAmended = new List<string>
            {
                "10042119" // Aim 2 Learn Ltd
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
                        AmendmentType = AmendmentType.Variation,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                        ShouldAddPayableNonLevyAllocation = true,
                        AllowUnderTermination = true
                    }).Wait();
                });
        }
    }
}
