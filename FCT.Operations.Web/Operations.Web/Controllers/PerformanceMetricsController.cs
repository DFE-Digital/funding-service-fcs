namespace Operations.Web.Controllers
{
    using System.Threading.Tasks;
    using System.Web.Http;

    [RoutePrefix("metrics")]
    public class PerformanceMetricsController
    {
        public Task<IHttpActionResult> GetMetrics()
        {
            return null;
        }
    }
}