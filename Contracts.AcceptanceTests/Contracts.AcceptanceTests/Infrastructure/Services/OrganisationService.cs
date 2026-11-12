namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;

    public static class OrganisationService
    {
        static OrganisationService()
        {
            SetupOrganisationService();
        }

        public static HttpClient Connection { get; private set; }

        private static void SetupOrganisationService()
        {
            var orgServiceUri = TestConfiguration.Configuration["OrganisationService:Uri"];

            var client = new HttpClient
            {
                BaseAddress = new Uri(orgServiceUri)
            };

            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));

            Connection = client;
        }
    }
}