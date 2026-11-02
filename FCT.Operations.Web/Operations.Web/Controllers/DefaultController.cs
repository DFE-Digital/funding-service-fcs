namespace Operations.Web.Controllers
{
    using System.Web.Http;

    public class DefaultController : ApiController
    {
        [Route("test")]
        [HttpGet]
        public IHttpActionResult Get()
        {
            return Ok();
        }
    }
}
