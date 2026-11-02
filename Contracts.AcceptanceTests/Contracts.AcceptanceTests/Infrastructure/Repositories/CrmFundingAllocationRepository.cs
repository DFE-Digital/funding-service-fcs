namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using DTO.Cfs;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using Services;

    public static class CrmFundingAllocationRepository
    {
        public static void DeleteFundingAllocationsForUkprn(int ukprn)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                context.sfa_fundingallocationSet.Where(fa => fa.sfa_ukprn == ukprn.ToString())
                    .Select(fa => fa.sfa_fundingallocationId.Value)
                    .ToList()
                    .ForEach(id => CrmConnectionFactory.GetConnection().Delete(sfa_fundingallocation.EntityLogicalName, id));
            }
        }

        public static void DeleteFundingAllocationHistories(int ukprn)
        {
            var fundingAllocationIds = GetFundingAllocationIdsForUkprn(ukprn.ToString());

            QueryExpression query = new QueryExpression
            {
                EntityName = "sfa_fundingallocationhistory",
                ColumnSet = new ColumnSet("sfa_fundingallocationhistoryid"),
                Criteria = new FilterExpression()
            };

            query.Criteria.Conditions.Add(new ConditionExpression(
                "sfa_funding",
                ConditionOperator.In,
                fundingAllocationIds.ToArray()));

            EntityCollection entityCollection = null;
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest();
            rmr.Query = query;

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest();
            emr.Requests = new OrganizationRequestCollection();
            emr.Requests.Add(rmr);
            emr.Settings = new ExecuteMultipleSettings();
            emr.Settings.ReturnResponses = true;


            ExecuteMultipleResponse xmr = (ExecuteMultipleResponse)CrmConnectionFactory.GetConnection().Execute(emr);

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

            entityCollection?.Entities.ToArray().ToList().ForEach(e => CrmConnectionFactory.GetConnection().Delete(query.EntityName, e.Id));
        }

        public static IReadOnlyCollection<CrmFundingAllocation> GetFundingAllocationsForUkprn(string ukprn, string fundingId)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var fundingAllocations = (from fa in context.sfa_fundingallocationSet
                                          join a in context.AccountSet on fa.sfa_provider.Id equals a.Id
                                          join ft in context.sfa_fundingtypeSet on fa.sfa_fundingtype.Id equals ft.Id
                                          join p in context.sfa_periodSet on fa.sfa_period.Id equals p.Id
                                          join ct in context.sfa_contracttypeSet on fa.sfa_contracttypeid.Id equals ct.Id
                                          join fspGroup in context.sfa_fspgroupSet on fa.sfa_fspgroupid.Id equals fspGroup.Id
                                          where fa.sfa_ukprn == ukprn
                                                && fa.sfa_name == fundingId
                                          select new
                                          {
                                              fa,
                                              ProviderName = a.Name,
                                              FundingType = ft.sfa_name,
                                              PeriodName = p.sfa_periodname,
                                              FspGroupName = fspGroup.sfa_name,
                                              ContractType = ct.sfa_name,
                                              HoldReason = fa.sfa_holdreason,
                                              ReleaseGroupId = fa.sfa_releasegroup,
                                              queuedOn = fa.sfa_queuedon,
                                              queuedDueToContract = fa.sfa_queuedduetocontract
                                          }).ToList();

                return fundingAllocations.Select(fa => new CrmFundingAllocation(fa.fa,
                        fa.ProviderName,
                        fa.FundingType,
                        fa.PeriodName,
                        fa.FspGroupName,
                        fa.ContractType,
                        fa.HoldReason.GetName<sfa_FundingAllocationHoldReason>(),
                        GetReleaseName(fa.ReleaseGroupId?.Id),
                        fa.queuedOn,
                        fa.queuedDueToContract))
                    .ToList();
            }
        }

        public static IReadOnlyCollection<CrmFundingAllocationHistory> GetFundingAllocationHistoriesForFundingId(string fundingId)
        {
            var fundingAllocationIds = GetFundingAllocationIdsForFundingId(fundingId);

            QueryExpression query = new QueryExpression
            {
                EntityName = "sfa_fundingallocationhistory",
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            LinkEntity linkFundingAllocation = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_funding",
                LinkToEntityName = "sfa_fundingallocation",
                LinkToAttributeName = "sfa_fundingallocationid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet("sfa_name"),
                EntityAlias = "fa"
            };

            LinkEntity linkUser = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_completedby",
                LinkToEntityName = "systemuser",
                LinkToAttributeName = "systemuserid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet("fullname"),
                EntityAlias = "user"
            };

            query.LinkEntities.Add(linkFundingAllocation);
            query.LinkEntities.Add(linkUser);

            query.Criteria.Conditions.Add(new ConditionExpression(
                "sfa_funding",
                ConditionOperator.In,
                fundingAllocationIds.ToArray()));

            EntityCollection entityCollection = null;
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest {Query = query};

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest();
            emr.Requests = new OrganizationRequestCollection();
            emr.Requests.Add(rmr);
            emr.Settings = new ExecuteMultipleSettings();
            emr.Settings.ReturnResponses = true;

            ExecuteMultipleResponse xmr = (ExecuteMultipleResponse)CrmConnectionFactory.GetConnection().Execute(emr);

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

            if (entityCollection != null)
            {
                return entityCollection.Entities.Select(e =>
                    new CrmFundingAllocationHistory(
                        fundingId: e.GetAttributeAliasedStringValue("fa.sfa_name"),
                        action: e.GetAttributeStringValue("sfa_name"),
                        completedBy: e.GetAttributeAliasedStringValue("user.fullname"),
                        newStatus: e.GetAttributeValue<OptionSetValue>("sfa_newstatus").Value,
                        newSubStatus: e.GetAttributeValue<OptionSetValue>("sfa_newsubstatus").Value,
                        previousStatus: e.GetAttributeOrDefault("sfa_previousstatus", new OptionSetValue(-1)).Value,
                        previousSubStatus: e.GetAttributeOrDefault("sfa_previoussubstatus", new OptionSetValue(-1)).Value,
                        comments: e.GetAttributeStringValue("sfa_comments")
                    )).ToList();
            }

            return new List<CrmFundingAllocationHistory>();
        }

        private static IReadOnlyCollection<Guid> GetFundingAllocationIdsForFundingId(string fundingId)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_fundingallocationSet.Where(fa => fa.sfa_name == fundingId)
                    .Select(fa => fa.sfa_fundingallocationId.Value)
                    .ToList();
            }
        }

        private static IReadOnlyCollection<Guid> GetFundingAllocationIdsForUkprn(string ukprn)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_fundingallocationSet.Where(fa => fa.sfa_ukprn == ukprn)
                    .Select(fa => fa.sfa_fundingallocationId.Value)
                    .ToList();
            }
        }

        public static void HoldFundingAllocation(string username, string fundingId, sfa_FundingAllocationHoldReason holdReason, string comments)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var entityIds = context.sfa_fundingallocationSet
                    .Where(fa => fa.sfa_name == fundingId)
                    .Select(fa => fa.Id)
                    .ToList();

                entityIds.ForEach(entityId =>
                {
                    var organizationRequest = new OrganizationRequest("sfa_FundingAllocationHold")
                    {
                        Parameters =
                        {
                            ["inputIDs"] = entityId.ToString(),
                            ["inputReason"] = ((int)holdReason).ToString(),
                            ["inputComments"] = comments
                        }
                    };

                    CrmConnectionFactory.GetConnectionForSpecificUser(username).Execute(organizationRequest);
                });
            }
        }

        public static void ReleaseHoldFundingAllocation(string username, string fundingId, Guid workflowId)
        {
            ExecuteCrmWorkflow(username, fundingId, workflowId);
        }

        public static void WithdrawFundingAllocation(string username, string fundingId, string reason)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var entityIds = context.sfa_fundingallocationSet
                    .Where(fa => fa.sfa_name == fundingId)
                    .Select(fa => fa.Id)
                    .ToList();

                entityIds.ForEach(entityId =>
                {
                    var organizationRequest = new OrganizationRequest("sfa_FundingAllocationWithdraw")
                    {
                        Parameters =
                        {
                            ["inputIDs"] = entityId.ToString(),
                            ["inputComments"] = reason.ParseNullableString()
                        }
                    };

                    CrmConnectionFactory.GetConnectionForSpecificUser(username).Execute(organizationRequest);
                });
            }
        }

        public static void ReinstateFundingAllocation(string username, string fundingId, Guid workflowId)
        {
            ExecuteCrmWorkflow(username, fundingId, workflowId);
        }

        private static void ExecuteCrmWorkflow(String username, String fundingId, Guid workflowId)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var entityIds = context.sfa_fundingallocationSet
                    .Where(fa => fa.sfa_name == fundingId)
                    .Select(fa => fa.Id)
                    .ToList();

                entityIds.ForEach(entityId => { CrmWorkflowRepository.ExecuteWorkFlow(workflowId, entityId, username); });
            }
        }

        private static string GetReleaseName(Guid? releaseGroupId)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_releasegroupSet.FirstOrDefault(rg => rg.Id == releaseGroupId)?.sfa_name;
            }
        }
    }
}
