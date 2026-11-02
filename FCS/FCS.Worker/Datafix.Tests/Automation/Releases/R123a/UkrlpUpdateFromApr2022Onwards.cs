namespace Datafix.Tests.Automation.Releases.R123a
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Datafix.Tests.Repositories;
    using Moq;
    using OrganisationDomain.Implementation.Services;
    using OrganisationDomain.Integration.Messages.Commands;
    using OrganisationDomain.Integration.Messages.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;
    using OrganisationDomain.Integration.MainEndpoint.Extensions;
    using Services;
    using NServiceBus;

    public class UkrlpUpdateFromApr2022Onwards : IApplyDataFix
    {
        public string Release => "R123a";
        public int StoryNumber => 37445;
        public string Name => "Provider address not updated for UKPRN 10000488 (37445)";
        public int Order => 1;
        public void ApplyDataFix()
        {
            string ukrlpServiceUrl = ConfigurationManager.AppSettings["UkrlpService:Url"];
            const int batchSize = 200;
            OrgSupplementaryDataService service =
                new OrgSupplementaryDataService(Mock.Of<ILogger>());

            var supplementaryDataChanges = service.GetSupplementaryDataChanges(-120).Result;

            var currentUkprns = OrganisationRepository.GetUkprnsInOrgTable();
            supplementaryDataChanges = supplementaryDataChanges.Where(s => currentUkprns.Contains(s.Ukprn)).ToList();

            List<OrgSupplementaryDataDto> supplementaryDataDtos = supplementaryDataChanges.Select(sdc =>
                new OrgSupplementaryDataDto
                {
                    Ukprn = sdc.Ukprn,
                    CompanyNumber = sdc.CompanyNumber,
                    CharityNumber = sdc.CharityNumber,
                    LegalAddress = sdc.LegalAddress.ToDtoAddress()
                }).ToList();


            var commands = supplementaryDataDtos.Batch(batchSize)
                .Select(batch => new UpdateSupplementaryBatchOfDataCommand { OrgSupplementaryDataCollection = batch.ToList() });

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<UpdateSupplementaryBatchOfDataCommand>();
            var sendTasks = commands.Select(c => endpoint.Send("OrgService.Main", c));
            
            Task.WhenAll(sendTasks).Wait();
        }
    }
}
