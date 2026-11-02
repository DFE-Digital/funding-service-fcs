namespace SFA.FCT.ContractCreateDomain.Implementation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using CrossDomain.Integration.Entities.Xrm;
    using Exceptions;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using CrossDomain.Integration.Entities;

    // <summary>
    // Implementation of IXrmOrganisationManager for persisting data in Dynamics CRM (2011+)
    // </summary>
    public class XrmOrganisationManager : IXrmOrganisationManager
    {
        #region Consts

        private const string UnassignedTeamName = "Unassigned";
        private const string CaseloadRelationshipName = "sfa_account_sfa_caseload_OrganisationId";
        private readonly OptionSetValue _providerCategory = new OptionSetValue((int)sfa_organisationcategory.Provider);

        #endregion

        #region Fields

        /// <summary>
        /// List of Entity records used for reference data
        /// </summary>
        private IList<Entity> _referenceData;

        #endregion

        #region Injected Dependencies
        public IOrganizationService OrgService { get; set; }

        #endregion

        /// <summary>
        /// Gets a list of Entities used as reference data
        /// </summary>
        public IList<Entity> ReferenceData
        {
            get { return _referenceData; }
            set { _referenceData = value; }
        }

        #region Methods

        /// <summary>
        /// Gets a pre-defined set of Reference Data from Dynamics CRM using the filters specified in the parameters. 
        /// This reference data is parsed using one ExecuteMultiple request
        /// </summary>
        /// <param name="ukprn">A string representing the ukprn to parse</param>
        /// <param name="statusName">A string representing the status to parse</param>
        /// <param name="teamName">A string representing the team name to parse</param>
        public void GetReferenceData(string ukprn, string statusName, string teamName)
        {
            var refEntityList = new List<Entity>();

            if (OrgService != null)
            {
                var executeMultipleReq = new ExecuteMultipleRequest()
                {
                    Settings = new ExecuteMultipleSettings()
                    {
                        ContinueOnError = false,
                        ReturnResponses = true
                    },
                    Requests = new OrganizationRequestCollection()
                };

                // Get Org Info
                var retrieveMultipleOrgRequest = new RetrieveMultipleRequest();
                var orgQuery = new QueryExpression
                {
                    EntityName = Account.EntityLogicalName,
                    ColumnSet = new ColumnSet("name", "accountid", "sfa_ukprn"),
                };
                orgQuery.Criteria = new FilterExpression();
                orgQuery.Criteria.AddCondition("sfa_ukprn", ConditionOperator.Equal, ukprn);

                var linkCaseLoad = new LinkEntity()
                {
                    LinkFromEntityName = Account.EntityLogicalName,
                    LinkToEntityName = sfa_caseload.EntityLogicalName,
                    LinkFromAttributeName = "accountid",
                    LinkToAttributeName = "sfa_organisationid",
                    JoinOperator = JoinOperator.LeftOuter // joint changed to Left Outer as no organisations in CRM has associated case load
                };

                linkCaseLoad.Columns.AddColumn("sfa_caseloadid");
                linkCaseLoad.EntityAlias = "caseload";

                orgQuery.LinkEntities.Add(linkCaseLoad);
                retrieveMultipleOrgRequest.Query = orgQuery;

                // Get Status Info
                var retrieveMultipleStatusRequest = new RetrieveMultipleRequest();
                var statusQuery = new QueryByAttribute
                {
                    EntityName = sfa_status.EntityLogicalName,
                    ColumnSet = new ColumnSet("sfa_name", "sfa_statusid"),
                };
                statusQuery.AddAttributeValue("sfa_name", statusName);
                retrieveMultipleStatusRequest.Query = statusQuery;

                // Get Team Info
                var retrieveMultipleTeamRequest = new RetrieveMultipleRequest();
                var teamQuery = new QueryByAttribute
                {
                    EntityName = Team.EntityLogicalName,
                    ColumnSet = new ColumnSet("name", "teamid"),
                };
                teamQuery.AddAttributeValue("name", teamName);
                retrieveMultipleTeamRequest.Query = teamQuery;

                executeMultipleReq.Requests.Add(retrieveMultipleOrgRequest);
                executeMultipleReq.Requests.Add(retrieveMultipleStatusRequest);
                executeMultipleReq.Requests.Add(retrieveMultipleTeamRequest);

                var executeMultipleResp = (ExecuteMultipleResponse)OrgService.Execute(executeMultipleReq);

                foreach (var r in executeMultipleResp.Responses.Where(r => r.Fault == null))
                {
                    refEntityList.AddRange(((RetrieveMultipleResponse)r.Response).EntityCollection.Entities);
                }

                _referenceData = refEntityList;
            }
        }

        /// <summary>
        /// Creates a new instance of an organisation record in the Dynamics CRM system
        /// </summary>
        /// <param name="org">An object representing the organisation record</param>
        /// <returns>The guid of the newly created org, Guid.Empty if no org was created</returns>
        public Guid CreateOrganisationIfNotExists(ContractOrganisation org)
        {
            Guid createdOrgGuid = Guid.Empty;

            GetReferenceData(org.UKPRN, org.Status, UnassignedTeamName);
            var accountMatches = _referenceData.Where(e => e.LogicalName == "account");

            if (accountMatches.All(e => e.Attributes["sfa_ukprn"].ToString() != org.UKPRN))
            {
                var statusGuid = GetSettingFromRefData("sfa_status", "sfa_name", "sfa_statusid", org.Status);
                var teamGuid = GetSettingFromRefData("team", "name", "teamid", UnassignedTeamName);

                var orgEntity = new Account
                {
                    Name = org.Name,
                    sfa_UKPRN = org.UKPRN,
                    sfa_Status = new EntityReference(sfa_status.EntityLogicalName, statusGuid),
                    sfa_OrganisationCategory = _providerCategory,
                    sfa_companynumber = org.CompanyNumber,
                    sfa_charitynumber = org.CharityNumber,
                    sfa_orgupin = org.Upin,
                    sfa_OrganisationID = org.OrganisationId,
                    Address1_Line1 = org.Address.AddressLine1,
                    Address1_Line2 = org.Address.AddressLine2,
                    Address1_Line3 = org.Address.AddressLine3,
                    Address1_Line4 = org.Address.AddressLine4,
                    Address1_Town = org.Address.Town,
                    Address1_County = org.Address.County,
                    Address1_PostCode = org.Address.Postcode
                };

                var caseLoadEntity = new sfa_caseload
                {
                    sfa_organisationname = org.Name,
                    OwnerId = new EntityReference(Team.EntityLogicalName, teamGuid),
                    sfa_UKPRN = org.UKPRN,
                    sfa_Status = new EntityReference(sfa_status.EntityLogicalName, statusGuid)
                };

                var relatedCaseloadToCreate = new EntityCollection
                {
                    EntityName = sfa_caseload.EntityLogicalName,
                    Entities = { caseLoadEntity }
                };

                var caseloadRelationship = new Relationship(CaseloadRelationshipName);
                orgEntity.RelatedEntities.Add(caseloadRelationship, relatedCaseloadToCreate);

                createdOrgGuid = OrgService.Create(orgEntity);
            }
            
            return createdOrgGuid;
        }

        /// <summary>
        /// Updates an existing organisation in Dynamics CRM. Exceptions thrown: OrganisationDoesntExistException
        /// </summary>
        /// <param name="org">The organisation to be updated</param>
        public void UpdateOrganisation(organisation org)
        {
            if (_referenceData == null)
            {
                GetReferenceData(ExtractUkprnFromOrganisation(org), ExtractStatusFromOrganisation(org), UnassignedTeamName);
            }

            try
            {
                var accountMatches = _referenceData.Where(e => e.LogicalName == Account.EntityLogicalName);

                if (accountMatches.All(e => e.Attributes["sfa_ukprn"].ToString() != org.organisationIdentifiers[0].organisationIdentifier))
                {
                    var ex =
                        new OrganisationDoesntExistException(
                            "The organisation was not updated because an organisation with ukprn " + org.organisationIdentifiers[0].organisationIdentifier +
                            " doesn't exist.");

                    throw ex;
                }

                var accountGuid = GetSettingFromRefData("account", "sfa_ukprn", "accountid", org.organisationIdentifiers[0].organisationIdentifier);
                var statusGuid = GetSettingFromRefData("sfa_status", "sfa_name", "sfa_statusid", org.organisationStatusRelationships[0].organisationStatus.organisationStatus);

                var orgEntity = new Account
                {
                    AccountId = accountGuid,
                    Name = org.organisationNames[0].organisationName,
                    sfa_Status = new EntityReference(sfa_status.EntityLogicalName, statusGuid)
                };

                Entity accountEntity = _referenceData.First(e => e.LogicalName == Account.EntityLogicalName);

                if (accountEntity.Contains("caseload.sfa_caseloadid") && accountEntity["caseload.sfa_caseloadid"] != null)
                {
                    var caseLoadEntity = new sfa_caseload
                    {
                        sfa_caseloadId = (Guid)((AliasedValue)accountEntity["caseload.sfa_caseloadid"]).Value,
                        sfa_organisationname = org.organisationNames[0].organisationName,
                        sfa_UKPRN = org.organisationIdentifiers[0].organisationIdentifier,
                        sfa_Status = new EntityReference(sfa_status.EntityLogicalName, statusGuid)
                    };

                    var relatedCaseloadToCreate = new EntityCollection
                    {
                        EntityName = sfa_caseload.EntityLogicalName,
                        Entities = { caseLoadEntity }
                    };

                    var caseloadRelationship = new Relationship(CaseloadRelationshipName);
                    orgEntity.RelatedEntities.Add(caseloadRelationship, relatedCaseloadToCreate);
                }

                OrgService.Update(orgEntity);
            }
            catch (ArgumentNullException)
            {
                throw;
            }
        }

        /// <summary>
        /// Internal method to parse a setting from the reference data: Exceptions Thrown: ArgumentNullException
        /// </summary>
        /// <param name="entityName">The entity to be parsed</param>
        /// <param name="queryField">The field to be queried on</param>
        /// <param name="returnField">The Guid field to be returned</param>
        /// <param name="queryValue">The value to be queried on - this is always passed in as a string</param>
        /// <returns>The guid of the required setting</returns>
        internal Guid GetSettingFromRefData(string entityName, string queryField, string returnField, string queryValue)
        {
            if (_referenceData == null || _referenceData.Count == 0)
            {
                throw new ArgumentNullException("The Reference Data has not been set for the XrmOrganisationManager");
            }
            else
            {
                var settings = from s in _referenceData
                               where s.LogicalName == entityName && s.Attributes[queryField].ToString() == queryValue
                               select s.Attributes[returnField];
                if (!settings.Any())
                {
                    throw new ArgumentNullException("The Reference Data does not contain an entry for the entity " +
                                                    entityName + " with field " + queryField + "=" + queryValue);
                }
                else
                {
                    return (Guid)settings.First();
                }
            }
        }

        internal string ExtractUkprnFromOrganisation(organisation organisation)
        {
            return organisation.organisationIdentifiers.Find(
                x => x.organisationIdentifierType.Equals(organisationIdentifierType.UKPROVIDERREFERENCENUMBER))
                .organisationIdentifier;
        }

        internal string ExtractStatusFromOrganisation(organisation organisation)
        {
            return organisation.organisationStatusRelationships.Find(x => 
                x.organisationStatus.organisationStatusScheme.Equals(organisationStatusSchemeType.LEGAL))
                .organisationStatus
                .organisationStatus;
        }

        #endregion
    }
}
