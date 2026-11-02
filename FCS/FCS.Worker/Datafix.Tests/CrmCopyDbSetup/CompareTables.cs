namespace Datafix.Tests.CrmCopyDbSetup
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Text;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCS.Worker.Common.Crm;

    [TestClass]
    public class CompareTables
    {
        private static readonly string ConnectionStringCrmReplica = ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;
        private const string ConnectionStringCrmOnPrem = "Data Source=fcs-pp-sql-01.preprod.fcs.sfa.bis.gov.uk;" + 
                                                         "Initial Catalog=SkillsFundingAgencyTEST_MSCRM;Persist Security Info=True;" + 
                                                         "User ID=svc-fcs-integritychecker;Password=";

        [TestMethod, TestCategory("CrmCopyDbSetup_CheckTables")]
        public void Tables_ShouldHaveEquivalentRowsAndCols()
        {
            List<string> tables = new List<string>
            {
                // tables with issues
                //"[sfa_claimreconciliationpublicationexception",
                //"[sfa_fundingtypefundingperiod",
                //"[sfa_contract",
                //"[sfa_contractallocation",
                //"[sfa_fundingtype_fundingstream",
                //"[sfa_taskaction",
                //"[sfa_transition",
                //"[sfa_caseload",
                //"[sfa_fundingclaimreconciliation",
                //"[sfa_fcrallocation",
                //"[sfa_fcrallocationdeliverable",
                //"[sfa_notification",
                //"[task",
                //"[sfa_contracttransitionhistory",
                //"[sfa_contractdeliverable",
                //"[sfa_subnominalaggregation",

                // complete list of tables
                "[sfa_agency",
                "[sfa_cappinggroups",
                "[sfa_claimreconallocgroup",
                "[sfa_claimreconciliationbehaviour",
                "[sfa_claimreconciliationpublicationexception",
                "[sfa_claimtype",
                "[sfa_contractnumber",
                "[sfa_contracttype",
                "[sfa_deliverable",
                "[sfa_period",
                "[sfa_fundingstream",
                "[sfa_fundingstreamperiod",
                "[sfa_fundingstreamperioddeliverable",
                "[sfa_fundingtype",
                "[sfa_fundingtypefundingperiod",
                "[sfa_paymenttimetable",
                "[sfa_unitofprocurement",
                "[sfa_contract",
                "[sfa_contractallocation",
                "[sfa_investmentpriority",
                "[sfa_periodtype",
                "[sfa_regiontype",
                "[sfa_specificationtitle",
                "[sfa_fundingtype_fundingstream",
                "[sfa_status",
                "[sfa_taskaction",
                "[sfa_transition",
                "[sfa_process",
                "[sfa_webserviceresource",
                "[sfa_caseload",
                "[account",
                "[sfa_fundingclaimreconciliation",
                "[sfa_fcrallocation",
                "[sfa_fcrallocationdeliverable",
                "[sfa_notification",
                "[task",
                "[sfa_contracttransitionhistory",
                "[sfa_contractdeliverable",
                "[sfa_subnominalaggregation",
                //"[sfa_sfa_subnominalaggregation_sfa_contracta",
                "[sfa_contractdeliverableperiod",
            };
            StringBuilder stringBuilder = new StringBuilder();
            try
            {
                tables.ForEach(t => CompareTable(t, text =>
                {
                    stringBuilder.Append(text);
                    stringBuilder.Append(System.Environment.NewLine);
                }));
            }
            catch (Exception e)
            {
                stringBuilder.Append($"Error {e.Message}, {e.StackTrace}");
            }
            Assert.Fail(stringBuilder.ToString());
        }

        [TestMethod, TestCategory("CrmCopyDbSetup_CheckEntitiesToTables")]
        public void Tables_ShouldHaveEquivalentRowsAndColsInCrmVsReplicaCopy()
        {
            List<string> tables = new List<string>
            {
                // tables with issues
                //"[sfa_claimreconciliationpublicationexception",
                //"[sfa_fundingtypefundingperiod",
                //"[sfa_contract",
                //"[sfa_contractallocation",
                //"[sfa_fundingtype_fundingstream",
                //"[sfa_taskaction",
                //"[sfa_transition",
                //"[sfa_caseload",
                //"[sfa_fundingclaimreconciliation",
                //"[sfa_fcrallocation",
                //"[sfa_fcrallocationdeliverable",
                //"[sfa_notification",
                //"[task",
                //"[sfa_contracttransitionhistory",
                //"[sfa_contractdeliverable",
                //"[sfa_subnominalaggregation",

                // complete list of tables
               // "[sfa_agency",
                //"[sfa_cappinggroups",
                //"[sfa_claimreconallocgroup",
                //"[sfa_claimreconciliationbehaviour",
                //"[sfa_claimreconciliationpublicationexception",
                //"[sfa_claimtype",
                //"[sfa_contractnumber",
                //"[sfa_contracttype",
                //"[sfa_deliverable",
                //"[sfa_period",
                //"[sfa_fundingstream",
                //"[sfa_fundingstreamperiod",
                //"[sfa_fundingstreamperioddeliverable",
                //"[sfa_fundingtype",
                //"[sfa_fundingtypefundingperiod",
                //"[sfa_paymenttimetable",
                //"[sfa_unitofprocurement",
                //"[sfa_contract",
                //"[sfa_contractallocation",
                //"[sfa_investmentpriority",
                //"[sfa_periodtype",
                //"[sfa_regiontype",
                //"[sfa_specificationtitle",
                //"[sfa_fundingtype_fundingstream",
                //"[sfa_status",
                //"[sfa_taskaction",
                //"[sfa_transition",
                //"[sfa_process",
                //"[sfa_webserviceresource",
                //"[sfa_caseload",
                //"[account",
                //"[sfa_fundingclaimreconciliation",
                //"[sfa_fcrallocation",
                //"[sfa_fcrallocationdeliverable",
                //"[sfa_notification",
                //"[task",
                //"[sfa_contracttransitionhistory",
                //"[sfa_contractdeliverable",
               // "[sfa_subnominalaggregation",
                ////"[sfa_sfa_subnominalaggregation_sfa_contracta",
                "[sfa_contractdeliverableperiod",
            };
            StringBuilder stringBuilder = new StringBuilder();
            try
            {
                tables.ForEach(t => CompareCrmToReplicaCopyTable(t, text =>
                {
                    stringBuilder.Append(text);
                    stringBuilder.Append(System.Environment.NewLine);
                }));
            }
            catch (Exception e)
            {
                stringBuilder.Append($"Error {e.Message}, {e.StackTrace}");
            }
            Assert.Fail(stringBuilder.ToString());
        }

        private static void CompareCrmToReplicaCopyTable(string tableName, Action<string> writeToLog)
        {
            EntityCollection entityCollection = GetDataFromCrmOnlineEntity(tableName.Substring(1));
            var crmOnPremTableName = $"{tableName}Base]";
            
            var sfaColumns = entityCollection.Entities.SelectMany(e => e.Attributes.Select(a => a.Key)).ToHashSet().Where(colName => colName.StartsWith("sfa_")).ToList();

            sfaColumns.Add("Id");
            
            var totalNumRows = entityCollection.Entities.Count;
            var columnsCsv = string.Join(", ", sfaColumns);

            List<dynamic> replicaTableRows = GetDataFromReplicaTable($"{tableName}]", columnsCsv, 0, totalNumRows);
            var replicaTableRowsAsDictionary = replicaTableRows.ToDictionary(r => r.Id);

            List<Dictionary<string, object>> crm365Rows = entityCollection.Entities.Select(e =>
                {

                    Dictionary<string, object> columnsWithValues = e.Attributes.ToDictionary(a => a.Key, a => TranformCrmValue(a.Value));
                    columnsWithValues.Add("Id", e.Id);

                    return columnsWithValues;
                })
                .ToList();


            var rowDifferenceResults = crm365Rows.Select((crm365Row, i) =>
            {
                //var replicaRow = replicaTableRows[i];
                List<RowColumnDifference> rowColumnResults = new List<RowColumnDifference>();
                dynamic replicaRow;
                
                if (replicaTableRowsAsDictionary.TryGetValue(crm365Row["Id"], out replicaRow))
                {
                    var replicaRowDict = replicaRow as IDictionary<string, object>;

                    rowColumnResults = crm365Row.Select(kv => new RowColumnDifference(replicaRowDict[kv.Key], kv.Value, kv.Key)).ToList();
                }
                else
                {
                    writeToLog($@"{DateTime.Now} Id not found in replica: {crm365Row["Id"]}");
                }
                
                var keyValuesNotMatching = rowColumnResults.Where(
                    res =>
                    {
                        if (res.ColName.StartsWith("sfa_"))
                        {
                            if (res.ReplicaValue is decimal)
                            {
                                return !res.ReplicaValue.Equals(res.OnPremValue);
                            }
                            return res.OnPremValueAsString != res.ReplicaValueAsString;
                        }

                        return false;

                    }).ToList();

                return new RowDifferenceResult(i, keyValuesNotMatching);
            }).ToList();

            writeToLog($@"{DateTime.Now} failures rows: {rowDifferenceResults.Count}");
            var failureColumns = rowDifferenceResults.SelectMany(r => r.NotMatchingKeyValues.Select(a => a.ColName)).ToHashSet();
            if (!failureColumns.Any())
            {
                failureColumns.Add("0");
            }

            var issues = rowDifferenceResults.Where(r => r.NotMatchingKeyValues.Any()).ToList();
            writeToLog($@"{DateTime.Now} Columns with failures: {string.Join(",", failureColumns)}");

            writeToLog($@"{DateTime.Now} Finished Compare table: {tableName}");
        }

        private static object TranformCrmValue(object crmValue)
        {
            if (crmValue is EntityReference entityReference)
            {
                return entityReference.Id;
            }
            if (crmValue is Money cash)
            {
                return cash.Value;
            }
            if (crmValue is OptionSetValue option)
            {
                return option.Value;
            }

            return crmValue;
        }

        private static EntityCollection GetDataFromCrmOnlineEntity(string tableName)
        {
            return ExecuteQuery(CreateQueryExpression(tableName));
        }

        private static QueryExpression CreateQueryExpression(string entityName)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = entityName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression(),

            };

            return query;
        }

        private static EntityCollection ExecuteQuery(QueryExpression query)
        {
            EntityCollection entityCollection = new EntityCollection();
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest();
            rmr.Query = query;

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest();
            emr.Requests = new OrganizationRequestCollection();
            emr.Requests.Add(rmr);
            emr.Settings = new ExecuteMultipleSettings();
            emr.Settings.ReturnResponses = true;

            const int queryCount = 100;
            int pageNumber = 1;

            query.PageInfo = new PagingInfo();
            query.PageInfo.Count = queryCount;
            query.PageInfo.PageNumber = pageNumber;

            while (true)
            {
                var pageEntityCollection = CrmConnectionFactory.GetOrganizationService().RetrieveMultiple(query);
                entityCollection.Entities.AddRange(pageEntityCollection.Entities);

                if (pageEntityCollection.MoreRecords)
                {
                    
                    // Increment the page number to retrieve the next page.
                    query.PageInfo.PageNumber++;

                    // Set the paging cookie to the paging cookie returned from current results.
                    query.PageInfo.PagingCookie = entityCollection.PagingCookie;
                }
                else
                {
                    break;
                }
            }
            
            return entityCollection;
        }

        private static void CompareTable(string tableName, Action<string> writeToLog)
        {
            writeToLog($@"{DateTime.Now} Starting to Compare table: {tableName}");
            var crmOnPremTableName = $"{tableName}Base]";
            var sfaColumnDataRowInfo = GetColumnsPrefixedWith(crmOnPremTableName, "sfa_");
            var sfaColumns = sfaColumnDataRowInfo.ColumnNames;
            var columnsCsv = string.Join(", ", sfaColumns);
            var totalNumRows = GeCountOftDataFromCrmOnPremTable(crmOnPremTableName);
            const int pageSize = 100000;

            var failures = new List<RowDifferenceResult>();
            var failureColumns = new HashSet<string>();
            int numberOfRowsWithProblems = 0;
            for (var totalRowIndex = 0; totalRowIndex <= totalNumRows; totalRowIndex += pageSize)
            {
                var crmOnPremTableRows = GetDataFromCrmOnPremTable(crmOnPremTableName, columnsCsv, sfaColumnDataRowInfo.PrimaryKeyName, totalRowIndex, pageSize);

                var replicaTableRows = GetDataFromReplicaTable($"{tableName}]", columnsCsv, totalRowIndex, pageSize);

                if (crmOnPremTableRows.Count != replicaTableRows.Count)
                {
                    writeToLog($@"{DateTime.Now} ** Row Counts do not match, crmOnPremTableRows.Count : {crmOnPremTableRows.Count}
                                replicaTableRows.Count: {replicaTableRows.Count}");
                    break;
                }
                var rowDifferenceResults = crmOnPremTableRows.Select((r, i) =>
                {
                    var replicaRow = replicaTableRows[i];
                    var onPremRowDict = r as IDictionary<string, object>;
                    var replicaRowDict = replicaRow as IDictionary<string, object>;

                    var rowColumnResults = onPremRowDict.Select(kv => new RowColumnDifference(replicaRowDict[kv.Key], kv.Value, kv.Key)).ToList();

                    var keyValuesNotMatching = rowColumnResults.Where(
                        res =>
                        {
                            if (res.ReplicaValue is decimal)
                            {
                                return !res.ReplicaValue.Equals(res.OnPremValue);
                            }
                            return res.OnPremValueAsString != res.ReplicaValueAsString;
                        }).ToList();

                    return new RowDifferenceResult(i, keyValuesNotMatching);
                }).ToList();

                var pageFailures = rowDifferenceResults.Where(d => d.NotMatchingKeyValues.Any()).ToList();
                numberOfRowsWithProblems += pageFailures.Count;
                //failures.AddRange(pageFailures);
                pageFailures.ForEach(pageFailure =>
                    pageFailure.NotMatchingKeyValues.Select(n => n.ColName).ToList()
                        .ForEach(col => failureColumns.Add(col)));
            }
            
            writeToLog($@"{DateTime.Now} failures rows: {numberOfRowsWithProblems}");

            writeToLog($@"{DateTime.Now} Columns with failures: {string.Join(",", failureColumns)}");
            
            writeToLog($@"{DateTime.Now} Finished Compare table: {tableName}");
        }

        private static ColumnDataRowInfo GetColumnsPrefixedWith(string tableName, string prefix)
        {
            var sql = $@"SELECT
                            c.name 'ColumnName',
                            ISNULL(i.is_primary_key, 0) 'IsPrimaryKey'
                        FROM
                            sys.columns c
                        LEFT OUTER JOIN
                            sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
                        LEFT OUTER JOIN
                            sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
                        WHERE
                            c.object_id = OBJECT_ID('{tableName}')";

            using (var connection = new SqlConnectionWithRetry(ConnectionStringCrmOnPrem))
            {
                var allColumnDataRows = connection.Query<ColumnDataRow>(sql).ToList();
                var columnDataRows = allColumnDataRows.Where(c => c.ColumnName.StartsWith(prefix)).ToList();

                return new ColumnDataRowInfo(columnDataRows.Select(c => c.ColumnName).ToList(), allColumnDataRows.First(c => c.IsPrimaryKey == 1).ColumnName);
            }
        }

        private static int GeCountOftDataFromCrmOnPremTable(string tableName)
        {
            using (var connection = new SqlConnectionWithRetry(ConnectionStringCrmOnPrem))
            {
                return connection.ExecuteScalar<int>($"select count(1) from {tableName}");
            }
        }

        private static List<dynamic> GetDataFromCrmOnPremTable(string tableName, string columns, string primaryKey, int skip, int pageSize)
        {
            const int tenMinutesTimeout = 60 * 10;

            using (var connection = new SqlConnectionWithRetry(ConnectionStringCrmOnPrem))
            {
                var sql = $"select {columns} from {tableName} order by {primaryKey}" +
                          $" OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";
                return connection.Query<dynamic>(sql, new { @skip = skip, @pageSize = pageSize }, commandTimeout: tenMinutesTimeout).ToList();

                // specific for table [sfa_sfa_subnominalaggregation_sfa_contracta]
                //string sql = $"select sfa_subnominalaggregationid, sfa_contractallocationid " +
                //             $"from sfa_sfa_subnominalaggregation_sfa_contracta order by [sfa_contractallocationid],[sfa_subnominalaggregationid]" +
                //             $" OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";
                //return connection.Query<dynamic>(sql, new { @skip = skip, @pageSize = pageSize }, commandTimeout: tenMinutesTimeout).ToList();
            }
        }

        private static List<dynamic> GetDataFromReplicaTable(string tableName, string columns, int skip, int pageSize)
        {
            const int tenMinutesTimeout = 60 * 10;

            using (var connection = new SqlConnectionWithRetry(ConnectionStringCrmReplica))
            {
                var sql = $"select {columns} from {tableName} order by id" +
                          $" OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";
                return connection.Query<dynamic>(sql, new { @skip = skip, @pageSize = pageSize }, commandTimeout: tenMinutesTimeout).ToList();

                // specific for table [sfa_sfa_subnominalaggregation_sfa_contracta]
                //string sql = $"select sfa_subnominalaggregationid, sfa_contractallocationid " +
                //             $"from sfa_sfa_subnominalaggregation_sfa_contracta order by [sfa_contractallocationid],[sfa_subnominalaggregationid]" +
                //             $" OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";
                //return connection.Query<dynamic>(sql, new { @skip = skip, @pageSize = pageSize }, commandTimeout: tenMinutesTimeout).ToList();
            }
        }
        
        private class ColumnDataRowInfo
        {
            public ColumnDataRowInfo(List<string> columnNames, string primaryKeyName)
            {
                ColumnNames = columnNames;
                PrimaryKeyName = primaryKeyName;
            }

            public List<string> ColumnNames { get; }

            public string PrimaryKeyName { get; }
        }

        private class ColumnDataRow
        {
            public ColumnDataRow()
            {
            }

            public string ColumnName { get; set; }

            public int IsPrimaryKey { get; set; }
        }

        private class RowDifferenceResult
        {
            public RowDifferenceResult(int row, List<RowColumnDifference> notMatchingKeyValues)
            {
                Row = row;
                NotMatchingKeyValues = notMatchingKeyValues;
            }

            public int Row { get; }

            public List<RowColumnDifference> NotMatchingKeyValues { get; }
        }

        private class RowColumnDifference
        {
            public RowColumnDifference(object onPremValue, object replicaValue, string colName)
            {
                OnPremValue = onPremValue;
                ReplicaValue = replicaValue;
                ColName = colName;
            }

            public object OnPremValue { get; }

            public object ReplicaValue { get; }

            public string OnPremValueAsString
            {
                get
                {
                    if (OnPremValue == null)
                    {
                        return string.Empty;
                    }

                    return OnPremValue.ToString();
                }
            }

            public string ReplicaValueAsString
            {
                get
                {
                    if (ReplicaValue == null)
                    {
                        return string.Empty;
                    }

                    return ReplicaValue.ToString();
                }
            }

            public string ColName { get; }
        }
    }
}
