// <copyright file="XrmWebEntity.cs" company="Ciber">
//     Company Copyright
// </copyright>

namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.InteropServices;
    using System.Text;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using NUnit.Framework.Legacy;

    /// -----------------------------------------------------------------
    /// Namespace:      Ciber.Xrm.Tests.MetaData
    /// Class:          XrmWebEntity
    /// Description:    Class for handing the Entity Metadata for a single Dynamics CRM entity
    /// Notes:          
    /// Author:         Dean Holmes
    /// -----------------------------------------------------------------
    /// <summary>
    ///     Class used for handling Dynamics CRM Configuration of a single Dynamics CRM entity
    /// </summary>
    public class XrmWebEntity
    {
        private const string BlankValue = "<Blank>";
        private readonly CrmOrganisationService _crmOrganisationService;
        private readonly string _entityLogicalName, _primaryFieldName, _recordIdentitier;
        private readonly XrmPackageEntity _entityMetadata;
        private Entity _entity;
        private Guid? _recordGuid;

        #region Constructors

        /// <summary>
        ///     Initializes a new instance of the XrmWebEntity class - used for querying entities and attributes
        /// </summary>
        /// <param name="crmOrganisationService"></param>
        /// <param name="entityMetadata"></param>
        /// <param name="fieldName"></param>
        /// <param name="recordIdentitier"></param>
        /// <param name="recordGuid"></param>
        /// <param name="entityMetaData">Entity MetaData as returned by the Dynamics CRM Web Service</param>
        public XrmWebEntity(CrmOrganisationService crmOrganisationService, XrmPackageEntity entityMetadata, string fieldName, string recordIdentitier, Guid? recordGuid = null)
        {
            _entityMetadata = entityMetadata;
            _recordGuid = recordGuid;
            _entityLogicalName = entityMetadata.LogicalName.ToLowerInvariant();
            _primaryFieldName = fieldName.ToLowerInvariant();
            _recordIdentitier = recordIdentitier;
            _crmOrganisationService = crmOrganisationService;
        }

        public XrmWebEntity(CrmOrganisationService crmOrganisationService, XrmPackageEntity entityMetadata, Guid recordGuid)
        {
            _entityMetadata = entityMetadata;
            _recordGuid = recordGuid;
            _entityLogicalName = entityMetadata.LogicalName.ToLowerInvariant();
            _crmOrganisationService = crmOrganisationService;
            _entity = new Entity(entityMetadata.LogicalName);
        }
        #endregion

        #region properties

        public Guid Id
        {
            get { return _entity != null ? _entity.Id : (_recordGuid ?? Guid.Empty); }
        }

        public Entity Entity
        {
            get { return _entity; }
            internal set { _entity = value; }
        }

        #endregion

        #region Methods

        public XrmWebEntity GetLatestRecord(bool allColumns = true)
        {
            var entity = GetLatestRecordNoAssert(allColumns);

            ClassicAssert.IsTrue(
                entity != null,
                "The entity " + _entityLogicalName + " does not contain row with key of " + _primaryFieldName +
                " with value " + _recordIdentitier);

            return entity;
        }

        public XrmWebEntity GetLatestRecordNoAssert(bool allColumns = true)
        {
            ClassicAssert.IsTrue(!string.IsNullOrWhiteSpace(_entityLogicalName), "The Entity has not been set");
            ClassicAssert.IsTrue(_crmOrganisationService != null, "The xrmWebConnection has not been set");

            if (_recordGuid == null)
            {
                var query = new QueryExpression(_entityLogicalName)
                {
                    ColumnSet = new ColumnSet(allColumns),
                    Criteria = new FilterExpression()
                };
                query.Criteria.AddCondition(_primaryFieldName, ConditionOperator.Equal, _recordIdentitier);
                query.Orders.Add(new OrderExpression("createdon", OrderType.Descending));

                var sb = new StringBuilder(1000);

                var entityCollection = _crmOrganisationService.RetrieveMultiple(query);

                if (entityCollection == null || entityCollection.Entities.Count == 0)
                {
                    return null;
                }

                _entity = entityCollection.Entities[0];
                return this;
            }

            _entity = _crmOrganisationService.Retrieve((Guid)_recordGuid, _entityLogicalName);
            return this;
        }

        public XrmWebEntity SetRecord()
        {
            ClassicAssert.IsTrue(!string.IsNullOrWhiteSpace(_entityLogicalName), "The Entity has not been set");
            ClassicAssert.IsTrue(_crmOrganisationService != null, "The xrmWebConnection has not been set");

            var entity = new Entity(_entityLogicalName)
            {
                Attributes = new AttributeCollection()
            };
            _entity = entity;

            SetField(_primaryFieldName, _recordIdentitier);

            return this;
        }

        public XrmWebEntity Update()
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            // Update the entity
            _crmOrganisationService.Update(_entity);

            return this;
        }

        public XrmWebEntity UpdateStatus()
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            var setState = new SetStateRequest();

            setState.EntityMoniker = new EntityReference(_entity.LogicalName, _entity.Id);
            setState.State = (OptionSetValue)_entity.Attributes["statecode"];
            setState.Status = (OptionSetValue)_entity.Attributes["statuscode"];

            // Update the entity
            _crmOrganisationService.Execute(setState);

            return this;
        }

        public XrmWebEntity Create()
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            // Update the entity
            _recordGuid = _crmOrganisationService.Create(_entity);

            return this;
        }

        public void Delete()
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            _crmOrganisationService.Delete(_entity);
        }

        public XrmWebEntity UpdateField(string fieldName, object value)
        {
            SetField(fieldName, value);
            Update();
            return this;
        }

        public XrmWebEntity UpdateLookupField(XrmPackageEntity relatedEntity, string fieldName, XrmWebEntity value)
        {
            SetLookupField(relatedEntity, fieldName, value);
            Update();

            return this;
        }

        public XrmWebEntity SetField(string fieldName, object value)
        {
            var attribute = GetAttribute(fieldName);

            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");
            ClassicAssert.IsTrue(_crmOrganisationService != null, "The xrmWebConnection has not been set");

            // Update the postal code attribute.
            object crmValue = null;
            decimal decValue = 0;
            switch (attribute.dataType)
            {
                case XrmDataType.DateTime:
                    ClassicAssert.IsTrue(value is DateTime, "The Test Value " + value + " is not set DateTime");
                    crmValue = ((DateTime)value).ToUniversalTime();
                    break;

                case XrmDataType.Decimal:
                    if (decimal.TryParse(value.ToString(), out decValue))
                    {
                        crmValue = decValue;
                    }
                    else
                    {
                        ClassicAssert.Fail("Test Value is not a Decimal");
                    }

                    crmValue = decValue;
                    break;

                case XrmDataType.Money:
                    if (decimal.TryParse(value.ToString(), out decValue))
                    {
                        crmValue = new Money(decValue);
                    }
                    else
                    {
                        ClassicAssert.Fail("Test Value is not a Microsoft.Xrm.Sdk.Money");
                    }

                    break;

                case XrmDataType.TwoOptions:
                    if (value is bool)
                    {
                        crmValue = (bool)value;
                    }
                    else if (value is string)
                    {
                        var parsedBool = false;
                        if (bool.TryParse((string)value, out parsedBool))
                        {
                            crmValue = parsedBool;
                        }
                        else
                        {
                            crmValue = GetBool((string)value);
                        }
                    }
                    else if (value is int)
                    {
                        crmValue = GetBool((int)value);
                    }
                    else
                    {
                        ClassicAssert.Fail("The Attribute " + fieldName + " is not set as 'TwoValues / bool");
                    }

                    break;

                case XrmDataType.State:
                case XrmDataType.Status:
                case XrmDataType.OptionSet:
                    var intValue = 0;
                    if (attribute.OptionSetValues != null && !int.TryParse(value.ToString(), out intValue))
                    {
                        intValue = attribute.OptionSetValues[value.ToString()];
                    }

                    if (intValue > 0)
                    {
                        crmValue = new OptionSetValue(intValue);
                    }
                    else
                    {
                        ClassicAssert.Fail("Test Value is not an OptionSet");
                    }

                    break;

                case XrmDataType.WholeNumber:
                    crmValue = value;
                    break;

                case XrmDataType.Text:
                case XrmDataType.Memo:
                default:
                    crmValue = value.ToString();
                    break;
            }

            if (_entity.Contains(attribute.LogicalName))
            {
                _entity[attribute.LogicalName] = crmValue;
            }
            else
            {
                _entity.Attributes.Add(attribute.LogicalName, crmValue);
            }

            return this;
        }

        public XrmWebEntity SetLookupField(XrmPackageEntity relatedEntity, string fieldName, XrmWebEntity value)
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            var relationship = relatedEntity.Relationship(_entity.LogicalName, fieldName);

            var relName = relationship.LogicalName;
            if (relName == "owninguser" || relName == "owningteam")
            {
                relName = "ownerid";
            }

            if (relationship.LogicalName != null &&_entity.Contains(relationship.LogicalName))
            {
                var field = _entity.Attributes[relationship.LogicalName];

                if (field is EntityReference)
                {
                    if (value != null)
                    {
                        _entity.Attributes[relName] =
                            new EntityReference(value._entity.LogicalName, value._entity.Id);
                    }
                    else
                    {
                        _entity.Attributes[relName] = new EntityReference();
                    }
                }
                else
                {
                    ClassicAssert.Fail("The entity " + relatedEntity.DisplayName + " does not have link");
                }
            }
            else
            {
                if (value != null)
                {
                    _entity.Attributes.Add(relName, new EntityReference(value._entity.LogicalName, value._entity.Id));
                }
            }

            return this;
        }

        public XrmWebEntity SetOwner(XrmWebEntity value)
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            if (value != null)
            {
                var user = new EntityReference(value._entity.LogicalName, value._entity.Id);
                if (_entity.Attributes.ContainsKey("ownerid"))
                {
                    _entity.Attributes["ownerid"] = user;
                }
                else
                {
                    _entity.Attributes.Add(
                        "ownerid",
                        user);
                }
            }

            return this;
        }

        public XrmWebEntity IsNull(string fieldName)
        {
            ClassicAssert.IsTrue(this._entity != null, "The Entity has not been set");
            bool containsKey = this._entity.Attributes.ContainsKey(fieldName);
            ClassicAssert.IsTrue(containsKey == false, fieldName + "was not null");
            return this;
        }

        public XrmWebEntity FieldValueEquals(string fieldName, object testValue)
        {
            var returnEntity = FieldValue(XrmFieldValueComparison.Equals, fieldName, testValue);

            return returnEntity;
        }

        public XrmWebEntity FieldValue(XrmFieldValueComparison fieldValueComparison, string fieldName, object testValue)
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            var attribute = GetAttribute(fieldName);
            object field;

            if (attribute.dataType != XrmDataType.TwoOptions)
            {
                ClassicAssert.IsTrue(_entity.Contains(attribute.LogicalName), "The Entity does not contain " + fieldName);
                field = _entity.Attributes[attribute.LogicalName];
            }
            else
            {
                field = _entity.Contains(attribute.LogicalName) && (bool)_entity.Attributes[attribute.LogicalName];
            }

            decimal decTestValue;
            int intTestValue;
            switch (attribute.dataType)
            {
                case XrmDataType.DateTime:
                    ClassicAssert.IsTrue(testValue is DateTime, "The Test Value " + testValue + " is not set DateTime");

                    var testValueDateTime = (DateTime)testValue;

                    testValueDateTime = testValueDateTime.TrimMilliseconds();

                    // TODO: This is a simplified solution to the DateTime issue with Dynamics CRM, it will not work if we want to assert on Date AND Time values
                    ClassicAssert.IsTrue(
                        CompareDateTimeValues(((DateTime)field).AddHours(12).Date, fieldValueComparison, testValueDateTime.Date),
                        "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " + testValue + " actually " + field);
                    break;

                case XrmDataType.Decimal:
                    if (decimal.TryParse(testValue.ToString(), out decTestValue))
                    {
                        ClassicAssert.IsTrue(
                            CompareDecimalValues((decimal)field, fieldValueComparison, decTestValue),
                            "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " + testValue + " actually " + field);
                    }
                    else
                    {
                        ClassicAssert.Fail("Test Value is not a Decimal");
                    }

                    break;

                case XrmDataType.Money:
                    if (decimal.TryParse(testValue.ToString(), out decTestValue))
                    {
                        ClassicAssert.IsTrue(
                            CompareDecimalValues(((Money)field).Value, fieldValueComparison, decTestValue),
                            "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " + decTestValue + " actually " + ((Money)field).Value);
                    }
                    else
                    {
                        ClassicAssert.Fail("Test Value is not a Microsoft.Xrm.Sdk.Money");
                    }

                    break;

                case XrmDataType.TwoOptions:
                    var parsedBool = false;
                    if (testValue is bool)
                    {
                        parsedBool = (bool)testValue;
                    }
                    else if (testValue is string)
                    {
                        if (!bool.TryParse((string)testValue, out parsedBool))
                        {
                            parsedBool = GetBool((string)testValue);
                        }
                    }
                    else if (testValue is int)
                    {
                        parsedBool = GetBool((int)testValue);
                    }
                    else
                    {
                        ClassicAssert.Fail($"Value {testValue} cannot be parsed to type bool");
                    }

                    ClassicAssert.IsTrue(
                        CompareBoolValues((bool)field, fieldValueComparison, parsedBool),
                        "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " + parsedBool + " actually " + field);

                    break;
                case XrmDataType.WholeNumber:
                    if (attribute.OptionSetValues != null && !int.TryParse(testValue.ToString(), out intTestValue))
                    {
                        ClassicAssert.IsTrue(
                            CompareIntegerValues((int)field, fieldValueComparison, intTestValue),
                            "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " +
                            testValue);
                    }

                    break;

                case XrmDataType.State:
                case XrmDataType.Status:
                case XrmDataType.OptionSet:
                    intTestValue = 0;
                    if (attribute.OptionSetValues != null && !int.TryParse(testValue.ToString(), out intTestValue))
                    {
                        intTestValue = attribute.OptionSetValues[testValue.ToString()];
                    }

                    if (field is OptionSetValue)
                    {
                        ClassicAssert.IsTrue(
                            CompareIntegerValues(((OptionSetValue)field).Value, fieldValueComparison, intTestValue),
                            "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " +
                            testValue);
                    }
                    else
                    {
                        ClassicAssert.Fail("Test Value is not an OptionSet");
                    }

                    break;

                case XrmDataType.Owner:
                    if (field != null && field is EntityReference)
                    {
                        ClassicAssert.IsTrue(
                            CompareTextValues(((EntityReference)field).Name, fieldValueComparison, testValue.ToString()),
                            "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " +
                            testValue);
                    }

                    break;

                case XrmDataType.Text:
                case XrmDataType.Memo:
                default:
                    ClassicAssert.IsTrue(
                        CompareTextValues((string)field, fieldValueComparison, (string)testValue),
                        "The field " + fieldName + " is not " + fieldValueComparison.ToDescription() + " the value " + testValue + " actually " + field);
                    break;
            }

            return this;
        }

        public Guid GetId()
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            return _entity.Id;
        }

        public object GetField(string fieldName)
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            var attribute = GetAttribute(fieldName);

            ClassicAssert.IsTrue(_entity.Contains(attribute.LogicalName), "The Entity does not contain " + fieldName);

            var field = _entity.Attributes[attribute.LogicalName];

            object crmValue;
            switch (attribute.dataType)
            {
                case XrmDataType.DateTime:
                    crmValue = (DateTime)field;
                    break;

                case XrmDataType.Decimal:
                    crmValue = (decimal)field;
                    break;

                case XrmDataType.Money:
                    crmValue = ((Money)field).Value;
                    break;

                case XrmDataType.TwoOptions:
                    crmValue = (bool)field;
                    break;

                case XrmDataType.OptionSet:
                    var intValue = ((OptionSetValue)field).Value;
                    crmValue = attribute.OptionSetList[intValue];
                    break;
                case XrmDataType.WholeNumber:
                    crmValue = (int)field;
                    break;
                case XrmDataType.Text:
                case XrmDataType.Memo:
                default:
                    crmValue = field.ToString();
                    break;
            }

            return crmValue;
        }

        public string GetLookupFieldName(XrmPackageEntity relatedEntity, string fieldName)
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            var relationship = relatedEntity.Relationship(_entity.LogicalName, fieldName);

            ClassicAssert.IsTrue(_entity.Contains(relationship.LogicalName), "The Entity does not contain a relationship to : " + relatedEntity.DisplayName);

            var field = _entity.Attributes[relationship.LogicalName];
            var stringField = string.Empty;
            if (field is EntityReference)
            {
                stringField = ((EntityReference)field).Name;
            }
            else
            {
                ClassicAssert.Fail("The field " + fieldName + " is not on  " + relatedEntity.DisplayName);
            }

            return stringField;
        }

        public XrmWebEntity LookupFieldValueEquals(XrmPackageEntity relatedEntity, string fieldName, string testValue)
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            var relationship = relatedEntity.Relationship(_entity.LogicalName, fieldName);

            if (testValue == null || testValue == BlankValue)
            {
                ClassicAssert.IsFalse(LookupFieldIsSet(relationship.LogicalName), "A value is specified for the field {0}", fieldName);
            }
            else
            {
                ClassicAssert.IsTrue(LookupFieldIsSet(relationship.LogicalName), "The Entity does not have a value for {0} ", fieldName);

                if (_entity.Attributes[relationship.LogicalName] is EntityReference)
                {
                    var testField = (EntityReference)_entity.Attributes[relationship.LogicalName];
                    ClassicAssert.AreEqual(
                        testValue,
                        testField.Name,
                        "The field " + relatedEntity.DisplayName + " does not equal " + testValue + " actually " +
                        testField.Name);
                }
            }

            return this;
        }

        public XrmWebEntity OwnerEquals(string value)
        {
            ClassicAssert.IsTrue(_entity != null, "The Entity has not been set");

            if (value != null && _entity.Attributes.Contains("ownerid"))
            {
                var field = _entity.Attributes["ownerid"];

                if (field is EntityReference)
                {
                    var testField = (EntityReference)field;
                    ClassicAssert.IsTrue(
                        testField.Name.Equals(value),
                        "The owner does not equal " + value + " actually " + testField.Name);
                }
            }
            else
            {
                ClassicAssert.Fail("The entity " + _entity.LogicalName + " is not owned by a user or team.");
            }

            return this;
        }

        public XrmWebEntity ReassignRecord(string newOwner)
        {
            ClassicAssert.IsTrue(!string.IsNullOrWhiteSpace(_entityLogicalName), "The Entity has not been set");
            ClassicAssert.IsTrue(_crmOrganisationService != null, "The xrmWebConnection has not been set");

            // Query to retrieve users.
            var querySystemUser = new QueryExpression
            {
                EntityName = "systemuser",
                ColumnSet = new ColumnSet("systemuserid", "fullname"),
                Criteria = new FilterExpression()
            };

            querySystemUser.Criteria.AddCondition("fullname", ConditionOperator.Equal, newOwner);

            var newOwnersRecords = _crmOrganisationService
                .RetrieveMultiple(querySystemUser).Entities;

            // Query to retrieve teams
            var queryTeam = new QueryExpression
            {
                EntityName = "team",
                ColumnSet = new ColumnSet("teamid", "name"),
                Criteria = new FilterExpression()
            };

            queryTeam.Criteria.AddCondition("name", ConditionOperator.Equal, newOwner);

            var newTeamsRecords = _crmOrganisationService.RetrieveMultiple(queryTeam).Entities;

            var usersCount = _crmOrganisationService.RetrieveMultiple(querySystemUser).Entities.Count;
            var teamsCount = _crmOrganisationService.RetrieveMultiple(queryTeam).Entities.Count;
            if (usersCount > 0)
            {
                var newOwnersId = (Guid)newOwnersRecords[0].Attributes["systemuserid"];

                var assign = new AssignRequest
                {
                    Assignee = new EntityReference("systemuser", newOwnersId),
                    Target = new EntityReference(_entityLogicalName, _entity.Id)
                };
                _crmOrganisationService.Execute(assign);
            }
            else if (teamsCount > 0)
            {
                var newOwnersId = (Guid)newTeamsRecords[0].Attributes["teamid"];

                var assign = new AssignRequest
                {
                    Assignee = new EntityReference("team", newOwnersId),
                    Target = new EntityReference(_entityLogicalName, _entity.Id)
                };
                _crmOrganisationService.Execute(assign);
            }
            else
            {
                ClassicAssert.Fail("The user or team " + newOwner + " does not exist in CRM ");
            }

            return this;
        }

        #region related methods

        public XrmWebEntity GetLatestRelatedRecord(XrmPackageEntity relatedEntityMetadata, [Optional, DefaultParameterValue("")] string relationshipName, [Optional] Dictionary<string, object> filterList)
        {
            ClassicAssert.IsTrue(!string.IsNullOrWhiteSpace(_entityLogicalName), "The Entity has not been set");
            ClassicAssert.IsTrue(_crmOrganisationService != null, "The xrmWebConnection has not been set");

            var relatedEntityName = relatedEntityMetadata.LogicalName;

            var relationship = _entityMetadata.Relationship(relatedEntityName, relationshipName);

            var query = new QueryExpression(relatedEntityName)
            {
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };
            query.Criteria.AddCondition(relationship.ReferencingAttributeName.ToLowerInvariant(), ConditionOperator.Equal, _entity.Id);

            if (filterList != null)
            {
                foreach (var f in filterList)
                {
                    query.Criteria.AddCondition(f.Key, ConditionOperator.Equal, f.Value);
                }
            }

            query.Orders.Add(new OrderExpression("createdon", OrderType.Descending));

            var entityCollection = _crmOrganisationService.RetrieveMultiple(query);

            ClassicAssert.IsTrue(
                entityCollection != null && entityCollection.Entities.Count > 0,
                "The entity " + relatedEntityName + " does not contain rows related to " + _entityLogicalName + " with value " + _recordIdentitier);

            var entity0 = entityCollection.Entities[0];
            var xrmWebEntity = new XrmWebEntity(
                _crmOrganisationService,
                relatedEntityMetadata,
                (relatedEntityMetadata.LogicalName + "id").ToLowerInvariant(),
                entity0.Id.ToString(),
                entity0.Id)
            {
                _entity = entity0
            };

            return xrmWebEntity;
        }

        public List<XrmWebEntity> GetRelatedRecords(XrmPackageEntity relatedEntityMetadata, [Optional, DefaultParameterValue("")] string relationshipName, [Optional] Dictionary<string, object> filterList)
        {
            ClassicAssert.IsTrue(!string.IsNullOrWhiteSpace(_entityLogicalName), "The Entity has not been set");
            ClassicAssert.IsTrue(_crmOrganisationService != null, "The xrmWebConnection has not been set");

            var relatedEntityName = relatedEntityMetadata.LogicalName;

            var relationship = _entityMetadata.Relationship(relatedEntityName, relationshipName);

            var query = new QueryExpression(relatedEntityName)
            {
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            query.Criteria.AddCondition(
                relationship.ReferencingAttributeName.ToLowerInvariant(),
                ConditionOperator.Equal,
                _entity.Id);

            if (filterList != null)
            {
                foreach (var f in filterList)
                {
                    query.Criteria.AddCondition(f.Key, ConditionOperator.Equal, f.Value);
                }
            }

            query.Orders.Add(new OrderExpression("createdon", OrderType.Descending));

            var entityCollection = _crmOrganisationService.RetrieveMultiple(query);

            ClassicAssert.IsTrue(
                entityCollection != null,
                "The entity " + _entityLogicalName + " does not contain row with key of " + _primaryFieldName +
                " with value " + _recordIdentitier);

            var list = new List<XrmWebEntity>();

            foreach (var entity in entityCollection.Entities)
            {
                var xrmWebEntity = new XrmWebEntity(
                    _crmOrganisationService,
                    relatedEntityMetadata,
                    (relatedEntityMetadata.LogicalName + "id").ToLowerInvariant(),
                    entity.Id.ToString(),
                    entity.Id)
                {
                    _entity = entity
                };

                list.Add(xrmWebEntity);
            }

            return list;
        }

        #endregion

        internal IList<XrmWebEntity> GetMatchingRecords()
        {
            ClassicAssert.IsTrue(!string.IsNullOrWhiteSpace(_entityLogicalName), "The Entity has not been set");
            ClassicAssert.IsTrue(_crmOrganisationService != null, "The xrmWebConnection has not been set");

            var query = new QueryExpression(_entityLogicalName)
            {
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };
            query.Criteria.AddCondition(_primaryFieldName, ConditionOperator.Equal, _recordIdentitier);
            query.Orders.Add(new OrderExpression("createdon", OrderType.Descending));

            var entityCollection = _crmOrganisationService.RetrieveMultiple(query);

            var entitiesList = new List<XrmWebEntity>();

            foreach (var e in entityCollection.Entities)
            {
                entitiesList.Add(
                    new XrmWebEntity(
                        _crmOrganisationService,
                        _entityMetadata,
                        _primaryFieldName,
                        _recordIdentitier,
                        e.Id));
            }

            return entitiesList;
        }

        #region static private

        private static bool GetBool(string condition)
        {
            return condition.ToLower() == "yes";
        }

        private static bool GetBool(int condition)
        {
            return 1 == condition;
        }

        #endregion

        private bool LookupFieldIsSet(string fieldName)
        {
            return _entity.Attributes.Contains(fieldName);
        }

        private XrmPackageAttribute GetAttribute(string fieldname)
        {
            var attribute = _entityMetadata.Attribute(fieldname);

            return attribute;
        }

        private bool CompareDateTimeValues(DateTime valueDateTime, XrmFieldValueComparison comparitorOperator, DateTime targetValueDate)
        {
            var returnValue = false;
            switch (comparitorOperator)
            {
                case XrmFieldValueComparison.Equals:
                    returnValue = valueDateTime.Equals(targetValueDate);
                    break;
                case XrmFieldValueComparison.NotEquals:
                    returnValue = !valueDateTime.Equals(targetValueDate);
                    break;
                case XrmFieldValueComparison.LessThan:
                    returnValue = valueDateTime < targetValueDate;
                    break;
                case XrmFieldValueComparison.GreaterThan:
                    returnValue = valueDateTime > targetValueDate;
                    break;
                case XrmFieldValueComparison.BeginsWith:
                    ClassicAssert.Fail("BeginsWith is only valid for Text Comparisons");
                    break;
                default:
                    returnValue = valueDateTime.Equals(targetValueDate);
                    break;
            }

            return returnValue;
        }

        private bool CompareDecimalValues(decimal valueDecimal, XrmFieldValueComparison comparitorOperator, decimal targetValueDecimal)
        {
            var returnValue = false;
            switch (comparitorOperator)
            {
                case XrmFieldValueComparison.Equals:
                    returnValue = valueDecimal == targetValueDecimal;
                    break;
                case XrmFieldValueComparison.NotEquals:
                    returnValue = valueDecimal != targetValueDecimal;
                    break;
                case XrmFieldValueComparison.LessThan:
                    returnValue = valueDecimal < targetValueDecimal;
                    break;
                case XrmFieldValueComparison.GreaterThan:
                    returnValue = valueDecimal > targetValueDecimal;
                    break;
                case XrmFieldValueComparison.BeginsWith:
                    ClassicAssert.Fail("BeginsWith is only valid for Text Comparisons");
                    break;
                default:
                    returnValue = valueDecimal.Equals(targetValueDecimal);
                    break;
            }

            return returnValue;
        }

        private bool CompareIntegerValues(int intValue, XrmFieldValueComparison comparitorOperator, int intTargetValue)
        {
            var returnValue = false;
            switch (comparitorOperator)
            {
                case XrmFieldValueComparison.Equals:
                    returnValue = intValue == intTargetValue;
                    break;
                case XrmFieldValueComparison.NotEquals:
                    returnValue = intValue != intTargetValue;
                    break;
                case XrmFieldValueComparison.LessThan:
                    returnValue = intValue < intTargetValue;
                    break;
                case XrmFieldValueComparison.GreaterThan:
                    returnValue = intValue > intTargetValue;
                    break;
                case XrmFieldValueComparison.BeginsWith:
                    ClassicAssert.Fail("BeginsWith is only valid for Text Comparisons");
                    break;
                default:
                    returnValue = intValue.Equals(intTargetValue);
                    break;
            }

            return returnValue;
        }

        private bool CompareOptionSetValues(bool boolValue, XrmFieldValueComparison comparitorOperator, bool boolTargetValue)
        {
            var returnValue = false;
            switch (comparitorOperator)
            {
                case XrmFieldValueComparison.Equals:
                    returnValue = boolValue == boolTargetValue;
                    break;
                case XrmFieldValueComparison.NotEquals:
                    returnValue = boolValue != boolTargetValue;
                    break;
                case XrmFieldValueComparison.LessThan:
                    ClassicAssert.Fail("Cannot compare boolean fields with anything other than Equals To or Not Equals To");
                    break;
                case XrmFieldValueComparison.GreaterThan:
                    ClassicAssert.Fail("Cannot compare boolean fields with anything other than Equals To or Not Equals To");
                    break;
                case XrmFieldValueComparison.BeginsWith:
                    ClassicAssert.Fail("BeginsWith is only valid for Text Comparisons");
                    break;
                default:
                    returnValue = boolValue.Equals(boolTargetValue);
                    break;
            }

            return returnValue;
        }

        private bool CompareBoolValues(bool boolValue, XrmFieldValueComparison comparitorOperator, bool boolTargetValue)
        {
            var returnValue = false;
            switch (comparitorOperator)
            {
                case XrmFieldValueComparison.Equals:
                    returnValue = boolValue == boolTargetValue;
                    break;
                case XrmFieldValueComparison.NotEquals:
                    returnValue = boolValue != boolTargetValue;
                    break;
                case XrmFieldValueComparison.LessThan:
                    ClassicAssert.Fail("Cannot compare boolean fields with anything other than Equals To or Not Equals To");
                    break;
                case XrmFieldValueComparison.GreaterThan:
                    ClassicAssert.Fail("Cannot compare boolean fields with anything other than Equals To or Not Equals To");
                    break;
                case XrmFieldValueComparison.BeginsWith:
                    ClassicAssert.Fail("BeginsWith is only valid for Text Comparisons");
                    break;
                default:
                    return boolValue.Equals(boolTargetValue);
            }

            return returnValue;
        }

        private bool CompareTextValues(string stringValue, XrmFieldValueComparison comparitorOperator, string stringTargetValue)
        {
            //// Adjust values from CRM - remove char(160) characters and replace with char(32) characters
            var adjustedStringValue = stringValue.Replace((char)160, (char)32).TrimEnd();

            var returnValue = false;
            switch (comparitorOperator)
            {
                case XrmFieldValueComparison.Equals:
                    returnValue = adjustedStringValue == stringTargetValue;
                    break;
                case XrmFieldValueComparison.NotEquals:
                    returnValue = adjustedStringValue != stringTargetValue;
                    break;
                case XrmFieldValueComparison.LessThan:
                    ClassicAssert.Fail("Cannot compare text fields with anything other than Equals To or Not Equals To");
                    break;
                case XrmFieldValueComparison.GreaterThan:
                    ClassicAssert.Fail("Cannot compare text fields with anything other than Equals To or Not Equals To");
                    break;
                case XrmFieldValueComparison.BeginsWith:
                    returnValue = adjustedStringValue.StartsWith(stringTargetValue);
                    break;
                default:
                    returnValue = adjustedStringValue.Equals(stringTargetValue);
                    break;
            }

            return returnValue;
        }
        #endregion
    }
}