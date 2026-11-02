namespace OrganisationDomain.Implementation.Mappers
{
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Linq;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class CpdsMapper : ICpdsMapper
    {
        private const string ProviderElement = "Provider";
        private const string ProviderTypeElement = "ProviderType";
        private const string UkprnElement = "UKPRN";
        private const string UpinElement = "Upin";
        private const string RegisteredNameElement = "RegisteredName";
        private const string ProviderSequenceNumberAttribute = "ProviderSequenceNumber";
        private const string CodesElement = "Codes";
        private const string CodeTypeElement = "CodeType";
        private const string CodeValueDescElement = "CodeValueDesc";

        private readonly XNamespace _ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
        
        public organisation MapDbEntityToCorpSchema(Integration.DataStore.Model.Organisation organisationToMap)
        {
            var org = new organisation
            {
                organisationId = organisationToMap.FormattedOrganisationId,
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
                        organisationIdentifier = organisationToMap.Ukprn.ToString()
                    },
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifierType = organisationIdentifierType.UPIN,
                        organisationIdentifier = organisationToMap.Upin.ToString()
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName
                    {
                        organisationName = organisationToMap.TradingName
                    }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = organisationToMap.Status,
                            organisationStatusScheme = organisationStatusSchemeType.LEGAL
                        }
                    }
                },
            organisationTypeRelationships = new List<organisationTypeRelationshipsOrganisationTypeRelationship>()
                {
                    new organisationTypeRelationshipsOrganisationTypeRelationship
                    {
                        organisationType = new organisationTypeRelationshipsOrganisationTypeRelationshipOrganisationType
                        {
                            organisationTypeScheme = organisationTypeSchemeType.CORPORATE,
                            organisationType = organisationToMap.Type
                        }
                    }
                }
            };

            if (!string.IsNullOrEmpty(organisationToMap.CompanyRegistrationNumber))
            {
                org.organisationIdentifiers.Add(new organisationIdentifiersOrganisationIdentifier
                {
                    organisationIdentifierType = organisationIdentifierType.COMPANYREGISTRATIONNUMBER,
                    organisationIdentifier = organisationToMap.CompanyRegistrationNumber
                });
            }

            if (!string.IsNullOrEmpty(organisationToMap.CharityNumber))
            {
                org.organisationIdentifiers.Add(new organisationIdentifiersOrganisationIdentifier
                {
                    organisationIdentifierType = organisationIdentifierType.CHARITYNUMBER,
                    organisationIdentifier = organisationToMap.CharityNumber
                });
            }

            if (organisationToMap.Address.HasValue)
            {
                org.organisationAddresses.Add(new organisationAddressesOrganisationAddress
                {
                    addressLine1 = organisationToMap.Address.Line1,
                    addressLine2 = organisationToMap.Address.Line2,
                    addressLine3 = organisationToMap.Address.Line3,
                    addressLine4 = organisationToMap.Address.Line4,
                    town = organisationToMap.Address.Town,
                    county = organisationToMap.Address.County,
                    postcode = organisationToMap.Address.Postcode
                });
            }

            return org;
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        public Integration.DataStore.Model.Organisation MapProviderXmlToDbEntity(XDocument documentToMap)
        {
            var providerElement = documentToMap.Root.Element(_ns + ProviderElement);

                return new Integration.DataStore.Model.Organisation
                {
                    Ukprn = int.Parse(providerElement.Element(_ns + UkprnElement).Value),
                    Upin = int.Parse(providerElement.Element(_ns + UpinElement).Value),
                    TradingName = providerElement.Element(_ns + RegisteredNameElement).Value,
                    SequenceNumber = int.Parse(providerElement.Attribute(ProviderSequenceNumberAttribute).Value),
                    Type = GetOrganisationTypeFromProviderXml(documentToMap),
                    Status = GetOrganisationStatusElementFromRoot(documentToMap)?.Value ?? string.Empty
                };
        }

        internal XElement GetOrganisationStatusElementFromRoot(XDocument documentToMap)
        {
            var providerElement = documentToMap.Root.Element(_ns + ProviderElement);

            var organisationStatusElement = providerElement.Elements(_ns + CodesElement)
                .Where(x => x.Element(_ns + CodeTypeElement).Attribute("id").Value == "91")
                .Descendants(_ns + CodeValueDescElement).SingleOrDefault();
            return organisationStatusElement;
        }


        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        internal string GetOrganisationTypeFromProviderXml(XDocument documentToMap)
        {
            return documentToMap.Root.Element(_ns + ProviderElement).Element(_ns + ProviderTypeElement).Element(_ns + ProviderTypeElement).Value;
        }
    }
}
