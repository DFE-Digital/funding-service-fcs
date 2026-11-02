namespace SFA.FCT.ContractManagementService.Controllers.FundingConfigService
{
    using CrossDomain.Integration.Entities;
    using FCS.Worker.Common;
    using global::ContractManagementService.AtomFeed.EntryContent;
    using global::ContractManagementService.Repositories;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using System.Threading.Tasks;

    [Authorize]
    [ApiController]
    [Route(RoutePrefix)]
    public class DeliverableSettingConfigurationFeedController : AtomFeedController<DeliverableSettingConfiguration, DeliverableSettingConfigurationEntryContent>
    {
        public const string RoutePrefix = "api/funding-policies/deliverables/settings";
        public const string RouteSuffix = "notifications/changes";

        public DeliverableSettingConfigurationFeedController(
            IPagedStorageQueryRepository<DeliverableSettingConfiguration> repository,
            SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<DeliverableSettingConfiguration> atomFeedGenerator,
            IFcsConfiguration configuration)
            : base(repository, atomFeedGenerator, RoutePrefix, RouteSuffix, configuration)
        {
        }

        protected override string FeedTitle
        {
            get { return "Funding Stream Deliverables Settings Changes"; }
        }

        protected override string FeedAuthor
        {
            get { return "Funding Stream Config Service"; }
        }

        [Route(RouteSuffix + "/{pageRef}")]
        [HttpGet]
        public override async Task<ActionResult> GetPage(int pageRef)
        {
            return await base.GetPage(pageRef);
        }

        [Route(RouteSuffix)]
        [HttpGet]
        public override async Task<ActionResult> GetLatestPage()
        {
            return await base.GetLatestPage();
        }
    }
}