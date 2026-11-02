namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities;
    using Microsoft.Xrm.Sdk;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Implementation.Entities;

    /// <summary>
    /// Translates the Contract to a CRM Entity
    /// </summary>
    public class CrmTranslator
    {
        private readonly ILookupManager _lookupManager;

        public CrmTranslator(ILookupManager lm)
        {
            _lookupManager = lm;
        }

        public Entity TranslateContract(ExtendedContractType contract)
        {
            Entity contractEntity = new Entity(CrmEntityName.Contract);
            PopulateAttributesViaFieldMapping(contractEntity, contract);

            return contractEntity;
        }

        public Entity TranslateContract(contractType contract)
        {
            Entity contractEntity = new Entity(CrmEntityName.Contract);
            PopulateAttributesViaFieldMapping(contractEntity, contract);

            return contractEntity;
        }

        public void PopulateAttributesViaFieldMapping<T>(Entity crmEntity, T schemaObj)
        {
            // All of the properties on the object that are not arrays should be mapped to a CRM column
            var nonArrayProperties = schemaObj.GetType().GetProperties().Where(prop => !prop.PropertyType.IsArray);
            foreach (var prop in nonArrayProperties)
            {
                // most mappings are 121 but some are 12Many so we need a collection of mappings for each property
                var crmMappingAttributes = CrmFieldMapper.GetMappings(schemaObj.GetType().Name, prop.Name);

                foreach (var crmMappingAttribute in crmMappingAttributes)
                {
                    if (crmMappingAttribute != null)
                    {
                        object propertyValue = prop.GetValue(schemaObj, null);
                        if (crmMappingAttribute.LookupType == CrmLookupType.NotSet)
                        {
                            // populate attribute for non lookup type
                            if (crmMappingAttribute.OptionSetType != CrmOptionSetType.NotSet)
                            {
                                if (!IsTypeFromMsStandardLibrary(prop.PropertyType))
                                {
                                    // this is a User Defined Type (e.g. Contractor) the primary key property of this object must be used
                                    propertyValue = CrmFieldMapper.GetPrimaryKeyFieldValue(propertyValue);
                                }

                                if (propertyValue != null)
                                {
                                    AddOptionSetColumn(crmMappingAttribute.OptionSetType, crmMappingAttribute.CrmColumnName, propertyValue.ToString(), crmEntity);
                                }
                            }
                            else
                            {
                                if (!IsTypeFromMsStandardLibrary(prop.PropertyType))
                                {
                                    // this is a User Defined Type (e.g. Contractor) the primary key property of this object must be used
                                    propertyValue = CrmFieldMapper.GetPrimaryKeyFieldValue(propertyValue);
                                }

                                if (!IsObjectDateTimeThatIsNotSet(propertyValue))
                                {
                                    // we do not want to add date values if they are not set
                                    if (crmMappingAttribute.ColumnType == CrmColumnType.NotSet)
                                    {
                                        crmEntity.Attributes.Add(crmMappingAttribute.CrmColumnName, propertyValue);
                                    }
                                    else if (crmMappingAttribute.ColumnType == CrmColumnType.Text)
                                    {
                                        crmEntity.Attributes.Add(crmMappingAttribute.CrmColumnName, propertyValue.ToString());
                                    }
                                    else if (crmMappingAttribute.ColumnType == CrmColumnType.Currency)
                                    {  // Changed for contractValue as that can be null with new schema change ref:12328
                                        crmEntity.Attributes.Add(crmMappingAttribute.CrmColumnName, new Money((decimal)(propertyValue??0.0M)));
                                    }
                                    else if (crmMappingAttribute.ColumnType == CrmColumnType.Decimal)
                                    {
                                        crmEntity.Attributes.Add(crmMappingAttribute.CrmColumnName, propertyValue);
                                    }
                                    else if (crmMappingAttribute.ColumnType == CrmColumnType.Integer)
                                    {
                                        AddIntegerColumn(propertyValue as string, crmMappingAttribute.CrmColumnName, crmEntity);
                                    }                                  
                                    else
                                    {
                                        throw new Exception(string.Format("crmMappingAttribute.ColumnType {0} not supported", crmMappingAttribute.ColumnType));
                                    }
                                }
                            }
                        }
                        else
                        {
                            PopulateAttributeForLookupType(crmEntity, prop.PropertyType, propertyValue, crmMappingAttribute, schemaObj);
                        }
                    }
                }
            }
        }

        private void PopulateAttributeForLookupType<T>(Entity crmEntity, Type propertyType, object propertyValue, CrmMappingAttribute crmMappingAttribute, T schemaObj)
        {
            Guid? id = null;
            if (!IsTypeFromMsStandardLibrary(propertyType))
            {
                // this is a User Defined Type (e.g. Period) the primary key property of this object must be used
                // to lookup the matching entity
                if (crmMappingAttribute.LookupType == CrmLookupType.FundingStreamPeriodCode)
                {
                    var compositeKey = CrmFieldMapper.GetFundingStreamPeriodPk(schemaObj as contractAllocationsContractAllocation);
                    id = _lookupManager.GetMatchingEntity(crmMappingAttribute.LookupType, compositeKey);
                }
                else if (schemaObj is contractType && crmMappingAttribute.LookupType == CrmLookupType.Period && (schemaObj as contractType).hierarchyType != hierarchyType.MASTERCONTRACT)
                {
                    var compositeKey = CrmFieldMapper.GetPeriodPk((schemaObj as contractType).period);
                    id = _lookupManager.GetMatchingEntity(crmMappingAttribute.LookupType, compositeKey);
                }
                else if (crmMappingAttribute.LookupType == CrmLookupType.Owner)
                {
                    AddOwnerColumn(propertyValue, crmMappingAttribute.CrmColumnName, crmEntity);
                }
                else if (crmMappingAttribute.ColumnType == CrmColumnType.EntityReference)
                {
                    id = (Guid?)propertyValue;
                }
                else
                {
                    string primaryKey = CrmFieldMapper.GetPrimaryKeyFieldValue(propertyValue);
                    id = _lookupManager.GetMatchingEntity(crmMappingAttribute.LookupType, primaryKey);
                }
            }
            else
            {
                if (crmMappingAttribute.ColumnType == CrmColumnType.EntityReference)
                {
                    id = (Guid?)propertyValue;
                }
                else
                {
                    id = _lookupManager.GetMatchingEntity(crmMappingAttribute.LookupType, propertyValue as string);
                }
            }

            if (id != null && id.Value != Guid.Empty)
            {
                EntityReference er = new EntityReference(crmMappingAttribute.LookupType.GetEntityDetail().EntityName, id.Value);
                crmEntity.Attributes.Add(crmMappingAttribute.CrmColumnName, er);
            }
        }

        private bool IsObjectDateTimeThatIsNotSet(object obj)
        {
            return obj is DateTime && ((DateTime)obj) == DateTime.MinValue;
        }

        private bool IsTypeFromMsStandardLibrary(Type type)
        {
            return type.Assembly.GetName().Name == "mscorlib";
        }

        private void AddOptionSetColumn(CrmOptionSetType optionSetType, string columnName, string value, Entity contractEntity)
        {
            int? optionVal = _lookupManager.GetOptionsetValue(optionSetType.GetOptionSetName(), optionSetType.GetOptionValue(value));
            if (optionVal.HasValue)
            {
                contractEntity.Attributes.Add(columnName, new OptionSetValue(optionVal.Value));
            }
        }

        private void AddIntegerColumn(string value, string columnName, Entity contractEntity)
        {
            if (!string.IsNullOrEmpty(value))
            {
                int res;

                if (int.TryParse(value, out res))
                {
                    contractEntity.Attributes.Add(columnName, res);
                }
            }
        }

        private void AddOwnerColumn(object propertyValue, string columnName, Entity crmEntity)
        {
            if (propertyValue != null)
            {
                var owner = (CrmEntityOwner)propertyValue;
                if (owner.OwnerId.HasValue && owner.OwnerId.Value != Guid.Empty)
                {
                    string entityName = (owner.OwnerType == OwnerType.SystemUser) ? "systemuser" : "team";

                    EntityReference er = new EntityReference(entityName, owner.OwnerId.Value);
                    crmEntity.Attributes.Add(columnName, er);
                }
            }
        }
    }
}