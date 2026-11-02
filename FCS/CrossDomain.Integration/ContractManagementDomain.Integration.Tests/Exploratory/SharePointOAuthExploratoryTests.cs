
namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Exploratory
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json.Linq;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;

    [TestClass]
    public class SharePointOAuthExploratoryTests
    {
        const string TenantId = "fad277c9-c60a-4da1-b5f3-b3b8b34a82f9";
        const string ClientId = "ReplaceClientIdfortest";               //replace with actual client ID for testing, consider using secure storage for real tests
        const string ClientSecret = "ReplaceClientSecretfortest";       //Replace with actual secret for testing, consider using secure storage for real tests
        const string SharePointHost = "educationgovuk.sharepoint.com";
        const string SitePath = "/sites/fct-dat/";       //place corresponding environment site path for testing
        const string LibraryName = "TestMSGraphSP";
        const string LibraryDisplayName = "Processed";

        [TestMethod, TestCategory("TechnicalExploration")]
        public async Task ShouldCreateDocumentLibraryWithGraph()
        {

            string accessToken = await GetGraphAccessTokenAsync(TenantId, ClientId, ClientSecret);

            // Resolve site ID
            string siteId = await ResolveSiteIdAsync(SharePointHost, SitePath, accessToken);

            // Create library (idempotent)
            bool created = await CreateDocumentLibraryAsync(siteId, LibraryName, accessToken);

            Assert.IsTrue(created, $"Document library '{LibraryName}' was not created.");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public async Task ShouldConnectWithGraphAndRetrieveListOfFiles_DAT()
        {
            string accessToken = await GetGraphAccessTokenAsync(TenantId, ClientId, ClientSecret);

            List<string> filenames = await GetLibraryFileNamesAsync(
                SharePointHost, SitePath, LibraryDisplayName, accessToken);

            Assert.IsTrue(filenames.Any(), $"No files found in '{LibraryDisplayName}' at {SharePointHost}{SitePath}.");
        }

        private static async Task<string> GetGraphAccessTokenAsync(
            string tenantId, string clientId, string clientSecret)
        {
            var http = new HttpClient();

            var form = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string,string>("client_id", clientId),
                new KeyValuePair<string,string>("client_secret", clientSecret),
                new KeyValuePair<string,string>("grant_type", "client_credentials"),
                new KeyValuePair<string,string>("scope", "https://graph.microsoft.com/.default")
            });

            var resp = await http.PostAsync(
                $"https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/token", form);

            resp.EnsureSuccessStatusCode();

            var json = JObject.Parse(await resp.Content.ReadAsStringAsync());
            return (string)json["access_token"];
        }

        private static async Task<string> ResolveSiteIdAsync(
            string sharePointHost, string sitePath, string accessToken)
        {
            var http = new HttpClient();
            http.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", accessToken);

            var resp = await http.GetAsync(
                $"https://graph.microsoft.com/v1.0/sites/{sharePointHost}:{sitePath}");

            resp.EnsureSuccessStatusCode();

            var json = JObject.Parse(await resp.Content.ReadAsStringAsync());
            var siteId = (string)json["id"];
            if (string.IsNullOrEmpty(siteId))
                throw new InvalidOperationException($"Site not found: {sharePointHost}{sitePath}");

            return siteId;
        }

        private static async Task<bool> CreateDocumentLibraryAsync(
            string siteId, string libraryName, string accessToken)
        {
            var http = new HttpClient();
            http.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", accessToken);

            // Step 1 — Check if library exists
            var checkResp = await http.GetAsync(
                $"https://graph.microsoft.com/v1.0/sites/{siteId}/lists?$select=id,displayName");

            checkResp.EnsureSuccessStatusCode();

            var checkJson = JObject.Parse(await checkResp.Content.ReadAsStringAsync());

            bool exists = checkJson["value"]
                .Any(v => string.Equals((string)v["displayName"], libraryName, StringComparison.OrdinalIgnoreCase));

            if (exists)
                return true;

            // Step 2 — Create library
            var payload = new JObject
            {
                ["displayName"] = libraryName,
                ["list"] = new JObject
                {
                    ["template"] = "documentLibrary"
                }
            };

            var content = new StringContent(payload.ToString(), Encoding.UTF8, "application/json");

            var createResp = await http.PostAsync(
                $"https://graph.microsoft.com/v1.0/sites/{siteId}/lists", content);

            if (!createResp.IsSuccessStatusCode)
            {
                var error = await createResp.Content.ReadAsStringAsync();
                throw new InvalidOperationException($"Failed to create library {libraryName}: {error}");
            }

            // Step 3 — Verify created
            var verifyResp = await http.GetAsync(
                $"https://graph.microsoft.com/v1.0/sites/{siteId}/lists?$select=id,displayName");

            verifyResp.EnsureSuccessStatusCode();

            var verifyJson = JObject.Parse(await verifyResp.Content.ReadAsStringAsync());

            return verifyJson["value"]
                .Any(v => string.Equals((string)v["displayName"], libraryName, StringComparison.OrdinalIgnoreCase));
        }

        private static async Task<List<string>> GetLibraryFileNamesAsync(
            string sharePointHost, string sitePath, string libraryDisplayName, string accessToken)
        {
            var http = new HttpClient();

            http.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", accessToken);
            http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            // Resolve site
            var siteResp = await http.GetAsync(
                $"https://graph.microsoft.com/v1.0/sites/{sharePointHost}:{sitePath}");

            siteResp.EnsureSuccessStatusCode();

            var siteJson = JObject.Parse(await siteResp.Content.ReadAsStringAsync());
            var siteId = (string)siteJson["id"];

            // Find drives (doc libs)
            var allDrives = new List<JToken>();
            string drivesUrl = $"https://graph.microsoft.com/v1.0/sites/{siteId}/drives?$select=id,name,webUrl,driveType";

            while (!string.IsNullOrEmpty(drivesUrl))
            {
                var drivesResp = await http.GetAsync(drivesUrl);
                drivesResp.EnsureSuccessStatusCode();

                var drivesJson = JObject.Parse(await drivesResp.Content.ReadAsStringAsync());
                var page = drivesJson["value"]?
                    .Where(d => (string)d["driveType"] == "documentLibrary")
                    ?? Enumerable.Empty<JToken>();

                allDrives.AddRange(page);

                drivesUrl = (string)drivesJson["@odata.nextLink"];
            }

            // Find matching library
            var processedDrive = allDrives.FirstOrDefault(
                d => string.Equals((string)d["name"], libraryDisplayName, StringComparison.OrdinalIgnoreCase));

            if (processedDrive == null)
                throw new InvalidOperationException($"Library '{libraryDisplayName}' not found.");

            string driveId = (string)processedDrive["id"];

            // Retrieve files
            var fileNames = new List<string>();
            string itemsUrl = $"https://graph.microsoft.com/v1.0/drives/{driveId}/root/children?$select=name,file";

            while (!string.IsNullOrEmpty(itemsUrl))
            {
                var itemsResp = await http.GetAsync(itemsUrl);
                itemsResp.EnsureSuccessStatusCode();

                var itemsJson = JObject.Parse(await itemsResp.Content.ReadAsStringAsync());

                fileNames.AddRange(
                    itemsJson["value"]
                        .Where(i => i["file"] != null)
                        .Select(i => (string)i["name"])
                );

                itemsUrl = (string)itemsJson["@odata.nextLink"];
            }

            return fileNames;
        }
    }
}
