namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using DTO;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Services;

    public static class CrmOrganisationRepository
    {
        private static readonly IDictionary<string, EntityReference> EntityReferencesForOrganisationNames = new Dictionary<string, EntityReference>();

        public static void CreateOrganisation(OrganisationDto organisation)
        {
            Account account = new Account
            {
                sfa_UKPRN = organisation.Ukprn,
                Name = organisation.LegalName,
                sfa_charitynumber = organisation.CharityNumber,
                sfa_orgupin = organisation.Upin,
                sfa_companynumber = organisation.CompanyNumber
            };

            CrmConnectionFactory.GetConnection().Create(account);
        }

        public static void AddOrUpdateOrganisations(IEnumerable<Account> organisations)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                organisations.ForEach(newOrUpdatedOrg =>
                {
                    Guid? existingRecordId = context.AccountSet.SingleOrDefault(a => a.sfa_UKPRN == newOrUpdatedOrg.sfa_UKPRN)?.Id;
                    newOrUpdatedOrg.Id = existingRecordId ?? Guid.NewGuid();

                    if (existingRecordId.HasValue)
                    {
                        organizationService.Update(newOrUpdatedOrg);
                    }
                    else
                    {
                        organizationService.Create(newOrUpdatedOrg);
                    }
                });

            }
        }

        public static EntityReference GetOrganisationEntityReferenceByName(string organisationName)
        {
            if (!EntityReferencesForOrganisationNames.ContainsKey(organisationName))
            {
                using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
                {
                    EntityReferencesForOrganisationNames.Add(organisationName, xrmContext.AccountSet.SingleOrDefault(a => a.Name == organisationName)?.ToEntityReference());
                }
            }

            return EntityReferencesForOrganisationNames[organisationName];
        }

        public static EntityReference GetOrganisationEntityReferenceByUkprn(string ukprn)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.AccountSet.SingleOrDefault(a => a.sfa_UKPRN == ukprn)?.ToEntityReference();
            }
        }

        public static string GetOrganisationName(Guid orgId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.AccountSet.Single(a => a.Id == orgId).Name;
            }
        }

        public static IReadOnlyCollection<Guid> GetOrganisationsByUkprn(string ukprn)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.AccountSet.Where(a => a.sfa_UKPRN == ukprn)
                    .Select(a => a.Id)
                    .ToList();
            }
        }

        public static string GetOrganisationStatusByName(string name)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.AccountSet.Where(a => a.Name == name)
                    .Select(o => o.sfa_Status.Name).Single();
            }
        }

        public static CrmOrganisationInfo GetOrganisationByUkprn(string ukprn)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.AccountSet
                    .Where(a => a.sfa_UKPRN == ukprn)
                    .Select(a => new CrmOrganisationInfo
                    {
                        Ukprn = a.sfa_UKPRN,
                        Upin = a.sfa_orgupin,
                        Name = a.Name,
                        Status = a.sfa_Status.Name,
                        CompanyNumber = a.sfa_companynumber,
                        CharityNumber = a.sfa_charitynumber,
                        Address = new CrmOrganisationInfo.AddressInfo
                        {
                            Line1 = a.Address1_Line1,
                            Line2 = a.Address1_Line2,
                            Line3 = a.Address1_Line3,
                            Line4 = a.Address1_Line4,
                            Town = a.Address1_Town,
                            County = a.Address1_County,
                            Postcode = a.Address1_PostCode
                        }
                    })
                    .SingleOrDefault();
            }
        }

        public static void DeleteOrgById(string orgId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                xrmContext.AccountSet.Where(a => a.sfa_OrganisationID == orgId)
                    .Select(o => o.Id)
                    .AsEnumerable()
                    .ForEach(oId => CrmConnectionFactory.GetConnection().Delete(Account.EntityLogicalName, oId));
            }
        }

        public static void DeleteOrgByCrmId(Guid id)
        {
            CrmConnectionFactory.GetConnection().Delete(Account.EntityLogicalName, id);
        }
    }
}
