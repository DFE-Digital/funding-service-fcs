namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Microsoft.Xrm.Sdk;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;

    partial class ContractsManager
    {
        public Guid CreateNewAmendedContract(ExtendedContractType masterContract, string correlationId)
        {
            ExtendedContractType childContract = masterContract.contracts.First();
            ISet<contractor> distinctOrganisations = GetDistinctContractors(childContract);
            distinctOrganisations.ForEach(CreateOrganisationIfNecessary);

            LookupManager.BatchId = BatchId;
            if (masterContract.contracts.Count > 0)
            {
                masterContract.contractType1 = masterContract.contracts[0].contractType1;
            }

            _translator = new CrmTranslator(LookupManager);
            LookupCriteria lookupCriteria = GetLookupCriteria(masterContract);

            LookupManager.Lookup(lookupCriteria);

            Entity masterContractEntity = GetContractEntity(masterContract.contractNumber, masterContract.contractVersionNumber);
            
            EntityCollection subContractCollection = ProcessSubContract(masterContract);            

            Entity subContract =  subContractCollection.Entities.Single();

            AddMasterRelationshipToSubContract(subContract, masterContractEntity);

            AddAttributesToEntityThatAreNotOnTheExtendedContractType(subContractCollection, correlationId);

            return OrganizationService.Create(subContract);
        }

        private void AddMasterRelationshipToSubContract(Entity subContractEntity, Entity masterContractEntity)
        {
            EntityReference er = new EntityReference(CrmEntityName.Contract, masterContractEntity.Id);
            subContractEntity.Attributes.Add(CrmContractFieldName.ParentContract, er);
        }

        private Entity GetContractEntity(string contractNumber, int versionNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                 new ColumnValueCriteria(CrmContractFieldName.Number, ConditionOperator.Equal, contractNumber),
                 new ColumnValueCriteria(CrmContractFieldName.Version, ConditionOperator.Equal, versionNumber),
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria, OrganizationService).Single();
        }
    }
}
