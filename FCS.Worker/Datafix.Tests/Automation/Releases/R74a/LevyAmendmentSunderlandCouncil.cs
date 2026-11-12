namespace Datafix.Tests.Automation.Releases.R74a
{
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public class LevyAmendmentSunderlandCouncil : IApplyDataFix
    {
        public string Release => "R74a";
        public int StoryNumber => 28291;
        public string Name => "Issue a Levy amendment for Sunderland City Council";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            const string ukprn = "10006407";
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            IReadOnlyCollection<ContractInformation> allLevyContracts =
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);
            var levyContractsForUkprns = allLevyContracts.Where(c => c.Ukprn == ukprn).ToList();

            Assert.AreEqual(1, levyContractsForUkprns.Count, "There should only be one contract");

            levyContractsForUkprns.ForEach(c =>
            {
                endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                {
                    ContractInformation = c,
                    AmendmentType = AmendmentType.Variation,
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                    ShouldAddPayableNonLevyAllocation = false,
                }).Wait();
            });
        }
    }
}
