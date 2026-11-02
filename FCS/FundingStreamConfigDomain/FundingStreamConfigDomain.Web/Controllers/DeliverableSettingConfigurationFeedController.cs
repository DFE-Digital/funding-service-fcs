namespace SFA.FCT.FundingPolicyDomain.Controllers
{
    using System.Web.Http;
    using Attributes;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.Atom.EntryContent;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Entities;

    [Authorize]
    [SecureResource]
    [RoutePrefix(RoutePrefix)]
    public class DeliverableSettingConfigurationFeedController : AtomFeedController<DeliverableSettingConfiguration, DeliverableSettingConfigurationEntryContent>
    {
        public const string RoutePrefix = "api/funding-policies/deliverables/settings";
        public const string RouteSuffix = "notifications/changes";

        public DeliverableSettingConfigurationFeedController(
            IPagedStorageRepository<DeliverableSettingConfiguration> repository,
            IAtomFeedGenerator<DeliverableSettingConfiguration> atomFeedGenerator)
            : base(repository, atomFeedGenerator, RoutePrefix, RouteSuffix)
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
        public override IHttpActionResult GetPage(int pageRef)
        {
            return base.GetPage(pageRef);
        }

        [Route(RouteSuffix)]
        [HttpGet]
        public override IHttpActionResult GetLatestPage()
        {
            return base.GetLatestPage();
        }
    }
}