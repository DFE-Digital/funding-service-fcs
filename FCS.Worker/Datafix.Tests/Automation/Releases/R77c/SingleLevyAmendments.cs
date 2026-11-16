namespace Datafix.Tests.Automation.Releases.R77c
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
        public string Release => "R77c";
        public int StoryNumber => 28975;
        public string Name => "Issue 22 further Apps provider agreement variations (28975)";
        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            IReadOnlyCollection<string> ukprnsToBeAmended = new List<string>
            {
                "10025390",
                "10020884",
                "10061461",
                "10048290",
                "10041236",
                "10024320",
                "10029332",
                "10045955",
                "10061832",
                "10057497",
                "10053529",
                "10018297",
                "10013658",
                "10054584",
                "10005588",
                "10061102",
                "10020244",
                "10029981",
                // "10042119", we run this guy in the next release
                "10027599",
                "10003317",
                "10034044",
                "10041165"
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
