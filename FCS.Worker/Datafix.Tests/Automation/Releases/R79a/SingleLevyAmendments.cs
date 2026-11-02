namespace Datafix.Tests.Automation.Releases.R79a
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
        public string Release => "R79a";
        public int StoryNumber => 29106;
        public string Name => "Issue 5 further Apps provider agreement variations (29106)";
        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            IReadOnlyCollection<string> ukprnsToBeAmended = new List<string>
            {
                "10008379", // London College of Business and Law Limited
                "10055821", // The Electronics Group Limited
                "10036202", // FLT Training (Liverpool)
                "10046346", // Holt Green Training Ltd
                "10053742"  // KHK People and Development
            };

            bool IsUkprnToBeAmended(ContractInformation c) => ukprnsToBeAmended.Contains(c.Ukprn);

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            IReadOnlyCollection<ContractInformation> allLevyContracts = 
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);

            allLevyContracts
                .Where(IsUkprnToBeAmended)
                .ToList()
                .ForEach(c =>
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
