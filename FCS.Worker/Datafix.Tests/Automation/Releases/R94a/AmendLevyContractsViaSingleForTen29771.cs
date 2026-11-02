namespace Datafix.Tests.Automation.Releases.R94a
{
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class AmendLevyContractsViaSingleForTenUkprns29771 : IApplyDataFix
    {
        private static readonly IReadOnlyCollection<int> UkprnsToAmendViaSingle = new List<int>
            {
                10044749    ,       //	APPLEVY-5441	THE BUSINESS PORTFOLIO (UK) LIMITED Approved Under Termination
                10024415    ,       //	APPLEVY-5569	KEYSTONE TRAINING LTD  Approved Under Termination
                10029974    ,       //	APPLEVY-5975	RITA'S TRAINING SERVICES Approved Under Termination
                10027935    ,       //	APPLEVY-5993	PROSPECTS TRAINING INTERNATIONAL LIMITED Approved Under Termination
                10008947    ,       //	APPLEVY-6142	MANATEC LIMITED Approved Under Termination
                10034315    ,       //	APPLEVY-6147	LIGA (UK) LTD Approved Under Termination
                10003717    ,       //	APPLEVY-6148	KPMG LLP Approved Under Termination
                10001041    ,       //	APPLEVY-6229	GLOUCESTERSHIRE ENTERPRISE LIMITED Approved Under Termination
                10038872    ,       //	APPLEVY-6349	GENIUS SOFTWARE SOLUTIONS LIMITED Approved Under Termination
                10034001    ,       //	APPLEVY-6524	ASHLEY HUNTER LTD Approved Under Termination
            };

        public string Release => "R94a";

        public int StoryNumber => 29771;

        public string Name => "Amend Levy Contracts Via Single For Ten UKPRNs";

        public int Order => 3;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            IReadOnlyCollection<ContractInformation> allLevyContracts =
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);

            SendSingleLevyAmendments(endpoint, allLevyContracts);
        }

        private static void SendSingleLevyAmendments(IEndpointInstance endpoint, IReadOnlyCollection<ContractInformation> allLevyContracts)
        {
            bool IsInSingleList(ContractInformation c)
            {
                return UkprnsToAmendViaSingle.Contains(int.Parse(c.Ukprn));
            }

            allLevyContracts
                .Where(IsInSingleList)
                .ToList()
                .ForEach(c =>
                {
                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                    {
                        ContractInformation = c,
                        AmendmentType = SFA.FCT.ContractManagementService.Common.AmendmentType.Variation,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                        ShouldAddPayableNonLevyAllocation = false,
                        AllowUnderTermination = true
                    }).Wait();
                });
        }
    }
}