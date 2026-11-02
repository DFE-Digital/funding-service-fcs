namespace SFA.FCT.ContractManagementService
{
    using System;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using FundingStreamConfigDomain.Web.Controllers;

    public class AtomMediaTypeFilterHandler : DelegatingHandler
    {
        public const string XmlMediaType = "APPLICATION/XML"; 

        private readonly string[] atomUrlPortions =
        {
            FundingPolicyController.RoutePrefix
        };

        public static readonly string[] SupportedMediaTypes =
        {
            "APPLICATION/ATOM+XML",
            "APPLICATION/VND.SFA.CONTRACT.1+ATOM+XML"
        };

        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            if (IsUrlRestrictedToAtomMediaTypes(request.RequestUri.AbsolutePath))
            {
                // the call is for a url that will return an Atom Feed, we need to check the media type
                if (!IsThereARequestMediaTypeThatIsAllowed(request))
                {
                    // we do not accept this media type, tell the caller
                    var response = request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
                    return Task.FromResult(response);
                }
            }

            return base.SendAsync(request, cancellationToken);
        }

        private bool IsUrlRestrictedToAtomMediaTypes(string absolutePath)
        {
            return atomUrlPortions.Any(atomUrl => absolutePath.Contains(atomUrl));
        }

        private bool IsThereARequestMediaTypeThatIsAllowed(HttpRequestMessage request)
        {
            return
                SupportedMediaTypes.Any(
                    smt =>
                        request.Headers.Accept.Any(
                            headerMediaType =>
                                string.Compare(headerMediaType.MediaType.Trim(), smt, StringComparison.OrdinalIgnoreCase) ==
                                0));
        }
    }
}