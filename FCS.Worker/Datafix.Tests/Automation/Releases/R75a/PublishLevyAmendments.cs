namespace Datafix.Tests.Automation.Releases._75a
{
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using NServiceBus;
    using Optional;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public class PublishLevyAmendments //: IApplyDataFix
    {
        public string Release => "R75a";
        public int StoryNumber => 28513;
        public string Name => "Publish v2 amendments for 8 Levy agreements";
        public int Order => 1;
        public void ApplyDataFix()
        {
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();

            IReadOnlyCollection<SimpleContract> simpleContracts = new List<SimpleContract>
            {
                new SimpleContract(10003398, "APPLEVY-1677"),
                new SimpleContract(10019711, "APPLEVY-2776"),
                new SimpleContract(10026993, "APPLEVY-3102"),
                new SimpleContract(10028919, "APPLEVY-1542"),
                new SimpleContract(10030099, "APPLEVY-1620"),
                new SimpleContract(10031131, "APPLEVY-1633"),
                new SimpleContract(10044025, "APPLEVY-2600"),
                new SimpleContract(10061865, "APPLEVY-2555")
            };

            IReadOnlyCollection<Option<AmendLevyContractCommand>> commandOptions = simpleContracts.Select(MapToAmendLevyContractCommand).ToList();

            commandOptions.ToList().ForEach(commandOption =>
            {
                commandOption.MatchSome(command =>
                {
                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", command).Wait();
                });
            });
        }

        private Option<AmendLevyContractCommand> MapToAmendLevyContractCommand(SimpleContract simpleContract)
        {
            var approvedContractOption =
                ApprovedContractRepository.GetApprovedContractIfItExists(simpleContract.ContractNumber,
                    simpleContract.Ukprn);

            return approvedContractOption.Match(
                some: c => Option.Some(new AmendLevyContractCommand
                {
                    ContractInformation = new ContractInformation(
                        c.ContractNumber,
                        c.MasterContractNumber,
                        c.ContractVersionNumber,
                        c.ContractSubVersionNumber,
                        c.Ukprn.ToString(),
                        ContractStatus.Approved,
                        ContractSubStatus.Approved),
                    AmendmentType = AmendmentType.Variation,
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                    ShouldAddPayableNonLevyAllocation = false
                }),
                none: Option.None<AmendLevyContractCommand>);
        }

        private class SimpleContract
        {
            public SimpleContract(int ukprn, string contractNumber)
            {
                Ukprn = ukprn;
                ContractNumber = contractNumber;
            }

            public int Ukprn { get; }

            public string ContractNumber { get; }
        }
    }
}
