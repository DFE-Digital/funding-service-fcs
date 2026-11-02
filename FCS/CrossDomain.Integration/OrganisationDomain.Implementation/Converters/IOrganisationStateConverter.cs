namespace OrganisationDomain.Implementation.Converters
{
    using System.Collections.Generic;
    using Integration.Entities;

    public interface IOrganisationStateConverter
    {
        List<OrganisationState> ConvertJsonToOrganisationStateList(string organisationsStateJson);

        string ConvertOrganisationStateListToJson(List<OrganisationState> organisations);
    }
}