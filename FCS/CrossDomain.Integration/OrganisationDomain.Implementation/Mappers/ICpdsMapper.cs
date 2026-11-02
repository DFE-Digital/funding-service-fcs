namespace OrganisationDomain.Implementation.Mappers
{
    using System.Xml.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public interface ICpdsMapper
    {
        //// CpdsProvider MapToOrganisationCorporateSchema(XDocument documentToMap);

        organisation MapDbEntityToCorpSchema(Integration.DataStore.Model.Organisation organisationToMap);

        Integration.DataStore.Model.Organisation MapProviderXmlToDbEntity(XDocument documentToMap);
    }
}
