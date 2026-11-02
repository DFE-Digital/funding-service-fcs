namespace SFA.FCT.Xrm.TestFramework.Utils
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    //using Microsoft.VisualStudio.TestTools.WebTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;

    public class AcceptanceTestUtils //: WebTestPlugin
    {
        private readonly CrmManager _crmManager;

        public AcceptanceTestUtils(string userName = null)
        {
            _crmManager = new CrmManager(userName);
        }

        public List<Entity> GetContractsInCrmForUkPrns(IList<object> ukprnsList, bool forTodayOnly)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.In, ukprnsList.ToArray())
            };

            if (forTodayOnly)
            {
                columnValues.Add(new ColumnValueCriteria("createdon", ConditionOperator.GreaterThan, DateTime.Now.Date));
            }

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            // , RelationshipDetail = new RelationshipDetail() { EntityName = "sfa_contractallocation", RelationshipName = "sfa_sfa_contract_sfa_contractallocation" 
            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public List<Entity> GetContractsInCrmForUkPrnsNotMatchingEntities(IList<object> ukprnsList, bool forTodayOnly, IList<Entity> entities)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.In, ukprnsList.ToArray())
            };

            if (forTodayOnly)
            {
                columnValues.Add(new ColumnValueCriteria("createdon", ConditionOperator.GreaterThan, DateTime.Now.Date));
            }

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            var allEntities = _crmManager.GetCrmEntities(lookupCriteria);
            return allEntities.Where(ae => !entities.Select(e => e.Id).Contains(ae.Id)).ToList();
        }

        public List<Entity> GetContractsInCrmForContractNumberAndWaitIfNotFound(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, contractNumber)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            for (int i = 0; i < 60; i++)
            {
                List<Entity> entities = _crmManager.GetCrmEntities(lookupCriteria);
                if (!entities.Any())
                {
                    Task.Delay(1000).Wait();
                }
                else
                {
                    return entities;
                }
            }

            return new List<Entity>();
        }

        public List<Entity> GetContractsInCrmForFundingType(string fundingType)
        {
            var funValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_fundingtypecode", ConditionOperator.Equal, fundingType)
            };
            var funCriteria = new CrmLookupCriteria { EntityName = "sfa_fundingtype", LookupCriteria = funValues };
            var fundingTypes = _crmManager.GetCrmEntities(funCriteria);

            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_fundingtype", ConditionOperator.Equal, fundingTypes.First().Id)
            };
            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public List<Entity> GetContractsInCrmForVersion(string contractNumber, int version, int subVersion)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, contractNumber),
                new ColumnValueCriteria("sfa_version", ConditionOperator.Equal, version),
                new ColumnValueCriteria("sfa_subversion", ConditionOperator.Equal, subVersion)
            };
            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public IReadOnlyCollection<Entity> GetContractsInCrm(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, contractNumber),
            };
            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public string GenerateContractNumberInCrm()
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractnumbertype", ConditionOperator.Equal, 229660001)
            };
            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contractnumber", LookupCriteria = columnValues };

            var contractNumbersList = _crmManager.GetCrmEntities(lookupCriteria).First();

            // Code to get/update id
            var executeCreatTaskOnAccount = new OrganizationRequest("sfa_GenerateContractNumber");
            executeCreatTaskOnAccount.Parameters["Target"] = new EntityReference("sfa_contractnumber", contractNumbersList.Id);
            var results = _crmManager.ConnectAsUser().Execute(executeCreatTaskOnAccount);

            return results.Results["ContractNumber"].ToString();
        }

        public void DeleteContract(Entity contract)
        {
            _crmManager.ConnectAsUser().Delete(contract);
        }

        public List<Entity> GetAllocationsForContract(Entity contract)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractid", ConditionOperator.Equal, contract.Attributes["sfa_contractid"])
            };

            var lookupCriteria = new CrmLookupCriteria
            {
                EntityName = "sfa_contractallocation",
                LookupCriteria = columnValues,
                RelationshipDetail = new RelationshipDetail
                {
                    EntityName = "sfa_fundingstream",
                    RelationshipName = "sfa_sfa_fundingstream_sfa_contractallocation"
                }
            };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public List<Entity> GetDeliverablesForAllocation(Entity allocation)
        {
            List<Entity> deliverables = _crmManager.GetCrmEntities(new CrmLookupCriteria
            {
                EntityName = "sfa_contractdeliverable",
                LookupCriteria = new List<ColumnValueCriteria>
                {
                    new ColumnValueCriteria("sfa_contractallocationid", ConditionOperator.Equal, allocation.Id),
                    new ColumnValueCriteria("sfa_parentdeliverableid", ConditionOperator.Null)
                }
            });

            var childDeliverables = GetDeliverableHierarchy(deliverables);

            deliverables.AddRange(childDeliverables);

            return deliverables;
        }

        public List<Entity> GetNonAggregatePeriodsForContractDeliverable(Entity deliverable)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractdeliverableid", ConditionOperator.Equal, deliverable.Id),
                new ColumnValueCriteria("sfa_aggregate", ConditionOperator.Equal, false)
            };

            var lookupCriteria = new CrmLookupCriteria
            {
                EntityName = "sfa_contractdeliverableperiod",
                LookupCriteria = columnValues
            };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public List<Entity> GetAggregatePeriodsForContractDeliverable(Entity deliverable)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractdeliverableid", ConditionOperator.Equal, deliverable.Id),
                // new ColumnValueCriteria("sfa_aggregate", ConditionOperator.Equal, false)
            };

            var lookupCriteria = new CrmLookupCriteria
            {
                EntityName = "sfa_contractdeliverableperiod",
                LookupCriteria = columnValues
            };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public string GetFundingTypeCode(Entity contract)
        {
            var fundingType = contract.GetAttributeValue<EntityReference>("sfa_fundingtype");
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_fundingtypeid", ConditionOperator.Equal, fundingType.Id)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_fundingtype", LookupCriteria = columnValues };
            var fundingTypeEntity = _crmManager.GetCrmEntities(lookupCriteria).First();
            return fundingTypeEntity.GetAttributeValue<string>("sfa_fundingtypecode");
        }

        public string GetContractType(Entity contract)
        {
            var contractTypeEntityRef = contract.GetAttributeValue<EntityReference>("sfa_contracttype");
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contracttypeid", ConditionOperator.Equal, contractTypeEntityRef.Id)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contracttype", LookupCriteria = columnValues };
            var fundingTypeEntity = _crmManager.GetCrmEntities(lookupCriteria).First();
            return fundingTypeEntity.GetAttributeValue<string>("sfa_name");
        }

        public string GetMasterContractNumberFromContract(Entity contract)
        {
            var contractEntityRef = contract.GetAttributeValue<EntityReference>("sfa_parentcontractid");
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractid", ConditionOperator.Equal, contractEntityRef.Id)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };
            var contractEntity = _crmManager.GetCrmEntities(lookupCriteria).First();
            return contractEntity.GetAttributeValue<string>("sfa_number");
        }

        public string GetFundingStreamCodeFromAllocation(Entity allocation)
        {
            var fundingStreamEntityId = allocation.GetAttributeValue<EntityReference>("sfa_fundingstreamid");
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_fundingstreamid", ConditionOperator.Equal, fundingStreamEntityId.Id)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_fundingstream", LookupCriteria = columnValues };
            var contractEntity = _crmManager.GetCrmEntities(lookupCriteria).First();
            return contractEntity.GetAttributeValue<string>("sfa_fundingstreamcode");
        }

        /// <summary>
        ///     TODO: code this
        /// </summary>
        /// <param name="contract"></param>
        /// <returns></returns>
        public PeriodInfo GetPeriodInfo(Entity contract)
        {
            var periodInfo = new PeriodInfo();
            var linkPeriodType = new LinkEntity
            {
                LinkFromAttributeName = "sfa_periodtypeid",
                LinkToEntityName = "sfa_periodtype",
                LinkToAttributeName = "sfa_periodtypeid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet(true),
                EntityAlias = "pt"
            };

            var periodIdEntityRef = contract.GetAttributeValue<EntityReference>("sfa_periodid");
            if (periodIdEntityRef != null)
            {
                var columnValues = new List<ColumnValueCriteria>
                {
                    new ColumnValueCriteria("sfa_periodid", ConditionOperator.Equal, periodIdEntityRef.Id)
                };

                var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_period", LookupCriteria = columnValues, LinkEntities = new[] { linkPeriodType } };
                var periodEntity = _crmManager.GetCrmEntities(lookupCriteria).First();
                periodInfo.Peiod = periodEntity.Attributes["sfa_period"].ToString();
                periodInfo.PeriodTypeCode =
                    periodEntity.GetAttributeValue<AliasedValue>("pt.sfa_periodtypecode").Value.ToString();
            }

            return periodInfo;
        }

        public Entity GetContractNumberForContractAllocationsInCrmForFundingStream(string fundingStream)
        {
            const int ALLOCATION_TYPE = 229660002;

            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_fundingstreamcode", ConditionOperator.Equal, fundingStream)
            };
            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_fundingstream", LookupCriteria = columnValues };
            var fundingStreamEntity = _crmManager.GetCrmEntities(lookupCriteria).FirstOrDefault();

            columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractnumbertype", ConditionOperator.Equal, ALLOCATION_TYPE),
                new ColumnValueCriteria("sfa_fundingstreamid", ConditionOperator.Equal, fundingStreamEntity.Attributes["sfa_fundingstreamid"])
            };
            lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contractnumber", LookupCriteria = columnValues };

            return _crmManager.GetCrmEntities(lookupCriteria).FirstOrDefault();
        }

        public List<Entity> GetOrganisation(string ukprn)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.Equal, ukprn)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "account", LookupCriteria = columnValues };
            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public void DeleteOrganisation(string ukprn)
        {
            const string MASTER_CONTRACT = "229660001";

            var organisations = GetOrganisation(ukprn);
            if (organisations.Count > 0)
            {
                var organisation = organisations[0];

                var contractsForOrg = GetContractsInCrmForUkPrns(new List<object> { ukprn }, false);

                // delete sub contracts first
                foreach (var contract in contractsForOrg)
                {
                    var heirarchyType = (contract.Attributes["sfa_hierarchytype"] as OptionSetValue).Value.ToString();
                    if (heirarchyType != MASTER_CONTRACT)
                    {
                        DeleteContract(contract);
                    }
                }

                foreach (var contract in contractsForOrg)
                {
                    var heirarchyType = (contract.Attributes["sfa_hierarchytype"] as OptionSetValue).Value.ToString();
                    if (heirarchyType == MASTER_CONTRACT)
                    {
                        DeleteContract(contract);
                    }
                }

                _crmManager.ConnectAsUser().Delete(organisation);
            }
        }

        public int? GetOptionsetValue(string optionsetName, string label)
        {
            return _crmManager.GetOptionsetValue(optionsetName, label);
        }

        public void Delete(Entity entity)
        {
            ActionRetrier.RetryWhenExceptionThrown(() => _crmManager.Delete(entity));
        }

        public IEnumerable<Entity> GetContractsForContractNumber(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, contractNumber)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public IEnumerable<Entity> GetContractsForUKPRN(string partukprn)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_hierarchytype", ConditionOperator.Equal, 229660000),
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.BeginsWith, partukprn)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

            return _crmManager.GetCrmEntities(lookupCriteria);
        }

        public IEnumerable<Entity> GetMasterContractsForUKPRN(string partukprn)
        {
           var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_hierarchytype", ConditionOperator.Equal, 229660001),
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.BeginsWith, partukprn)
            };

           var lookupCriteria = new CrmLookupCriteria { EntityName = "sfa_contract", LookupCriteria = columnValues };

           return _crmManager.GetCrmEntities(lookupCriteria);
        }
        
        private List<Entity> GetDeliverableHierarchy(List<Entity> deliverableEntities)
        {
            var foundDeliverables = new List<Entity>();

            foreach (Entity entity in deliverableEntities)
            {
                var childDeliverables = _crmManager.GetCrmEntities(new CrmLookupCriteria
                {
                    EntityName = "sfa_contractdeliverable",
                    LookupCriteria = new List<ColumnValueCriteria>
                    {
                        new ColumnValueCriteria("sfa_parentdeliverableid", ConditionOperator.Equal, entity.Id)
                    }
                });

                if (childDeliverables.Any())
                {
                    foundDeliverables.AddRange(childDeliverables);
                    foundDeliverables.AddRange(GetDeliverableHierarchy(childDeliverables));
                }
            }

            return foundDeliverables;
        }
    }
}