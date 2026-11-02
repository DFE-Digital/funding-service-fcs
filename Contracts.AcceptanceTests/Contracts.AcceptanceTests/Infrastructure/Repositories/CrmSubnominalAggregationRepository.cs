namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using Services;

    public static class CrmSubnominalAggregationRepository
    {
        public static IReadOnlyCollection<sfa_subnominalaggregation> GetSubnominalAggregationsForLatestApprovedAllocation(Guid allocationId)
        {
            return GetSubnominalAggregationsForAllocationId(allocationId, e => e as sfa_subnominalaggregation);
        }

        public static decimal? GetAggregatedValue(string allocationNumber, int code, string period, string paymentType)
        {
            IReadOnlyCollection<sfa_subnominalaggregation> subnominalAggregations =
                GetSubnominalAggregationsForAllocationId(GetLatestAllocationId(allocationNumber), e => e as sfa_subnominalaggregation).ToList();

            string aggregatedKey = $"{code}_{allocationNumber}_{period}";
            return subnominalAggregations.SingleOrDefault(
                sa =>
                    sa.sfa_SubnominalAggregateKey == aggregatedKey &&
                    sa.sfa_PaymentType.Value == GetPaymentTypeCode(paymentType))?.sfa_AggregatedValue;
        }

        public static int GetPaymentTypeCode(string paymentType)
        {
            sfa_paymenttype result;
            Enum.TryParse(paymentType, out result);

            return (int)result;
        }

        public static void ClearAll()
        {
            var connection = CrmConnectionFactory.GetConnection();
            using (var context = new XrmServiceContext(connection))
            {
                context.sfa_subnominalaggregationSet.Select(sa => sa.sfa_subnominalaggregationId.Value)
                    .ToList()
                    .ForEach(id => connection.Delete(sfa_subnominalaggregation.EntityLogicalName, id));
            }
        }

        public static bool IsSubnominalPresent(string allocationNumber, int code, string period, string paymentType)
        {
            var key = GetAggregatedKey(allocationNumber, code, period);

            var paymentTypeCode = GetPaymentTypeCode(paymentType);

            IReadOnlyCollection<sfa_subnominalaggregation> subnominalAggregations =
                GetSubnominalAggregationsForAllocationId(GetLatestAllocationId(allocationNumber), e => e as sfa_subnominalaggregation).ToList();

            return subnominalAggregations.Any();
        }

        public static void DeleteSubmoninalsForCode(string subnominalCode)
        {
            var connection = CrmConnectionFactory.GetConnection();
            using (var context = new XrmServiceContext(connection))
            {
                var idsOfEntities =
                    context.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalCode == subnominalCode)
                        .Select(sa => sa.sfa_subnominalaggregationId.Value).ToList();

                idsOfEntities.ForEach(id => connection.Delete(sfa_subnominalaggregation.EntityLogicalName, id));
            }
        }

        private static string GetAggregatedKey(string allocationNumber, int code, string period)
        {
            return $"{code}_{allocationNumber}_{period}";
        }

        private static Guid GetLatestAllocationId(string allocationNumber)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return
                    context.sfa_contractallocationSet.Where(a => a.sfa_contractallocationnumber == allocationNumber)
                        .Select(a => new {Id = a.sfa_contractallocationId.Value, Created = a.CreatedOn})
                        .AsEnumerable()
                        .OrderByDescending(a => a.Created)
                        .Select(a => a.Id)
                        .First();
            }
        }

        private static IReadOnlyCollection<TOut> GetSubnominalAggregationsForAllocationId<TOut>(Guid allocationId, Func<Entity, TOut> columnSelector)
        {
            string contractallocationidColumn = "sfa_contractallocationid";
            string subnominalAggregationColumn = "sfa_subnominalaggregationid";
            const string relationshipEntityName = "sfa_sfa_subnominalaggregation_sfa_contracta";

            QueryExpression query = new QueryExpression(sfa_subnominalaggregation.EntityLogicalName)
            {
                ColumnSet = new ColumnSet(true)
            };
            LinkEntity linkEntity1 = new LinkEntity(sfa_subnominalaggregation.EntityLogicalName, relationshipEntityName,
                subnominalAggregationColumn, subnominalAggregationColumn, JoinOperator.Inner);
            LinkEntity linkEntity2 = new LinkEntity(relationshipEntityName, sfa_contractallocation.EntityLogicalName,
                contractallocationidColumn, contractallocationidColumn, JoinOperator.Inner);
            linkEntity1.LinkEntities.Add(linkEntity2);
            query.LinkEntities.Add(linkEntity1);

            linkEntity2.LinkCriteria = new FilterExpression();
            linkEntity2.LinkCriteria.AddCondition(new ConditionExpression("sfa_contractallocationid",
                ConditionOperator.Equal, allocationId));

            EntityCollection recordcollection = CrmConnectionFactory.GetConnection().RetrieveMultiple(query);
            return recordcollection.Entities.Select(columnSelector).ToList();
        }

        public static void ChangeSubnominalAggregationSubnominalCode(string fundingStreamPeriodCode, string subnominalAggregateKey, 
            string newSubnominalCode, string paymentType)
        {
            int paymentTypeCode = GetPaymentTypeCode(paymentType.ToTitleCase());

            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IReadOnlyCollection<sfa_subnominalaggregation> subnominalAggregationList = (from fsp in context.sfa_fundingstreamperiodSet
                    join sa in context.sfa_subnominalaggregationSet on fsp.Id equals sa.sfa_fundingstreamperiod.Id
                    where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode &&
                          sa.sfa_SubnominalAggregateKey == subnominalAggregateKey &&
                          sa.sfa_PaymentType.Value == paymentTypeCode
                    select sa).ToList();

                subnominalAggregationList.ForEach(sa =>
                {
                    var newSubnominalAggregateKey = ConstructNewSubnominalAggregateKey(sa.sfa_SubnominalAggregateKey, newSubnominalCode);

                    UpdateCrmSubnominalAggregation(sa.sfa_subnominalaggregationId.Value, newSubnominalCode, newSubnominalAggregateKey);
                });
            }
        }

        private static string ConstructNewSubnominalAggregateKey(string oldSubnominalAggregateKey, string newSubnominalCode)
        {
            // sample oldSubnominalAggregateKey - "2240150_YNLP-732_Aug-19"
            var aggKeyParts = oldSubnominalAggregateKey.Split('_');
            return $"{newSubnominalCode}_{aggKeyParts[1]}_{aggKeyParts[2]}";
        }

        private static void UpdateCrmSubnominalAggregation(
            Guid crmId,
            string newSubnominalCode,
            string newSubnominalAggregateKey)
        {
            var subnominalaggregation = new sfa_subnominalaggregation
            {
                Id = crmId,
                sfa_name = newSubnominalCode,
                sfa_SubnominalCode = newSubnominalCode,
                sfa_SubnominalAggregateKey = newSubnominalAggregateKey,
                EntityState = EntityState.Changed
            };

            var organizationService = CrmConnectionFactory.GetConnection();
           
            organizationService.Update(subnominalaggregation);
        }
    }
}
