namespace Datafix.Tests.Automation.Releases.R76c
{
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public class BulkLevyAmendments : IApplyDataFix
    {
        public string Release => "R76c";
        public int StoryNumber => 28392;
        public string Name => "NLA: Issue new Levy Ts&Cs (28392) [13-JAN]";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            IReadOnlyCollection<string> allowUnderTerminationAndNotOnRoatp = new List<string>
            {
                "10003398",
                "10007091",
                "10007097",
                "10019711",
                "10028919",
                "10031131",
                "10032648",
                "10036150",
                "10043784",
                "10044025",
                "10044252",
                "10049694",
                "10054505",
                "10054768",
                "10057068",
                "10058030",
                "10061152",
                "10061404",
                "10063562",
                "10064877",
                "10068400",
                "10082027",
                "10083445",
                "10083564",
                "10083757",
                "10083920",
                "10004727",
                "10005557",
                "10008155",
                "10043617",
                "10047671",
                "10061640",
                "10026650"
            };

            bool IsBulk(ContractInformation c) => !allowUnderTerminationAndNotOnRoatp.Contains(c.Ukprn);

            bool AllowUnderTerminationAndNotOnRoatp(ContractInformation c) => allowUnderTerminationAndNotOnRoatp.Contains(c.Ukprn);

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            var allLevyContracts =
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);

            allLevyContracts.Where(IsBulk)
                .ToList().ForEach(c =>
            {
                endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                {
                    ContractInformation = c,
                    AmendmentType = AmendmentType.Variation,
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk,
                    ShouldAddPayableNonLevyAllocation = true,
                    AllowUnderTermination = false
                }).Wait();
            });

            allLevyContracts.Where(AllowUnderTerminationAndNotOnRoatp)
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
