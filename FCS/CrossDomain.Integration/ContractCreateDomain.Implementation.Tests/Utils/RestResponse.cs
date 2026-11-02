using System.Net;

namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.Utils
{
    public class RestResponse
    {
        public HttpStatusCode StatusCode { get; set; }

        public string Value { get; set; }
    }
}
