namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class ClearDownTests
    {
        [TestMethod, TestCategory("ClearDown")]
        public void ClearDownCrmData()
        {
            GetAllocationIds()
                .Batch(1)
                .ToList()
                .ForEach(batchAllocationIds =>
                {
                    IReadOnlyCollection<DeleteRequest> deleteRequests = batchAllocationIds.SelectMany(allocationId =>
                    {
                        var subnominalaggregationIds = GetSubnominalsRelatedToAllocationId(allocationId);

                        return subnominalaggregationIds.Select(subnominalaggregationId => new DeleteRequest()
                        {
                            Target = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                subnominalaggregationId)
                        });
                    }).ToList();

                    if (deleteRequests.Any())
                    {
                        ExecuteMultipleRequest multipleRequest = new ExecuteMultipleRequest
                        {
                            Requests = new OrganizationRequestCollection(),
                            Settings = new ExecuteMultipleSettings()
                        };

                        multipleRequest.Requests.AddRange(deleteRequests);
                        CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(multipleRequest);
                    }
                });

            ClearDownContracts();
        }

        private void ClearDownContracts()
        {
            void Delete(IEnumerable<DeleteRequest> reqs) =>
                reqs.Batch(100)
                    .ToList()
                    .ForEach(batchDeleteRequests =>
                    {
                        ExecuteMultipleRequest multipleRequest = new ExecuteMultipleRequest
                        {
                            Requests = new OrganizationRequestCollection(),
                            Settings = new ExecuteMultipleSettings()
                        };
                        multipleRequest.Requests.AddRange(batchDeleteRequests);
                        CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(multipleRequest);
                    });

            var contractCollections = GetContractCollections();

            IEnumerable<DeleteRequest> contractsDeleteRequests = contractCollections.ContractIds.Select(id => new DeleteRequest
            {
                Target = new EntityReference(sfa_contract.EntityLogicalName, id)
            });

            Delete(contractsDeleteRequests);

            IEnumerable<DeleteRequest> masterContractDeleteRequests = contractCollections.MasterContractIds.Select(id => new DeleteRequest
            {
                Target = new EntityReference(sfa_contract.EntityLogicalName, id)
            });

            Delete(masterContractDeleteRequests);
        }

        private ContractCollections GetContractCollections()
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(organizationService))
            {
                var contracts = context.sfa_contractSet.Select(c => new {ContractId = c.sfa_contractId.Value, Hierarchy = c.sfa_HierarchyType.Value }).ToList();

                var groups = contracts.GroupBy(c => c.Hierarchy);
                return new ContractCollections(contractIds: groups.Single(g => g.Key == 229660000).Select(c => c.ContractId).ToList(),
                    groups.Single(g=> g.Key== 229660001).Select(c => c.ContractId).ToList());
            }
        }

        private IReadOnlyCollection<Guid> GetAllocationIds()
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contractallocationSet.Select(a => a.sfa_contractallocationId.Value).ToList();
            }
        }

        private class ContractCollections
        {
            public ContractCollections(IReadOnlyCollection<Guid> contractIds, IReadOnlyCollection<Guid> masterContractIds)
            {
                ContractIds = contractIds;
                MasterContractIds = masterContractIds;
            }

            public IReadOnlyCollection<Guid> ContractIds { get; }

            public IReadOnlyCollection<Guid> MasterContractIds { get; }
        }

        private IReadOnlyCollection<Guid> GetSubnominalsRelatedToAllocationId(Guid allocationId)
        {
            string contractallocationidColumn = "sfa_contractallocationid";
            string entity1PF = "sfa_subnominalaggregationid";
            const string relationshipEntityName = "sfa_sfa_subnominalaggregation_sfa_contracta";

            QueryExpression query = new QueryExpression(sfa_subnominalaggregation.EntityLogicalName)
            {
                ColumnSet = new ColumnSet
                {
                    Columns = { "sfa_subnominalaggregationid" }
                }
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

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            EntityCollection recordcollection = organizationService.RetrieveMultiple(query);
            return recordcollection.Entities.Select(e => e.GetAttributeValue<Guid?>("sfa_subnominalaggregationid").Value).ToList();
        }
    }
}
