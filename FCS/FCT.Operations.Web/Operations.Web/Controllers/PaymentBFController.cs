using Operations.Web.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace Operations.Web.Controllers
{
    [RoutePrefix("fcs-payment-batch-feed-info")]
    public class PaymentBFController : ApiController
    {
        private readonly IPaymentBFItemQueryRepository _paymentBFItemQueryRepository;

        public PaymentBFController(IPaymentBFItemQueryRepository paymentBFItemQueryRepository)
        {
            _paymentBFItemQueryRepository = paymentBFItemQueryRepository;
        }

        [HttpGet, Route]
        public async Task<IHttpActionResult> GetPBFItems(string fundingStreamPeriod)
        {
            var items = await _paymentBFItemQueryRepository.GetItemByFundingStreamPeriod(fundingStreamPeriod)
                .ConfigureAwait(false);

            return Ok(items);
        }

        [HttpGet, Route("{id}")]
        public async Task<IHttpActionResult> GetContractXml(int id)
        {
            var xml = await _paymentBFItemQueryRepository.GetXmlForContract(id)
                .ConfigureAwait(false);

            return Ok(xml);
        }
    }
}