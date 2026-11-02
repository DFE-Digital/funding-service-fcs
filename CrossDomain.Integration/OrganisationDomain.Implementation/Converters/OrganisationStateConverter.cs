namespace OrganisationDomain.Implementation.Converters
{
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Integration.Entities;

    public class OrganisationStateConverter : IOrganisationStateConverter
    {
        public List<OrganisationState> ConvertJsonToOrganisationStateList(string organisationsStateJson)
        {
            return JsonConvert.DeserializeObject<List<OrganisationState>>(organisationsStateJson);
        }

        public string ConvertOrganisationStateListToJson(List<OrganisationState> organisations)
        {
            return JsonConvert.SerializeObject(organisations);
        }
    }
}
