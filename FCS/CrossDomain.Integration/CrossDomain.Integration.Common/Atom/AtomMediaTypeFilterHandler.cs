namespace SFA.FCT.CrossDomain.Integration.Common.Atom
{
    using System;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;

    public class AtomMediaTypeFilterHandler : DelegatingHandler
    {
        public const string XmlMediaType = "APPLICATION/XML";

        private readonly MediaTypeFilterCriteria[] _filterCriteria;

        public AtomMediaTypeFilterHandler(MediaTypeFilterCriteria[] filterCriteria)
        {
            _filterCriteria = filterCriteria;
        }

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
            return _filterCriteria.Any(fc => absolutePath.Contains(fc.UrlPortion));
        }

        private bool IsThereARequestMediaTypeThatIsAllowed(HttpRequestMessage request)
        {
            var supportedMediaTypes =
                _filterCriteria
                .Where(fc => request.RequestUri.AbsolutePath.Contains(fc.UrlPortion))
                .SelectMany(fc => fc.SupportedMediaTypes);

            return supportedMediaTypes.Any(smt =>
                request.Headers.Accept.Any(hmt => string.Compare(hmt.MediaType.Trim(), smt, StringComparison.OrdinalIgnoreCase) == 0));
        }
    }
}
