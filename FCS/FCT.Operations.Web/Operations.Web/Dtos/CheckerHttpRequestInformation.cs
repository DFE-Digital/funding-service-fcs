namespace Operations.Web.Dtos
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http.Headers;
    using Enums;

    public class CheckerHttpRequestInformation
    {
        public ServiceInterface ServiceToCheck { get; }

        public string BaseUrl { get; }

        public string PageToCheck { get; }

        public AuthenticationRequest AuthenticationRequest { get; }

        public IReadOnlyCollection<MediaTypeWithQualityHeaderValue> VendorAtomMediaTypes { get;}

        public CheckerHttpRequestInformation(ServiceInterface serviceToCheck, string baseUrl, string pageToCheck, IReadOnlyCollection<MediaTypeWithQualityHeaderValue> vendorAtomMediaTypes, AuthenticationRequest ar)
        {
            AuthenticationRequest = ar;
            ServiceToCheck = serviceToCheck;
            BaseUrl = baseUrl;
            PageToCheck = pageToCheck;
            VendorAtomMediaTypes = vendorAtomMediaTypes;
        }

        public string GetServiceName()
        {
            return Enum.GetName(typeof (ServiceInterface), ServiceToCheck);
        }
    }
}