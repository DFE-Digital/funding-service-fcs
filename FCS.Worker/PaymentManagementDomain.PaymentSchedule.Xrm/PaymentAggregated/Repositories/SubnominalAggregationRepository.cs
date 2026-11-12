namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    extern alias IntegrationEntities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class SubnominalAggregationRepository : ISubnominalAggregationRepository
    {
        private readonly IOrganizationService _organizationService;

        public SubnominalAggregationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public IReadOnlyCollection<sfa_subnominalaggregation> GetSubnominalsRelatedToAllocationId(Guid allocationId)
        {
            string contractallocationidColumn = "sfa_contractallocationid";
            string entity1PF = "sfa_subnominalaggregationid";
            const string relationshipEntityName = "sfa_sfa_subnominalaggregation_sfa_contracta";

            QueryExpression query = new QueryExpression(sfa_subnominalaggregation.EntityLogicalName)
            {
                ColumnSet = new ColumnSet(true)
            };
            LinkEntity linkEntity1 = new LinkEntity(sfa_subnominalaggregation.EntityLogicalName, relationshipEntityName,
                entity1PF, entity1PF, JoinOperator.Inner);
            LinkEntity linkEntity2 = new LinkEntity(relationshipEntityName, sfa_contractallocation.EntityLogicalName,
                contractallocationidColumn, contractallocationidColumn, JoinOperator.Inner);
            linkEntity1.LinkEntities.Add(linkEntity2);
            query.LinkEntities.Add(linkEntity1);

            linkEntity2.LinkCriteria = new FilterExpression();
            linkEntity2.LinkCriteria.AddCondition(new ConditionExpression("sfa_contractallocationid",
                ConditionOperator.Equal, allocationId));

            EntityCollection recordcollection = _organizationService.RetrieveMultiple(query);
            return recordcollection.Entities.Select(e => e as sfa_subnominalaggregation).ToList();
        }

        public IReadOnlyCollection<sfa_subnominalaggregation> GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys(
            IReadOnlyCollection<string> subnominalCodes, IReadOnlyCollection<string> aggregateKeys)
        {
            if (!subnominalCodes.Any() || !aggregateKeys.Any())
            {
                return Enumerable.Empty<sfa_subnominalaggregation>().ToList();
            }

            QueryExpression queryExpression = CreateQueryExpression(subnominalCodes, aggregateKeys);

            EntityCollection entityCollection = ExecuteQuery(queryExpression);

            return entityCollection.Entities.Select(e => new sfa_subnominalaggregation
            {
                Id = e.Id,
                sfa_SubnominalAggregateKey = e.GetAttributeValue<string>(sfa_subnominalaggregation.Fields.sfa_SubnominalAggregateKey),
                sfa_PaymentType = e.GetAttributeValue<OptionSetValue>(sfa_subnominalaggregation.Fields.sfa_PaymentType),
                sfa_AggregatedValue = e.GetAttributeValue<decimal?>(sfa_subnominalaggregation.Fields.sfa_AggregatedValue)

            }).ToList();
        }

        private EntityCollection ExecuteQuery(QueryExpression query)
        {
            EntityCollection entityCollection = null;
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest();
            rmr.Query = query;

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest();
            emr.Requests = new OrganizationRequestCollection();
            emr.Requests.Add(rmr);
            emr.Settings = new ExecuteMultipleSettings();
            emr.Settings.ReturnResponses = true;

            ExecuteMultipleResponse xmr = (ExecuteMultipleResponse)_organizationService.Execute(emr);

            foreach (var response in xmr.Responses)
            {
                if (response.Response != null)
                {
                    foreach (var result in response.Response.Results)
                    {
                        entityCollection = result.Value as EntityCollection;
                    }
                }
            }

            return entityCollection;
        }

        private QueryExpression CreateQueryExpression(IEnumerable<string> subnominalCodes, IEnumerable<string> aggregateKeys)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = sfa_subnominalaggregation.EntityLogicalName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            query.Criteria.Conditions.Add(new ConditionExpression(
                sfa_subnominalaggregation.Fields.sfa_SubnominalAggregateKey,
                ConditionOperator.In,
                aggregateKeys.ToArray()));

            query.Criteria.Conditions.Add(new ConditionExpression(
            sfa_subnominalaggregation.Fields.sfa_name,
            ConditionOperator.In,
            subnominalCodes.ToArray()));

            return query;
        }
    }
}
