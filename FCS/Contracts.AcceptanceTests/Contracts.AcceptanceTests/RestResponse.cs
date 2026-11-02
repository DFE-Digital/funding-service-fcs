using System;
using System.Net;

namespace SFA.FCT.Contracts.AcceptanceTests
    public class RestResponse
    {
        public HttpStatusCode StatusCode { get; set; }

        public string Value { get; set; }
    }
}
