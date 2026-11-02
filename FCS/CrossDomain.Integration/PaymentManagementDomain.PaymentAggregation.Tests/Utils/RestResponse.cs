namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Utils
{
    using System.Net;

    public class RestResponse
    {
        public HttpStatusCode StatusCode { get; set; }

        public string Value { get; set; }
    }
}
