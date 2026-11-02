namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System.Collections.Generic;
    using System.Xml.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;

    public interface ICpdsXmlValidator
    {
        bool HasMultipleActiveProvidersWithTheSameUkprn(XDocument cpdsXml);

        bool ProviderHasAnActiveStatusCodeElement(XElement provider);

        void RemoveProvidersThatAreNotActiveOrDoNotHaveANumericUpin(XDocument cpdsXml);

        void RemoveProvidersThatDoNotHaveAMatchingUpin(XDocument cpdsXml, int upin);

        bool ProviderHasANumericUpin(XElement provider);

        bool IsOrganisationValidAgainstOrganisationCorporateSchema(organisation organisationToValidate, out List<OrganisationSchemaValidationError> validationErrors);
    }
}