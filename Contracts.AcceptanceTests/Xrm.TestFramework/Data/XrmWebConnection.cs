// <copyright file="XrmWebConfiguration.cs" company="Ciber">
//     Company Copyright
// </copyright>

namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using NUnit.Framework.Legacy;

    /// -----------------------------------------------------------------
    /// Namespace:      Ciber.Xrm.Tests.MetaData
    /// Class:          XrmWebConfiguration
    /// Description:    Class for handling the loading of a Dynamics CRM Configuration - including loading from a solution file from the Dynamics CRM Service
    /// Notes:          
    /// Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary>
    ///     Class used for loading and validating the Dynamics CRM Configuration from the Dynamics CRM Web Service
    /// </summary>
    public class XrmWebConnection : IDisposable
    {
        #region Fields

        public readonly CrmOrganisationService crmOrganisationService;

        #endregion

        #region Constructors

        /// <summary>
        /// </summary>
        /// <summary>
        ///     Initializes a new instance of the XrmWebConfiguration class
        /// </summary>
        /// <param name="connectionString">Dynamics CRM 2013 Connection string</param>
        public XrmWebConnection(string connectionString)
        {
            ExportRelationshipRoles = true;
            ExportOutlookSynchronizationSettings = true;
            ExportMarketingSettings = true;
            ExportIsvConfig = true;
            ExportGeneralSettings = true;
            ExportEmailTrackingSettings = true;
            ExportCustomizationSettings = true;
            ExportCalendarSettings = true;
            ExportAutoNumberingSettings = true;
            ConnectionString = connectionString;

            crmOrganisationService = new CrmOrganisationService(ConnectionString);
        }

        public XrmWebConnection(IOrganizationService organizationService)
        {
            ExportRelationshipRoles = true;
            ExportOutlookSynchronizationSettings = true;
            ExportMarketingSettings = true;
            ExportIsvConfig = true;
            ExportGeneralSettings = true;
            ExportEmailTrackingSettings = true;
            ExportCustomizationSettings = true;
            ExportCalendarSettings = true;
            ExportAutoNumberingSettings = true;

            crmOrganisationService = new CrmOrganisationService(organizationService);
        }

        #endregion

        #region properties

        public string ConnectionString { get; set; }

        public string SolutionName { get; set; }

        public bool Managed { get; set; }

        public string OutputFolder { get; set; }

        public bool ExportAutoNumberingSettings { get; set; }

        public bool ExportCalendarSettings { get; set; }

        public bool ExportCustomizationSettings { get; set; }

        public bool ExportEmailTrackingSettings { get; set; }

        public bool ExportGeneralSettings { get; set; }

        public bool ExportIsvConfig { get; set; }

        public bool ExportMarketingSettings { get; set; }

        public bool ExportOutlookSynchronizationSettings { get; set; }

        public bool ExportRelationshipRoles { get; set; }

        #endregion

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        //public void DownloadSolution()
        //{
        //    // Obtain an organization service proxy.
        //    // The using statement assures that the service proxy will be properly disposed.
        //    // this.organizationService = new CRMOrganizationService(xrmConnection);
        //    // using (var organizationService = new CrmOrganisationService(this.ConnectionString))
        //    try
        //    {
        //        var exporter = new ExportSolution(crmOrganisationService)
        //        {
        //            ExportAutoNumberingSettings = ExportAutoNumberingSettings,
        //            ExportCalendarSettings = ExportCalendarSettings,
        //            ExportCustomizationSettings = ExportCustomizationSettings,
        //            ExportEmailTrackingSettings = ExportEmailTrackingSettings,
        //            ExportGeneralSettings = ExportGeneralSettings,
        //            ExportIsvConfig = ExportIsvConfig,
        //            ExportMarketingSettings = ExportMarketingSettings,
        //            ExportOutlookSynchronizationSettings = ExportOutlookSynchronizationSettings,
        //            ExportRelationshipRoles = ExportRelationshipRoles
        //        };

        //        var filename = exporter.Export(OutputFolder, SolutionName, Managed);

        //        var args = new PackagerArguments
        //        {
        //            Action = CommandAction.Extract,
        //            Folder = OutputFolder + '\\' + SolutionName,
        //            PathToZipFile = OutputFolder + '\\' + SolutionName + ".zip",
        //            AllowDeletes = AllowDelete.No,
        //            AllowWrites = AllowWrite.Yes,
        //            Clobber = false,
        //            LocaleTemplate = "Auto",
        //            SingleComponent = "None",
        //            ErrorLevel = TraceLevel.Info,
        //            LogFile = string.Empty
        //        };

        //        var packager = new SFA.FCT.Xrm.TestFramework.Data.SolutionPackager(args);

        //        packager.Run();

        //        // Retrieve All Entities from the web service
        //        ////RetrieveAllEntitiesRequest requestAllEntities = new RetrieveAllEntitiesRequest()
        //        ////{
        //        ////    EntityFilters = EntityFilters.Attributes,
        //        ////    RetrieveAsIfPublished = true
        //        ////};

        //        //// Retrieve the MetaData.
        //        ////    RetrieveAllEntitiesResponse response = (RetrieveAllEntitiesResponse)this.organizationService.Execute(requestAllEntities);

        //        //// Load entity metadata info into Entities Array via LINQ Query
        //        ////  this.entities = (from e in response.EntityMetadata select new XrmWebEntity(e)).ToArray();
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine("An exception was thrown " + ex.InnerException);
        //        throw;
        //    }
        //}

        public XrmWebEntity GetUser(XrmPackageEntity entityMetadata, string recordIdentitier, bool allColumns = true)
        {
            return GetRecord(entityMetadata, recordIdentitier, "fullname", allColumns);
        }

        public XrmWebEntity GetRecord(XrmPackageEntity entityMetadata, string recordIdentitier, string fieldName = "", bool allColumns = true)
        {
            if (string.IsNullOrWhiteSpace(fieldName))
            {
                fieldName = entityMetadata.PrimaryAttribute().LogicalName;
            }

            var xrmWebEntity =
                new XrmWebEntity(crmOrganisationService, entityMetadata, fieldName, recordIdentitier)
                    .GetLatestRecord(allColumns);

            return xrmWebEntity;
        }

        public XrmWebEntity GetRecordNoAssert(XrmPackageEntity entityMetadata, string recordIdentitier, string fieldName = "")
        {
            if (string.IsNullOrWhiteSpace(fieldName))
            {
                fieldName = entityMetadata.PrimaryAttribute().LogicalName;
            }

            var xrmWebEntity =
                new XrmWebEntity(crmOrganisationService, entityMetadata, fieldName, recordIdentitier)
                    .GetLatestRecordNoAssert();

            return xrmWebEntity;
        }

        public XrmWebEntity GetUniqueRecord(XrmPackageEntity entityMetadata, string recordIdentitier, string fieldName = "")
        {
            if (string.IsNullOrWhiteSpace(fieldName))
            {
                fieldName = entityMetadata.PrimaryAttribute().LogicalName;
            }

            var matchingRecords =
                new XrmWebEntity(crmOrganisationService, entityMetadata, fieldName, recordIdentitier)
                    .GetMatchingRecords();

            ClassicAssert.IsTrue(
                matchingRecords.Count > 0,
                "The entity " + entityMetadata.LogicalName + " does not contain row with key of " + fieldName +
                " with value " + recordIdentitier);

            ClassicAssert.IsTrue(
                matchingRecords.Count < 2,
                "The entity " + entityMetadata.LogicalName + " does not contain a unique row with key of " + fieldName +
                " with value " + recordIdentitier);

            return matchingRecords.First();
        }

        public IList<XrmWebEntity> GetRecords(XrmPackageEntity entityMetadata, string recordIdentitier, string fieldName = "")
        {
            if (string.IsNullOrWhiteSpace(fieldName))
            {
                fieldName = entityMetadata.PrimaryAttribute().LogicalName;
            }

            var matchingRecords =
                new XrmWebEntity(crmOrganisationService, entityMetadata, fieldName, recordIdentitier)
                    .GetMatchingRecords();

            return matchingRecords;
        }

        /// <summary>
        ///     Overloaded method to allow a list of XrmWebEntity records to be returned given a dictionary containing a list of
        ///     filters
        /// </summary>
        /// <param name="entityMetadata">The entity metadata for the record type to be returned</param>
        /// <param name="filterList">
        ///     A Dictionary of <![CDATA[<string,object>]]> values corresponding to the filters Key = fieldname, Value= filter
        ///     value
        /// </param>
        /// <returns>An IList of XrmWebEntity records</returns>
        public IList<XrmWebEntity> GetPartMatchingRecords(XrmPackageEntity entityMetadata, Dictionary<string, object> filterList, LogicalOperator logicalOperator = LogicalOperator.And, bool allColumns = true)
        {
            //ClassicAssert.IsTrue(filterList.Any(), "No filters supplied for filter list");

            var query = new QueryExpression(entityMetadata.LogicalName)
            {
                ColumnSet = new ColumnSet(allColumns),
                Criteria = new FilterExpression()
            };
            var filter = query.Criteria.AddFilter(logicalOperator);

            if (filterList != null && filterList.Count > 0)
            {
                filterList.ToList().ForEach(f => filter.AddCondition(f.Key, ConditionOperator.Like, "%" + f.Value + "%"));
            }

            query.Orders.Add(new OrderExpression("createdon", OrderType.Descending));

            var primaryFieldName = entityMetadata.PrimaryAttribute().LogicalName.ToLowerInvariant();
            if (!allColumns)
            {
                query.ColumnSet.AddColumn(primaryFieldName);
            }

            var entityCollection = crmOrganisationService.RetrieveMultiple(query);

            var entitiesList =
                entityCollection
                    .Entities
                    .Select(e =>
                        new XrmWebEntity(crmOrganisationService, entityMetadata, primaryFieldName, e.Attributes[primaryFieldName].ToString(), e.Id)
                        {
                            Entity = e
                        })
                    .ToList();

            return entitiesList;
        }


        /// <summary>
        ///     Overloaded method to allow a list of XrmWebEntity records to be returned given a dictionary containing a list of
        ///     filters
        /// </summary>
        /// <param name="entityMetadata">The entity metadata for the record type to be returned</param>
        /// <param name="filterList">
        ///     A Dictionary of <![CDATA[<string,object>]]> values corresponding to the filters Key = fieldname, Value= filter
        ///     value
        /// </param>
        /// <returns>An IList of XrmWebEntity records</returns>
        public IList<XrmWebEntity> GetRecords(XrmPackageEntity entityMetadata, Dictionary<string, object> filterList, LogicalOperator logicalOperator = LogicalOperator.And, bool allColumns = true)
        {
            //ClassicAssert.IsTrue(filterList.Any(), "No filters supplied for filter list");

            var query = new QueryExpression(entityMetadata.LogicalName)
            {
                ColumnSet = new ColumnSet(allColumns),
                Criteria = new FilterExpression()
            };
            var filter = query.Criteria.AddFilter(logicalOperator);

            if (filterList != null && filterList.Count > 0)
            {
                filterList.ToList().ForEach(f => filter.AddCondition(f.Key, ConditionOperator.Equal, f.Value));
            }

            query.Orders.Add(new OrderExpression("createdon", OrderType.Descending));

            var primaryFieldName = entityMetadata.PrimaryAttribute().LogicalName.ToLowerInvariant();
            if (!allColumns)
            {
                query.ColumnSet.AddColumn(primaryFieldName);
            }

            var entityCollection = crmOrganisationService.RetrieveMultiple(query);

            var entitiesList =
                entityCollection
                    .Entities
                    .Select(e =>
                        new XrmWebEntity(crmOrganisationService, entityMetadata, primaryFieldName, e.Attributes[primaryFieldName].ToString(), e.Id)
                        {
                            Entity = e
                        })
                    .ToList();

            return entitiesList;
        }

        /// <summary>
        /// Create an XrmWebEntity object with only the id attribute value set
        /// </summary>
        /// <param name="entityMetadata">The entity metadata for the record type to be created</param>
        /// <param name="recordGuid">Guid of the record to create</param>
        /// <returns></returns>
        public XrmWebEntity GetEmptyXrmWebEntity(XrmPackageEntity entityMetadata, Guid recordGuid)
        {
            return new XrmWebEntity(crmOrganisationService, entityMetadata, recordGuid);
        }

        public void CheckNoMatchingRecords(XrmPackageEntity entityMetadata, string recordIdentitier, string fieldName = "")
        {
            if (string.IsNullOrWhiteSpace(fieldName))
            {
                fieldName = entityMetadata.PrimaryAttribute().LogicalName;
            }

            var matchingRecords =
                new XrmWebEntity(crmOrganisationService, entityMetadata, fieldName, recordIdentitier)
                    .GetMatchingRecords();

            ClassicAssert.IsTrue(
                matchingRecords.Count == 0,
                "The entity " + entityMetadata.LogicalName + " contains " + matchingRecords.Count + " row(s) with key of " + fieldName +
                " with value " + recordIdentitier);
        }

        public XrmWebEntity SetRecord(XrmPackageEntity entityMetadata, string recordIdentitier)
        {
            var fieldName = entityMetadata.PrimaryAttribute().LogicalName;

            var xrmWebEntity =
                new XrmWebEntity(crmOrganisationService, entityMetadata, fieldName, recordIdentitier).SetRecord();

            return xrmWebEntity;
        }

        public ExecuteMultipleResponse CreateRecords(XrmPackageEntity entityMetadata, IList<XrmWebEntity> entities)
        {
            ClassicAssert.IsTrue(entities.Any(), "No entities supplied");
            Dictionary<string, object> filterList = new Dictionary<string, object>();

            var createWithResults = new ExecuteMultipleRequest()
            {
                // Assign settings that define execution behavior: continue on error, return responses. 
                Settings = new ExecuteMultipleSettings()
                {
                    ContinueOnError = false,
                    ReturnResponses = true
                },
                Requests = new OrganizationRequestCollection()
            };

            foreach (XrmWebEntity xrmWebEntity in entities)
            {
                CreateRequest createRequest = new CreateRequest { Target = xrmWebEntity.Entity };
                createWithResults.Requests.Add(createRequest);
            }

            // Execute all the requests in the request collection using a single web method call.
            ExecuteMultipleResponse responseWithResults =
                (ExecuteMultipleResponse)crmOrganisationService.Execute(createWithResults);

            return responseWithResults;
        }

        public IList<XrmWebEntity> CreateAndGetRecords(XrmPackageEntity entityMetadata, IList<XrmWebEntity> entities)
        {
            ExecuteMultipleResponse responseWithResults = CreateRecords(entityMetadata, entities);

            var query = new QueryExpression(entityMetadata.LogicalName)
            {
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };
            var f = query.Criteria.AddFilter(LogicalOperator.Or);

            var idColumn = entityMetadata.IdAttribute();

            // Display the results returned in the responses.
            foreach (var responseItem in responseWithResults.Responses)
            {
                // A valid response.
                if (responseItem.Response != null)
                {
                    var id = responseItem.Response.Results["id"];
                    f.AddCondition(idColumn.LogicalName, ConditionOperator.Equal, id);
                }
            }

            var entityCollection = crmOrganisationService.RetrieveMultiple(query);

            var entitiesList = new List<XrmWebEntity>();

            foreach (var e in entityCollection.Entities)
            {
                var primaryFieldName = entityMetadata.PrimaryAttribute().LogicalName.ToLowerInvariant();
                entitiesList.Add(
                    new XrmWebEntity(
                        crmOrganisationService,
                        entityMetadata,
                        primaryFieldName,
                        e.Attributes[primaryFieldName].ToString(),
                        e.Id)
                    {
                        Entity = e
                    });
            }

            return entitiesList;
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                // free managed resources
                if (crmOrganisationService != null)
                {
                    crmOrganisationService.Dispose();
                }
            }
        }
    }
}