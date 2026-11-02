namespace Operations.Web.Dtos
{
    using System;
    using System.Net;
    using System.Net.Http;

    public class HttpResult
    {
        public bool IsSuccess { get; set; }


        public string Message { get; set; }
    }
}