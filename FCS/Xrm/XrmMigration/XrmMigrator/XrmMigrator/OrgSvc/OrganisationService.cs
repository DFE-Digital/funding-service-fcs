namespace XrmMigrator.OrgSvc
{
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using Common;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class OrganisationService 
    {
        private const string XmlMediaType = "application/xml";
        
        public string OrganisationIdForUkprn(int ukprn)
        {
       
            var client = new HttpClient();
            organisation organisation = null;
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(XmlMediaType));
            var url = SettingsHelper.GetSettingvalue(SettingsHelper.Setting.OrgServiceUrl) + ukprn;
            var response = client.GetAsync(url);

            var content = response.Result.Content.ReadAsStringAsync();

            content.Wait();

            if (response.Result.IsSuccessStatusCode)
            {
                organisation = DeserializeXml(XElement.Parse(content.Result));
            }
            else
            {
                var errorMsg = string.Format("The Organisation Service has failed URL : {0} - Http Status Code {1}", url, response.Result.StatusCode);
                if (response.Result.StatusCode != HttpStatusCode.NotFound &&
                    response.Result.StatusCode != HttpStatusCode.BadRequest &&
                    response.Result.StatusCode != HttpStatusCode.InternalServerError)
                {
                    throw new HttpRequestException(errorMsg);
                }
            }

            return organisation.organisationId;
        }

        private organisation DeserializeXml(XElement contractXmlElement)
        {
            var serialzer = new XmlSerializer(typeof(organisation));
            return (organisation)serialzer.Deserialize(contractXmlElement.CreateReader());
        }
    }
}