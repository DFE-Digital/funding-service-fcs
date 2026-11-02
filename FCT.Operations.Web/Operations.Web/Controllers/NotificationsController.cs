namespace Operations.Web.Controllers
{
    using System.Threading.Tasks;
    using System.Web.Http;
    using Services;

    [RoutePrefix("fcs-notifications")]
    public class NotificationsController : ApiController
    {
        private readonly INotificationsService _notificationsService;

        public NotificationsController(INotificationsService notificationsService)
        {
            _notificationsService = notificationsService;
        }

        [HttpGet, Route]
        public async Task<IHttpActionResult> GetNotifications()
        {
            return Ok(await _notificationsService.GetNotifications());
        }
    }
}
